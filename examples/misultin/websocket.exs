% This is a simple example of running Misultin with ExBridge
% and websockets. Execute this file from ex_brige root as:
%
%   elixir --no-halt -pa exbin examples/misultin/websocket.exs
%
% And then access localhost:8080 in your browser.
module Chat
  object Backend
    module Mixin
      def start
        { 'ok, _ } = GenServer.start_link({'local, 'chat_backend}, self.new, [])
      end

      def new_user(pid)
        GenServer.call('chat_backend, { 'new_user, pid })
      end

      def set_nick(pid, nick)
        GenServer.cast('chat_backend, { 'set_nick, pid, nick })
      end

      def send_message(pid, message)
        GenServer.cast('chat_backend, { 'message, pid, message })
      end
    end

    def initialize()
      @('users: {:})
    end

    def broadcast(message)
      @users.each do (pid, _)
        pid <- { 'chat_server, { 'message, message } }
      end
    end

    def init()
      Process.flag('trap_exit, true)
      { 'ok, self }
    end

    def handle_call({ 'new_user, pid }, _info)
      Process.link(pid) % Link to the given socket process
      updated = self.update_ivar('users, _.set(pid, "Unknown"))
      { 'reply, 'ok, updated }
    end

    def handle_call(_request, _from)
      { 'reply, 'undef, self }
    end

    def handle_cast({ 'set_nick, from, nick })
      updated = self.update_ivar('users, _.set(from, nick))
      { 'noreply, updated }
    end

    def handle_cast({ 'message, from, text })
      broadcast "#{@users[from]}: #{text}"
      { 'noreply, self }
    end

    def handle_cast(_request)
      { 'noreply, self }
    end

    def handle_info({ 'EXIT, from, _ })
      updated = self.update_ivar('users, _.delete(from))
      updated.broadcast "#{@users[from]} left the room."
      { 'noreply, updated }
    end

    def handle_info(_request)
      { 'noreply, self }
    end

    def terminate(_reason)
      'ok
    end

    def code_change(_old, _extra)
      { 'ok, self }
    end
  end

  module Server
    def start
      ExBridge::Misultin.start_link self, 'port: 8080,
        'docroot: "examples/assets", 'websockets: true
    end

    def stop
      Erlang.misultin.stop
    end

    def handle_websocket(socket)
      Chat::Backend.new_user(Process.self)
      socket_loop(socket)
    end

    def socket_loop(socket)
      receive
      match {'browser, data}
        string = data.to_bin
        IO.puts "SOCKET BROWSER #{string}"

        case string.split(~r" \<\- ", 2)
        match ["msg", msg]
          Chat::Backend.send_message(Process.self, msg)
        match ["nick", nick]
          Chat::Backend.set_nick(Process.self, nick)
        else
          socket.send "status <- received #{string}"
        end

        socket_loop(socket)
      match { 'chat_server, { 'message, message } }
        string = message.to_bin
        socket.send "output <- #{string}"
        socket_loop(socket)
      match other
        IO.puts "SOCKET UNKNOWN #{other}"
        socket_loop(socket)
      after 10000
        socket.send "tick"
        socket_loop(socket)
      end
    end

    def handle_http(request, response)
      response = case { request.request_method, request.path }
      match { 'GET, "/chat.html" }
        body = File.read File.join(response.docroot, "chat.html")
        response.set 200, { "Content-Type": "text/html" }, body
      match { 'GET, path }
        response.file path[1,-1]
      else
        response.set 404, {:}, "Not Found"
      end

      status = response.dispatch!
      IO.puts "HTTP #{request.request_method} #{status} #{request.path}"
    end
  end
end

% Boot

Code.prepend_path "deps/misultin/ebin"
Chat::Backend.start
Chat::Server.start
IO.puts "Starting on http://127.0.0.1:8080/"