require 'helper'

class ArisaidTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Arisaid::VERSION
  end
end
