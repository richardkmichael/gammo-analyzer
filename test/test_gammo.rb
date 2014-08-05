require 'test_helper'

class GammoTest < MiniTest::Unit::TestCase
  def test_initialize_the_shit
    # what do we need?
    # database file
    assert_raises(ArgumentError) { GammoAnalyzer.new }
    assert_raises(ArgumentError) { GammoAnalyzer.new(nil) }
    GammoAnalyzer.new(Object.new)
  end
end
