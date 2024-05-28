require 'helper'

class Arisaid_UsergroupsTest < Minitest::Test
  def test_apply
    stub_get "users.list", Arisaid.slack_token
    stub_get "usergroups.list", Arisaid.slack_token
    stub_get "usergroups.create", Arisaid.slack_token
    stub_get "usergroups.users.update", Arisaid.slack_token

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

    output = <<-YML.lstrip
==== Fetch all setting and enable groups ====
  - tokyo
  - yo
==== Update usergroups ====
  - tokyo
  - yo
==== Disable usergroups ====
  - tokyo
YML

    assert_output(output) do
      Arisaid.usergroups.apply
    end
    File.delete 'usergroups.yml'
  end

  def test_show
    stub_get "users.list", Arisaid.slack_token
    stub_get "usergroups.list", Arisaid.slack_token

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
    stub_get "users.list", Arisaid.slack_token
    stub_get "usergroups.list" ,Arisaid.slack_token

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
