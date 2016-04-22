require 'helper'

class Arisaid_BotsTest < Minitest::Test

  @@file = 'bots.yml'

  @@yml = <<-YML.lstrip
---
- name: foobar1
  real: Foo Bar1
YML

  def test_show
    stub_get "users.list?token=#{Arisaid.slack_token}"

    assert_output(@@yml) do
      Arisaid.bots.show
    end
  end

  def test_save
    stub_get "users.list?token=#{Arisaid.slack_token}"

    assert_silent do
      Arisaid.bots.save
    end

    assert_equal File.read(@@file), @@yml
    File.delete @@file
  end
end
