module Jumpstart
  class Mailer
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def settings
      return mailgun_settings if config.mailgun?
      return mailjet_settings if config.mailjet?
      return mandrill_settings if config.mandrill?
      return ohmysmtp_settings if config.ohmysmtp?
      return postmark_settings if config.postmark?
      return sendgrid_settings if config.sendgrid?
      return sendinblue_settings if config.sendinblue?
      return ses_settings if config.ses?
      return sparkpost_settings if config.sparkpost?
      {}
    end
    # rubocop: enable Metrics/AbcSize

    private

    def credentials
      Rails.application.credentials
    end

    # Search through credentials scoped, then unscoped
    def get_credential(*path)
      credentials.dig(Rails.env.to_sym, *path) || credentials.dig(*path)
    end

    def shared_settings
      {
        port: 587,
        authentication: :plain,
        enable_starttls_auto: true,
        domain: Jumpstart.config.domain
      }
    end

    # TODO: SEARCH RAILS ENV THEN NON RAILS ENV

    def mailgun_settings
      {
        address: "smtp.mailgun.org",
        user_name: get_credential(:mailgun, :username),
        password: get_credential(:mailgun, :password)
      }.merge(shared_settings)
    end

    def mailjet_settings
      {
        address: "in.mailjet.com",
        user_name: get_credential(:mailjet, :username),
        password: get_credential(:mailjet, :password)
      }.merge(shared_settings)
    end

    def mandrill_settings
      {
        address: "smtp.mandrillapp.com",
        user_name: get_credential(:mandrill, :username),
        password: get_credential(:mandrill, :password)
      }.merge(shared_settings)
    end

    def ohmysmtp_settings
      {
        address: "smtp.ohmysmtp.com",
        user_name: get_credential(:ohmysmtp, :username),
        password: get_credential(:ohmysmtp, :password)
      }.merge(shared_settings)
    end

    def postmark_settings
      {
        address: "smtp.postmarkapp.com",
        user_name: get_credential(:postmark, :username),
        password: get_credential(:postmark, :password)
      }.merge(shared_settings)
    end

    def sendinblue_settings
      shared_settings.merge({
        address: "smtp-relay.sendinblue.com",
        authentication: "login",
        user_name: get_credential(:sendinblue, :username),
        password: get_credential(:sendinblue, :password)
      })
    end

    def sendgrid_settings
      {
        address: "smtp.sendgrid.net",
        domain: get_credential(:sendgrid, :domain),
        user_name: get_credential(:sendgrid, :username),
        password: get_credential(:sendgrid, :password)
      }.merge(shared_settings)
    end

    def ses_settings
      {
        address: get_credential(:ses, :address),
        user_name: get_credential(:ses, :username),
        password: get_credential(:ses, :password)
      }.merge(shared_settings)
    end

    def sparkpost_settings
      {
        address: "smtp.sparkpostmail.com",
        user_name: "SMTP_Injection",
        password: get_credential(:sparkpost, :password)
      }.merge(shared_settings)
    end
  end
end
