require 'eventmachine'

class MyoServer < EM::Connection
    def initialize(myo_midi)
        @myo_midi = myo_midi
    end

    def post_init
        puts "--- a client connected to server!"
    end

    def unbind
        puts "--- a client disconnected!"
    end

    def receive_data(data)
        @myo_midi.process_event(data)
    end

end

