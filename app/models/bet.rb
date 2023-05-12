class Bet < ApplicationRecord

  belongs_to :user

  after_create :bet_serial_generator
  after_create :deduct_coin

  scope :filter_by_serial_number, -> (serial_number) { where(bets: {serial_number: serial_number} ) }
  scope :filter_by_item_name, -> (item_name) { joins(:item).where(items: {name: item_name}) }
  scope :filter_by_email, -> (user_email) { joins(:user).where(users: {email: user_email}) }
  scope :filter_by_state, -> (state_name) { where(bets: {state: state_name} ) }
  scope :filter_by_date_range, -> (date_range) { where(bets: {created_at: date_range} ) }

  include AASM
  belongs_to :item

  aasm column: :state do
    state :betting, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :betting, to: :won
    end

    event :lose do
      transitions from: :betting, to: :lost
    end

    event :cancel do
      transitions from: :betting, to: :cancelled, success: :refund_user_coins
    end
  end

  private

  def bet_serial_generator
    bet_counter = Bet.where(item: item, batch_count: item.batch_count).count
    number_count = format('%04d', bet_counter)
    timestamp = Time.current.strftime('%y%m%d')
    serial_number = "#{timestamp}-#{item.id}-#{item.batch_count}-#{number_count}"
    self.update(serial_number: serial_number)
  end

  def deduct_coin
    self.user.decrement!(:coins)
  end

  def refund_user_coins
    self.user.increment!(:coins)
  end
end
