require 'eventmachine'

class MyoServer < EM::Connection
    def initialize
        puts "this might break things"
        @myo_midi = MyoMidi.new
    end

    def post_init
        puts "--- client connected to server!"
    end

    def receive_data(data)
        @myo_midi.process_event(data)
    end

end

