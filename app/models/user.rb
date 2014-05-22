class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :username

  serialize :address, Address

  def self.new_with_session(params, session)
    if session['devise.user_attributes']
      new(session['devise.user_attributes'],
          without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end    
  end
end
