require 'helper'

class Arisaid_SyncableTest < Minitest::Test
  def test_local
    @dummy = Object.new
    @dummy.extend(Arisaid::Syncable)

    File.write 'object.yml', <<-YML.lstrip
---
- name: tokyo
  description: Tokyo Members
  handle: tokyo
  users: &tokyo
  - foobar1
  - foobar2
- name: yo
  description: Yo Members
  handle: yo
  users:
  - *tokyo
  - foobar3
YML
    assert_equal @dummy.local[1]["users"], %w(foobar1 foobar2 foobar3)
    File.delete 'object.yml'
  end
end
