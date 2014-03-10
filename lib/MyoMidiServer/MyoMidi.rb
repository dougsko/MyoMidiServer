require 'micromidi'

class MyoMidi   
    def initialize
        @output = UniMIDI::Output.use(:first)
        @midi = MIDI::IO.new(output)
    end
    
    # orient: 40, 41, 42
    # accel: 43, 44, 45
    # diff: 46, 47, 48
    # world: 49
    def process_event(event)
        if(event.type == 'control')
            if(event.command == 'allOff'
                all_off
            end
        end
        if(event.type == 'orient')
            cc(40, convert(event.values[0]))
            cc(41, convert(event.values[1]))
            cc(42, convert(event.values[2]))
        end
    end
    
    def convert(num)
        old_value = num.to_f
        old_min = 0
        old_max = 255
        new_max = 50
        new_min = 20
        (((old_value - old_min) / (old_max - old_min) ) * (new_max - new_min) + new_min).to_i
    end
    
    def cc(channel, value)
        @midi.cc(channel, value)
    end
    
    def note_on(note, vel)
        @midi.note(note, vel)
    end
    
    def note_off(note)
        @midi.note_off(note)
    end
    
    def all_off
        0.upto(127) do |i|
            @midi.note_off(i)
        end
    end
    
end