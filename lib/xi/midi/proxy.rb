require 'singleton'
require 'thread'
require 'rawmidi'

module Xi::MIDI
  class Proxy
    include Singleton

    MAX_CHANNELS = 16
    MAX_NOTES = 128
    NOTE_ON  = 0x90
    NOTE_OFF = 0x80
    CC = 0xb0

    def initialize
      @mutex = Mutex.new
      @outputs = RawMIDI::Output.all

      # Make sure to close outputs at exit
      at_exit do
        begin
          @outputs.each(&:close)
        rescue => err
          puts "Error when closing MIDI outputs: #{err}"
        end
      end
    end

    def list
      RawMIDI::Output.all.map.with_index { |o, i| [i, o] }
    end

    def open(device)
      unless @outputs[device]
        fail ArgumentError, "MIDI device #{device} not found"
      end
      @outputs[device].open
    end

    def open?(device)
      unless @outputs[device]
        fail ArgumentError, "MIDI device #{device} not found"
      end
      @outputs[device].open?
    end

    def note_on(device, channel, note, velocity)
      send_bytes(device, NOTE_ON + channel, note, velocity)
    end

    def note_off(device, channel, note)
      send_bytes(device, NOTE_OFF + channel, note, 0)
    end

    def cc(device, channel, id, value)
      send_bytes(device, CC + channel, id, value)
    end

    def reset_all
      @outputs.size.times { |i| reset(i) }
    end

    def reset(device)
      MAX_CHANNELS.times.each do |channel|
        MAX_NOTES.times.each do |note|
          note_off(device, channel, note)
        end
      end
    end

    private

    def send_bytes(device, *bytes)
      return unless open?(device)

      debug(:send_bytes, device, bytes)
      @mutex.synchronize { @outputs[device].write(bytes) }
    end
  end
end
