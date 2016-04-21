require 'helper'

class Arisaid_UsergroupsTest < Minitest::Test
  def test_apply
    stub_get "users.list?token=#{Arisaid.slack_token}"
    stub_get "usergroups.list?include_disabled=1&include_users=1&token=#{Arisaid.slack_token}"
    stub_get "usergroups.create?description=Yo%20Members&handle=yo&name=yo&token=#{Arisaid.slack_token}"

    File.write 'usergroups.yml', <<-YML.lstrip
---
- name: tokyo
  description: Tokyo Members
  handle: tokyo
  users:
  - foobar2
  - foobar4
- name: yo
  description: Yo Members
  handle: yo
  users:
  - foobar2
YML

    assert_silent do
      Arisaid.usergroups.apply
    end
    File.delete 'usergroups.yml'
  end

  def test_show
    stub_get "users.list?token=#{Arisaid.slack_token}"
    stub_get "usergroups.list?include_disabled=1&include_users=1&token=#{Arisaid.slack_token}"

    output = <<-YML.lstrip
---
- name: tokyo
  description: Tokyo Members
  handle: tokyo
  users:
  - foobar2
  - foobar4
YML

    assert_output(output) do
      Arisaid.usergroups.show
    end
  end

  def test_save
    stub_get "users.list?token=#{Arisaid.slack_token}"
    stub_get "usergroups.list?include_disabled=1&include_users=1&token=#{Arisaid.slack_token}"

    conf = <<-YML.lstrip
---
- name: tokyo
  description: Tokyo Members
  handle: tokyo
  users:
  - foobar2
  - foobar4
YML

    assert_silent do
      Arisaid.usergroups.save
    end

    assert_equal File.read('usergroups.yml'), conf
    File.delete 'usergroups.yml'
  end
end
