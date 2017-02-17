module Xi::MIDI
  module VolcaBeats
    CC = {
      lKick: 40,
      lSnare: 41,
      lLoTom: 42,
      lHiTom: 43,
      lClHat: 44,
      lOpHat: 45,
      lClap: 46,
      lClaves: 47,
      lAgogo: 48,
      lCrash: 49,
      sClap: 50,
      sClaves: 51,
      sAgogo: 52,
      sCrash: 53,
      stutterTime: 54,
      stutterDepth: 55,
      tomDecay: 56,
      clHatDecay: 57,
      opHatDecay: 58,
      hatGrain: 59,
    }

    DRUMS = {
      bd: 36,
      sn: 38,
      lt: 43,
      ht: 50,
      ch: 42,
      oh: 46,
      cp: 39,
      cl: 75,
      ag: 67,
      cr: 49,
    }

    def cc_parameters
      CC
    end

    def reduce_to_midinote
      if !changed_param?(:midinote) && changed_param?(:drum)
        Array(@state[:drum]).map { |n| DRUMS[n.to_sym] }.compact
      else
        super
      end
    end
  end
end
