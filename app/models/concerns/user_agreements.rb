module UserAgreements
  extend ActiveSupport::Concern

  included do
    # Accept the terms of service on registration
    attribute :terms_of_service
    validates :terms_of_service, presence: true, acceptance: true, on: [:create, :invitation_accepted]

    after_validation :accept_terms, on: [:create, :invitation_accepted]
    after_validation :accept_privacy, on: [:create, :invitation_accepted]
  end

  def accept_terms
    self.accepted_terms_at = Time.zone.now
  end

  def accept_privacy
    self.accepted_privacy_at = Time.zone.now
  end
end
