namespace :pigeon do
    def get_password_from_input prompt
      print prompt
      passwd = STDIN.noecho {|io| STDIN.gets}.gsub("\n", "")
      puts
      passwd
    end

  task setup: :environment do
    puts "Setup pigeon..."
    puts "Create group: admin"
    admin_group = Group.find_or_create_by(name: "Admins", system_flags: 4294967295)
    
    print "username: "
    username = STDIN.gets.strip()
    passwd = get_password_from_input "password for user: "
    passwd2 = get_password_from_input "retype password for user: "
    raise "Password not match" if passwd != passwd2
    
    admin_account = User.create!(username: username, password: passwd, name: username, email: "", flags: 0, groups: [admin_group])
  end
  # namespace :setup do
  #   desc "Create user account for pigeon"
  #   task create: :environment do
  #     print "username: "
  #     username = STDIN.gets.strip()
  #
  #     passwd = get_password_from_input "password: "
  #     passwd2 = get_password_from_input "retype password: "
  #     raise "Password not match" if passwd != passwd2
  #
  #     u = User.create(username: username, password: passwd, name: username)
  #     puts "User %s is created with id %i" % [u.username, u.id]
  #   end
  #
  #   task passwd: :environment do
  #     user = get_user_from_input
  #
  #     passwd = get_password_from_input "password: "
  #     passwd2 = get_password_from_input "retype password: "
  #     raise "Password not match" if passwd != passwd2
  #
  #     user.password = passwd
  #     user.save
  #     puts "User updated"
  #   end
  #
  #   task roles: :environment do
  #     Permission.roles.each do |role, label|
  #       puts "#{role} => #{label}"
  #     end
  #   end
  #
  #   task addrole: :environment do
  #     user = get_user_from_input
  #
  #     print "role: "
  #     role = STDIN.gets.strip()
  #
  #     raise "Bad role" if role.empty?
  #     raise "Role already exist" if user.permissions.find_by_role(role)
  #
  #     Permission.create(user: user, role: role)
  #     puts "Role added"
  #   end
  #
  #   task rmrole: :environment do
  #     user = get_user_from_input
  #
  #     print "role: "
  #     role = STDIN.gets.strip()
  #
  #     user.permission.where(role: role).each do |r|
  #       r.destroy
  #     end
  #     puts "Role removed"
  #   end
  #
  #   def get_user_from_input
  #     print "username: "
  #     username = STDIN.gets.strip()
  #
  #     user = User.find_by_username(username)
  #     raise "User not found" if user.nil?
  #     user
  #   end
  #
  #   def get_password_from_input prompt
  #     print prompt
  #     passwd = STDIN.noecho {|io| STDIN.gets}.gsub("\n", "")
  #     puts
  #     passwd
  #   end
  # end
end
