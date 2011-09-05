if not User.find_by_login('plugh')
  User.create(:login => 'plugh', :password => 'xyzzy', :email => 'ohai@wtf.com')
end
