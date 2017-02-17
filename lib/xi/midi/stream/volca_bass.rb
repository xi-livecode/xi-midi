class Xi::MIDI::Stream
  module VolcaBass
    CC = {
      slide: 5,
      expression: 11,
      octave: 40,
      lforate: 41,
      lfoint: 42,
      pitch1: 43,
      pitch2: 44,
      pitch3: 45,
      attack: 46,
      decay: 47,
      cutoffegint: 48,
      bgate: 49
    }

    def cc_parameters
      CC
    end
  end
end
