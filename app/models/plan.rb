# == Schema Information
#
# Table name: plans
#
#  id                :bigint           not null, primary key
#  amount            :integer          default(0), not null
#  currency          :string
#  description       :string
#  details           :jsonb            not null
#  hidden            :boolean
#  interval          :string           not null
#  interval_count    :integer          default(1)
#  name              :string           not null
#  trial_period_days :integer          default(0)
#  unit              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Plan < ApplicationRecord
  # Generates hash IDs with a friendly prefix so users can't guess hidden plan IDs on checkout
  # https://github.com/excid3/prefixed_ids
  has_prefix_id :plan

  store_accessor :details, :features, :stripe_id, :braintree_id, :paddle_id, :jumpstart_id, :fake_processor_id, :stripe_tax
  attribute :features, :string, array: true

  validates :name, :amount, :interval, presence: true
  validates :currency, presence: true, format: {with: /\A[a-zA-Z]{3}\z/, message: "must be a 3-letter ISO currency code"}
  validates :interval, inclusion: %w[month year]
  validates :trial_period_days, numericality: {only_integer: true}

  scope :hidden, -> { unscope(where: :hidden).where(hidden: true) }
  scope :monthly, -> { without_free.where(interval: :month) }
  scope :sorted, -> { order(amount: :asc) }
  scope :visible, -> { where(hidden: [nil, false]) }
  scope :with_hidden, -> { unscope(where: :hidden) }
  scope :without_free, -> { where.not("details @> ?", {fake_processor_id: :free}.to_json) }
  scope :yearly, -> { without_free.where(interval: :year) }

  # Downcase
  before_save { currency.downcase! }

  # Default currency
  after_initialize { self.currency ||= "usd" }

  def self.free
    plan = where(name: "Free").first_or_initialize
    plan.update(hidden: true, amount: 0, currency: :usd, interval: :month, trial_period_days: 0, fake_processor_id: :free)
    plan
  end

  def automatic_tax?
    !!stripe_tax
  end

  def features
    Array.wrap(super)
  end

  def amount_with_currency(**options)
    Pay::Currency.format(amount, **{currency: currency}.merge(options))
  end

  def dollar_amount
    amount / 100
  end

  def has_trial?
    trial_period_days.to_i > 0
  end

  def monthly?
    interval == "month"
  end

  def annual?
    interval == "year"
  end
  alias_method :yearly?, :annual?

  def taxed?
    !!stripe_tax
  end

  # Find a plan with the same name in the opposite interval
  # This is useful when letting users upgrade to the yearly plan
  def find_interval_plan
    monthly? ? annual_version : monthly_version
  end

  def annual_version
    return self if annual?
    self.class.yearly.where(name: name).first
  end
  alias_method :yearly_version, :annual_version

  def monthly_version
    return self if monthly?
    self.class.monthly.where(name: name).first
  end

  def id_for_processor(processor_name, currency: "usd")
    return if processor_name.nil?
    processor_name = :braintree if processor_name.to_s == "paypal"
    send("#{processor_name}_id")
  end
end
