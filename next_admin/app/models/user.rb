class User < ActiveRecord::Base
  include EmailAddressChecker
  has_many :company_users
  has_many :companies, :through => :company_users
  has_many :agency_users
  has_many :agencies, :through => :agency_users
  attr_accessible :country_cd, :created_by, :deleted_at, :deleted_by, :email, :name, :name_kana, :pw_lock_at, :pw_lock_flg, :pw_lock_release_at, :status, :updated_by

  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validate :check_email

  def agency_user?
    self.agencies.present?
  end

  def test?
    #
  end

  def company_user?(company)
    CompanyUser.find_by_company_id_and_user_id(company.id, self.id)
  end

  private
  def check_email
    if email.present?
      errors.add(:email, :invalid) unless
        well_formed_as_email_address(email)
    end
  end
end
