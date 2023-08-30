class User < ApplicationRecord
    #This is the basic model level validation
    validates :email, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true

    # Now when you have this, 
    # when trying to save a model without a pwd field, it will try to access
    # the attr_reader for password column which in our case wont exist as 
    # ActiveRecord by default creates attr_accessors for 
    # all the columns based out of schema.rb

    validates :password, length: {minimum: 6, allow_nil: true}

    #  In order to fix that we need to create a attr_reader and attr_writer for password
    #  as validations will call it
    # when creating them, dont save it to self (instance) as everything on self will try
    #  to be saved in the DB and it will throw an error

    attr_reader :password # this method is run on validation ie you wanna save something

    def password=(password) 
        # 1. this method is run on invoking an instance of model 
        # if there is a password passed in
        # 2. if you do self.password that means you`re trying to call the same method
        # so will result in stack level too deep
        #3. When you send a password and dont have allow nil, it will try to validate
        # the password, but if @password is not set then it will scream at you saying password
        #should be of certain length where as you passed it in. 
        # Remember, validation will be skipped completely if you have allow_nil in this case
        @password = password 
        
        # https://stackoverflow.com/questions/10805136/when-to-use-self-in-model
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        password_obj = BCrypt::Password.new(self.password_digest)
        password_obj.is_password?(password)
    end

    def generate_unique_session_token
        while true
            session_token = SecureRandom::urlsafe_base64
            return session_token unless User.exists?(session_token: session_token)
        end
    end

    def reset_session_token!
        self.session_token = self.generate_unique_session_token
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end

    def self.find_by_credentials(email, password)
        user_obj = User.find_by(email: email)
        if user_obj && user_obj.is_password?(password)
            user_obj
        end
        return nil
    end
    
end
