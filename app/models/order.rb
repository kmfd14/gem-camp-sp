class Order < ApplicationRecord
  belongs_to :user
  belongs_to :offer

  enum genre: {deposit: 0 , increase: 1, deduct: 2, bonus: 3, share: 4}

  scope :by_serial_number, -> (serial_number) { where(orders: {serial_number: serial_number} ) }
  scope :by_email, -> (user_email) { joins(:user).where(users: {email: user_email}) }
  scope :by_genre, -> (genre_name) { where(orders: {genre: genre_name} ) }
  scope :by_state, -> (state_name) { where(orders: {state: state_name} ) }
  scope :by_offer, -> (offer_name) { where(orders: {name: offer_name} ) }
  scope :by_date_range, -> (date_range) { where(bets: {created_at: date_range} ) }

  after_create :order_serial_generator

  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid, success: [:increase_coins_when_not_deduct, :increase_total_deposit_when_deposit]
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, guard: :can_cancel?, success: [:decrease_coins_when_not_deduct, :decrease_total_deposit_when_deposit]
    end
  end

  private

  def order_serial_generator
    order_counter = Order.where(user: user).count
    number_count = format('%04d', order_counter)
    timestamp = Time.current.strftime('%y%m%d')
    serial_number = "#{timestamp}-#{id}-#{user.id}-#{number_count}"
    self.update(serial_number: serial_number)
  end

  def increase_coins_when_not_deduct
    self.user.update(coins: user.coins + offer.coin) unless deduct?
  end

  def decrease_coins_when_not_deduct
    self.user.update(coins: user.coins - offer.coin) unless !deduct?
  end

  def increase_total_deposit_when_deposit
    return unless deposit?
    self.user.update(total_deposit: user.total_deposit + offer.coin)
  end

  def decrease_total_deposit_when_deposit
    return unless deposit?
    self.user.update(total_deposit: user.total_deposit - offer.coin)
  end

  def deposit?
    genre == 'deposit'
  end

  def can_cancel?
    self.user.coins >= coin
  end
end
