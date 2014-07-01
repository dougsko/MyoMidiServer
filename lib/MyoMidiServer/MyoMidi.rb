require 'micromidi'

class MyoMidi   
    def initialize
        @output = UniMIDI::Output.use(:first)
        @midi = MIDI::IO.new(@output)
        @pose_time = 0
        @prev_event
        @current_event
        @long_hold = 2
        @locked = false
    end
    
    # orient: 40, 41, 42
    # accel: 43, 44, 45
    # diff: 46, 47, 48
    # world: 49
    def process_event(event_text)
        @prev_event = @current_event
        @current_event = MyoEvent.new(event_text)

        # set pose time
        if(@prev_event != nil and @current_event != nil)
            if(@prev_event.pose == @current_event.pose)
                @pose_time += @current_event.timeStamp.to_i - @prev_event.timeStamp.to_i
                puts @pose_time.to_s
            else
                @pose_time = 0
            end
        end

        # handle long poses
        if(@pose_time > @long_hold)
            case @current_event.pose
            when "fist"
                puts "long #{@current_event.pose} detected"
                all_off
            when "twistIn"
                @locked = not(@locked)
                if(@locked)
                    puts "Locked!"
                else
                    puts "Unlocked!"
                end
            else
                puts "long #{@current_event.pose} detected"
            end
        end

        if(@locked)
            return
        end
        
        case @current_event.pose
        when "fingersSpread"
            val1 = remap(@current_event.diffData[0].to_f, 0, 1, 0, 127)
            val1 = remap(@current_event.diffData[1].to_f, 0, 1, 0, 127)
            cc(41, val1)
            cc(42, val2)
        end

        #puts @current_event.inspect
    end
    
    # low1 = 0, high1 = 1
    # low2 = 0, high2 = 127
    def remap(value, low1, high1, low2, high2)
        (low2 + (value - low1) * (high2 - low2) / (high1 - low1)).to_i
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
