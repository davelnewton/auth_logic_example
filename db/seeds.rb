if not User.find_by_email('ohai@wtf.com')
  User.create(:password => 'xyzzy',
              :email => 'ohai@wtf.com',
              :first_name => 'Branchion',
              :last_name => 'Hang')
end
