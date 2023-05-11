class Bet < ApplicationRecord
  belongs_to :item
  belongs_to :user

  after_create :bet_serial_generator
  after_create :deduct_coin
  include AASM

  aasm column: :state do
    state :betting, initial: true
    state :won, :lost, :cancelled

    event :won do
      transitions from: :betting, to: :won, guard: :may_start?
    end

    event :lost do
      transitions from: :betting, to: :lost
    end

    event :cancelled do
      transitions from: :betting, to: :cancelled
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
end
