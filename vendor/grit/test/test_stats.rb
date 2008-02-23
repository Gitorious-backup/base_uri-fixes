require File.dirname(__FILE__) + '/helper'

class TestStats < Test::Unit::TestCase
  def setup
    @r = Repo.new(GRIT_REPO)
  end
  
  def test_list_from_string
    output = fixture('diff_numstat')
    stats = Stats.list_from_string(@r, output)
    
    assert_equal 2,stats.total[:files]
    assert_equal 52,stats.total[:lines]
    assert_equal 29,stats.total[:insertions]
    assert_equal 23,stats.total[:deletions]
    
    assert_equal 29, stats.files["a.txt"][:insertions]
    assert_equal 18, stats.files["a.txt"][:deletions]
    
    assert_equal 0, stats.files["b.txt"][:insertions]
    assert_equal 5, stats.files["b.txt"][:deletions]
  end
  
end