class Xi::MIDI::Stream
  module VolcaKeys
    CC = {
      portamento: 5,
      expression: 11,
      voice: 40,
      detune: 42,
      vco_eg_int: 43,
      cutoff: 44,
      vcf_eg_int: 45,
      lfo_rate: 46,
      lfo_pitch_int: 47,
      lfo_cutoff_int: 48,
      attack: 49,
      decay: 50,
      sustain: 51,
      delay_time: 52,
      delay_feedback: 53,
    }

    def cc_parameters
      CC
    end
  end
end
