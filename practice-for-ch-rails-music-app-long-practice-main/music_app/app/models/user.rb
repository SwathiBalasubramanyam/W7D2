class User < ApplicationRecord
    #This is the basic model level validation
    validates :email, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true

    # Now when you have this, 
    # when trying to save a model without a pwd field, it will try to access
    # the attr_reader for password column which in our case wont exist as 
    # ActiveRecord by default creates attr_accessors all the columns based out of schema.rb

    validates :password, length: {minimum: 6},  allow_nil: true

    #  In order to fix that we need to create a attr_reader and attr_writer for password
    #  as validations will call it
    # when creating them, dont save it to self (instance) as everything on self will try
    #  to be saved in the DB and it will throw an error

    attr_reader :password # this method is run on validation ie you wanna save something

    def password=(password) 
        # this method is run on invoking an instance of model 
        # if there is a password passed in
        # if you do self.password that means you`re trying to call the same method
        # so will result in stack level too deep
        # @password = password --> this does not throw an error yet lets see where we use it
        
        # https://stackoverflow.com/questions/10805136/when-to-use-self-in-model
        self.password_digest = BCrypt::Password.create(password)
        self.session_token = SecureRandom::urlsafe_base64
    end
    
end
