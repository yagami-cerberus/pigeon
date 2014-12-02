require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Exist Password Hash" do
    u = User.find_by_login('sha256_test_user')
    assert u.challenge_password("pigeon"),
      "Unittest account password challenge failed"

    assert_not u.challenge_password("pigeon2"),
        "Unittest account password challenge failed"
    
    assert_nil u.password
  end
  
  test "Password Hash" do
    u = User.find_by_login('regular_user')
    assert u.challenge_password("moo~"),
      "Unittest account password challenge failed"

    assert_not u.challenge_password("moo~2"),
        "Unittest account password challenge failed"
  end
end
