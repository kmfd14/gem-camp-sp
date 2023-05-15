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

  before_create :order_serial_generator

  include AASM
  belongs_to :item

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :payed

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid, success: :pay_user_coins
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, guard: :can_cancel?, success: :cancel_user_coins
    end
  end

  private

  def order_serial_generator
    order_counter = Order.where(user: user).count
    number_count = format('%04d', order_counter)
    timestamp = Time.current.strftime('%y%m%d')
    serial_number = "#{timestamp}-#{order.id}-#{user.id}-#{number_count}"
    self.update(serial_number: serial_number)
  end

  def pay_user_coins
    if genre == :deduct
      self.user.update(coins: user.coins - :coins)
    elsif genre == :deposit
      self.user.update(total_deposit: user.total_deposit + :coins)
    else
      self.user.update(coins: user.coins + :coins)
    end
  end

  def cancel_user_coins
    if genre == :deduct
      self.user.update(coins: user.coins + :coins)
    elsif genre == :deposit
      self.user.update(total_deposit: user.total_deposit - :coins)
    else
      self.user.update(coins: user.coins - :coins)
    end
  end

  def can_cancel?
    self.user.total_deposit >= coin
  end
end
