class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :orders
   validates :first_name, presence: true
   validates :last_name, presence: true

  def full_name
  	<<-EOT.gsub(/^\s+/, '')
			#{first_name rescue nil}
			#{last_name rescue nil}
    EOT
  end
end
