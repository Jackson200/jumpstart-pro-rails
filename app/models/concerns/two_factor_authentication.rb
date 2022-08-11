# Adds time-based One Time Passwords (TOTPs) for user authentication
#
# * otp_required_for_login:boolean
# * otp_secret:string
# * last_otp_timestep:integer
# * otp_backup_codes:text

module TwoFactorAuthentication
  extend ActiveSupport::Concern

  included do
    # Per discussion, serialize with text column
    # when rails 7 comes out encryption should be trivial
    serialize :otp_backup_codes, Array
  end

  def set_otp_secret!
    return if otp_secret?
    update(otp_secret: ROTP::Base32.random)
  end

  def enable_two_factor!
    update(otp_required_for_login: true)
  end

  def disable_two_factor!
    update!(otp_required_for_login: false, otp_secret: nil, otp_backup_codes: [])
  end

  def otp
    ROTP::TOTP.new(otp_secret, issuer: Jumpstart.config.application_name)
  end

  def otp_provisioning_uri
    otp.provisioning_uri(email)
  end

  def current_otp
    otp.now
  end

  def verify_and_consume_otp!(code)
    return false if code.blank?
    return consume_otp! if verify_otp(code)
    return consume_backup_code!(code) if verify_backup_code(code)
    false
  end

  def generate_otp_backup_codes!
    codes = []
    number_of_codes = 16
    code_length = 10

    number_of_codes.times do
      codes << SecureRandom.hex(code_length / 2) # Hexstring has length 2*n
    end

    update!(otp_backup_codes: codes)

    codes
  end

  def two_factor_otp_qr_code
    qrcode = RQRCode::QRCode.new(otp.provisioning_uri(email))
    qrcode.as_svg(module_size: 4)
  end

  private

  # Verify with 15 second drift
  def verify_otp(code)
    otp.verify(code, after: last_otp_timestep, drift_behind: 15)
  end

  def verify_backup_code(code)
    otp_backup_codes.include?(code)
  end

  # No valid OTP may be used more than once for a given timestep
  def consume_otp!
    if last_otp_timestep != current_otp_timestep
      update_attribute(:last_otp_timestep, current_otp_timestep)
    else
      false
    end
  end

  def consume_backup_code!(code)
    !!otp_backup_codes.delete(code) && save!
  end

  def current_otp_timestep
    Time.now.utc.to_i / otp.interval
  end
end
