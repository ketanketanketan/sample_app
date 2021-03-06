require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_many :microposts, :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,      :presence     =>true, 
                        :length       => { :maximum => 50 }
  validates :email,     :presence     =>true,
                        :format       => { :with => email_regex },
                        :uniqueness   => { :case_sensitive => false }

  # Automatically create the virtual attribute 'password_confirmation'
  validates :password,  :presence     => true,
                        :confirmation => true,
                        :length       => { :within => 6..40 }
                        
  before_save :encrypt_password
  
    def has_password?(submitted_password)
      encrypted_password == encrypt(submitted_password)
    end
  
    def self.authenticate(email, submitted_password)
      user = find_by_email(email)
      return nil if user.nil?
      return user if user.has_password?(submitted_password)
    end
    
    def self.authenticate_with_salt(id, cookie_salt)
      # Closely parallels the authenticate method
      # 
      # return nil if user.nil?
      # return user if user.salt == cookie_salt
      
      # More idiomatically correct Ruby using the ternary operation to 
      # compress an if-else construction into one line.
      user = find_by_id(id)
      (user && user.salt) == cookie_salt ? user : nil
      # called a "ternary operator" beause it consists of three parts
      # boolean? ? do_one_thing : do_something_else
    end
    
    def feed
      # This is preliminary. See Chapter 12 for the full implementation
      Micropost.where("user_id = ?", id)
    end
  
  private 
    
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--{string}")
    end
    
    def make_salt
      secure_hash("{Time.now.utc}--{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
