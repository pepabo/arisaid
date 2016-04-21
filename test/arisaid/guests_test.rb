require 'helper'

class Arisaid_GuestsTest < Minitest::Test

  @@file = 'guests.yml'

  @@yml = <<-YML.lstrip
---
- name: foobar5
  real: Foo Bar5
  email: foo@bar5.com
YML

  def test_show
    stub_get "users.list?token=#{Arisaid.slack_token}"

    assert_output(@@yml) do
      Arisaid.guests.show
    end
  end

  def test_save
    stub_get "users.list?token=#{Arisaid.slack_token}"

    assert_silent do
      Arisaid.guests.save
    end

    assert_equal File.read(@@file), @@yml
    File.delete @@file
  end
end
