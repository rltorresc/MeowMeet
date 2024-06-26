class User < ApplicationRecord
    validates :user_name, presence: true, uniqueness: true
    validates :password_digest, presence: { message: 'Password can\'t be blank' }
    validates :session_token, presence: true, uniqueness: true
    validates :password, length: { minimum: 6, allow_nil: true }

    after_initialize :ensure_session_token

    has_many :cats,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :Cat

    has_many :rental_requests,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :CatRentalRequest

    has_many :sessions,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :Session

    has_many :notes

    attr_reader :password

    attr_reader :password
    
    #This method will find a user by their credentials
    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)
        return nil unless user
        user.is_password?(password) ? user : nil
    end

    #This method will generate a session token
    def self.generate_session_token
       SecureRandom.urlsafe_base64
    end

    #This method will reset the session token
    def reset_session_token!
        self.session_token = SecureRandom.urlsafe_base64
        self.save!
        self.session_token
    end

    #This method will set the password
    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    #This method will check the password
    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def admin?
        self.admin
    end

    private

    #This method will ensure the session token
    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end
end
