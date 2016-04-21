require 'helper'

class Arisaid_UsersTest < Minitest::Test

  @@file = 'users.yml'

  @@yml = <<-YML.lstrip
---
- name: foobar2
  real: Foo Bar2
  email: foo@bar2.com
- name: foobar4
  real: Foo Bar4
  email: foo@bar4.com
YML

  @@yml_add_member = <<-YML.lstrip
---
- name: foobar2
  real: Foo
  email: foo@bar2.com
- name: foobar4
  real: Foo
  email: foo@bar4.com
- name: foobar5
  real: Foo
  email: foo@bar5.com
YML

  def test_apply
    stub_get "users.list?token=#{Arisaid.slack_token}"

    File.write @@file, @@yml_add_member

    assert_silent do
      Arisaid.users.apply
    end

    File.delete @@file
  end

  def test_show
    stub_get "users.list?token=#{Arisaid.slack_token}"

    assert_output(@@yml) do
      Arisaid.users.show
    end
  end

  def test_save
    stub_get "users.list?token=#{Arisaid.slack_token}"

    assert_silent do
      Arisaid.users.save
    end

    assert_equal File.read(@@file), @@yml
    File.delete @@file
  end
end
