module Jumpstart
  class Configuration
    module Mailable
      AVAILABLE_PROVIDERS = {
        "Amazon SES" => :ses,
        "Mailgun" => :mailgun,
        "Mailjet" => :mailjet,
        "Mandrill" => :mandrill,
        "OhMySMTP" => :ohmysmtp,
        "Postmark" => :postmark,
        "Sendgrid" => :sendgrid,
        "SendinBlue" => :sendinblue,
        "SparkPost" => :sparkpost
      }.freeze

      AVAILABLE_PROVIDERS.values.map(&:to_s).each do |name|
        define_method :"#{name}?" do
          email_provider == name
        end
      end
    end
  end
end
