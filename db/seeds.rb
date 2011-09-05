if not User.find_by_login('plugh')
  User.create(:login => 'plugh',
              :password => 'xyzzy',
              :email => 'ohai@wtf.com',
              :first_name => 'Sample',
              :last_name => 'User')
end
