require 'test_helper'

class UserAuthTest < ActionDispatch::IntegrationTest
  test "access_test" do
    enable_users 'admin'

    get '/'
    assert_redirected_to login_path

    post login_path, :username => 'admin', :password => 'unittest_account', :to => '/'
    assert_redirected_to '/'
  end

  def enable_users *usernames
    usernames.each do |username|
      u = User.find_by_login username
      u.disabled = false
      u.save
    end
  end
end
