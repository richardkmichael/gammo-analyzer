require 'test_helper'

class ConfigurationTest < MiniTest::Unit::TestCase
  def setup
    @configuration = GammoAnalyzer::Configuration.new(database: 'mydb')
  end

  def test_requires_a_database
    assert_raises(ArgumentError) { GammoAnalyzer::Configuration.new() }

    configuration = GammoAnalyzer::Configuration.new(database: 'mydb')
    assert configuration
  end

#  def test_can_connect_to_a_global_db
#    # Given
#    assert (con = @configuration.attach)
#
#    # When
#    con.create_table :foo do
#      String :foo
#    end
#    ds = con[:foo]
#    ds.insert(:foo => 'bar')
#
#    # Then
#    assert File.exists?('mydb')
#    File.unlink('mydb')
#  end

end
