def create_user(params)
  User.create(params) unless User.find_by_email(params[:email])
end

create_user(:email => 'ohai@wtf.com',
            :password => 'xyzzy',
            :first_name => 'Branchion',
            :last_name => 'Hang')

create_user(:nickname => 'longduck',
            :email => 'dong@toast.fr',
            :password => 'fries',
            :first_name => 'Julius',
            :last_name => 'Levinson')
