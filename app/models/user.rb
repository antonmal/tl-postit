class User < ActiveRecord::Base
  include SluggableAnt

  has_many :posts
  has_many :comments

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 },
    if: :validate_password?

  has_slug :username

  def validate_password?
    new_record? || password.present?
  end

  def two_factor_login?
    !self.phone.blank?
  end

  def generate_pin!
    self.update(pin: rand(10**6))
  end

  def send_pin_via_twilio
    # put your own credentials here
    account_sid = 'ACc016878de859ec5a60b51a32c7aed8a7'
    auth_token = '45cf5ace7fed98077cefa47350d0704d'

    # set up a client to talk to the Twilio REST API
    client = Twilio::REST::Client.new account_sid, auth_token

    client.account.messages.create({
    	:from => '+34986080544',
    	:to => "#{self.phone}",
    	:body => "#{self.pin}",
    })
  end
end
