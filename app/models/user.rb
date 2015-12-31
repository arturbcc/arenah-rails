require Rails.root.join('lib', 'devise', 'encryptors', 'md5')

class User < ActiveRecord::Base
  extend FriendlyId

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  friendly_id :name, use: :slugged

  has_many :characters, dependent: :delete_all
  has_many :subscriptions, dependent: :delete_all

  #TODO: Check the correct limit
  validates :name, length: { maximum: 25 }
  validates :name, :slug, presence: true

  def valid_password?(password)
    return false if encrypted_password.blank?

    if legacy_password.present?
      md5 = Devise::Encryptable::Encryptors::Md5.digest(password, nil, nil, nil)

      if Devise.secure_compare(md5.chomp, legacy_password.chomp)
        new_password = User.new(:password => password).encrypted_password
        self.update(legacy_password: nil, encrypted_password: new_password)
      else
        false
      end
    else
      super(password)
    end
  end

  def self.permitted_parameters
    [:name]
  end
end
