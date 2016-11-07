require 'sinatra/activerecord'
require_relative '../../config/environment'

class Message < ActiveRecord::Base
  include BCrypt

  enum destroy_type: %w(reviewing expiring)

  validates_presence_of :body, :password, :destroy_value
  validates :destroy_type, presence: true, inclusion: { in: Message.destroy_types.keys }
  validates_uniqueness_of :token

  before_create :encrypt_password!, :generate_token!

  after_create :set_destroy_time!

  def with_password?(password)
    Password.new(self.password) == password
  end

  def update_state!
    message = Message.new(self.attributes)
    if self.reviewing?
      self.destroy_value -= 1
      message.destroy_value = self.destroy_value
      self.destroy_value.zero? ? self.destroy : self.save
    end
    message
  end


  private


  def encrypt_password!
    self.password = Password.create(self.password) unless self.password.blank?
  end

  def generate_token!
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Message.exists?(token: random_token)
    end
  end

  def set_destroy_time!
    MessageDestroyWorker.perform_in(self.destroy_value.seconds, self.id) if self.expiring?
  end
end