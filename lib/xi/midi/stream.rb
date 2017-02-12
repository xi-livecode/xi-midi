require 'xi/stream'
require 'xi/midi/proxy'

module Xi::MIDI
  class Stream < ::Stream
    attr_accessor :device, :channel

    def initialize(clock, device: 0, channel: 0)
      super(clock)

      @device = device
      @channel = channel
      @playing_notes = {}

      midi.open(device)
      at_exit { kill_playing_notes }
    end

    def set(**params)
      params[:gate] = :midinote
      super(params)
    end

    def stop
      kill_playing_notes
      super
    end

    private

    def kill_playing_notes
      @playing_notes.each do |_, note|
        midi.note_off(@device, note[:channel], note[:midinote])
      end
      @playing_notes.clear
    end

    def do_gate_on_change(so_ids)
      channel = Array(@state[:channel] || 0)
      midinote = Array(@state[:midinote] || 60)
      velocity = Array(@state[:velocity] || 127)

      so_ids.each.with_index do |so_id, i|
        channel_i = channel[i % channel.size]
        midinote_i = midinote[i % midinote.size]
        velocity_i = velocity[i % velocity.size]

        logger.info "MIDI Note on: #{[channel_i, midinote_i, velocity_i]}"
        midi.note_on(@device, channel_i, midinote_i, velocity_i)

        @playing_notes[so_id] = {channel: channel_i, midinote: midinote_i}
      end
    end

    def do_gate_off_change(so_ids)
      so_ids.each do |so_id|
        note = @playing_notes.delete(so_id)
        if note
          logger.info "MIDI Note off: #{[note[:channel], note[:midinote]]}"
          midi.note_off(@device, note[:channel], note[:midinote])
        end
      end
    end

    def midi
      Proxy.instance
    end
  end
end
