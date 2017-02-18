require 'test_helper'

class Xi::MIDITest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Xi::MIDI::VERSION
  end
end
