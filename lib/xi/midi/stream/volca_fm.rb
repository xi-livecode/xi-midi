class Xi::MIDI::Stream
  module VolcaFM
    CC = {
      h_octave: 40,
      h_velocity: 41,
      mod_attack: 42,
      mod_decay: 43,
      car_attack: 44,
      car_decay: 45,
      lfo: 46,
      lfo_pitchint: 47,
      algtm: 48,
      arp: 49,
      arpdiv: 50
    }

    def cc_parameters
      CC
    end
  end

	VolcaFm = VolcaFM
end
