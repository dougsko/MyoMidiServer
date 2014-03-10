Dir.glob('./lib/MyoMidiServer/*.rb', &method(:require))

module MyoMidiServer  
    def self.start_server(port, timeout, verbose)
        @srv = MyoServer.new( port, timeout, verbose )
        loop do
            if sock = @srv.get_socket
                message = sock.gets("\r\n").chomp("\r\n")
                yield message
            end
        end
    end   
end