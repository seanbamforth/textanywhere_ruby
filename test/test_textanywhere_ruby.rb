require 'test/unit'
require 'TextAnywhere_ruby'

class TextAnywhere_rubyTest < Test::Unit::TestCase
  def test_english_hello
    assert_equal "hello there", TextAnywhere_ruby.hi()
  end
end
