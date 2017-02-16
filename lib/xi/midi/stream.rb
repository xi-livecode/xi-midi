require 'xi/stream'
require 'xi/midi/proxy'

module Xi::MIDI
  class Stream < Xi::Stream
    attr_accessor :device, :channel

    def initialize(name, clock, device: 0, channel: 0)
      super(name, clock)

      @device = device
      @channel = channel
      @playing_notes = {}

      midi.open(device) unless midi.open?(device)
      at_exit { kill_playing_notes }
    end

    def set(**params)
      super(gate: :midinote, **params)
    end

    def stop
      kill_playing_notes
      super
    end

    private

    def kill_playing_notes
      @mutex.synchronize do
        @playing_notes.each do |_, note|
          midi.note_off(@device, note[:channel], note[:midinote])
        end
        @playing_notes.clear
      end
    end

    def do_gate_on_change(changes)
      logger.debug "Gate on change: #{changes}"

      channel = Array(@state[:channel] || 0)
      midinote = Array(@state[:midinote] || 60)
      velocity = Array(@state[:velocity] || 127)

      changes.each do |change|
        change.fetch(:so_ids).each.with_index do |so_id, i|
          channel_i = channel[i % channel.size]
          midinote_i = midinote[i % midinote.size]
          velocity_i = velocity[i % velocity.size]

          logger.info "MIDI Note on: #{[channel_i, midinote_i, velocity_i]}"
          midi.note_on(@device, channel_i, midinote_i, velocity_i)

          @playing_notes[so_id] = {channel: channel_i, midinote: midinote_i}
        end
      end
    end

    def do_gate_off_change(changes)
      logger.debug "Gate off change: #{changes}"

      changes.each do |change|
        change.fetch(:so_ids).each do |so_id|
          note = @playing_notes.delete(so_id)
          if note
            logger.info "MIDI Note off: #{[note[:channel], note[:midinote]]}"
            midi.note_off(@device, note[:channel], note[:midinote])
          end
        end
      end
    end

    def do_state_change
      logger.debug "State change: #{changed_state}"

      changed_state.each do |p, vs|
        cc_id = cc_parameters[p]
        Array(vs).each { |v| midi.cc(@device, channel, cc_id, v.to_i) } if cc_id
      end
    end

    # @override
    def cc_parameters
      {}
    end

    def midi
      Proxy.instance
    end

    def latency_sec
      0.01
    end
  end
end
