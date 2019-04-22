require 'test_helper'

class TagUnitTest < Minitest::Test
  include Liquid

  def test_tag
    tag = Tag.parse('tag', "", Tokenizer.new(""), ParseContext.new)
    assert_equal 'liquid::tag', tag.name
    assert_equal '', tag.render(Context.new)
  end

  def test_return_raw_text_of_tag
    tag = Tag.parse("long_tag", "param1, param2, param3", Tokenizer.new(""), ParseContext.new)
    assert_equal("long_tag param1, param2, param3", tag.raw)
  end

  def test_tag_name_should_return_name_of_the_tag
    tag = Tag.parse("some_tag", "", Tokenizer.new(""), ParseContext.new)
    assert_equal 'some_tag', tag.tag_name
  end

  def test_custom_tags_have_a_default_render_to_output_buffer_method_for_backwards_compatibility
    klass = Class.new(Tag) do
      def initialize; end

      def render(*)
        'hello'
      end
    end

    tag = klass.send(:new)

    assert_equal 'hello', tag.render

    buf = ''
    return_value = tag.render_to_output_buffer(nil, buf)
    assert_equal 'hello', buf
    assert_equal 'hello', return_value
    assert_equal buf.object_id, return_value.object_id
  end
end
