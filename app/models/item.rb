class Item < ApplicationRecord
  enum status: { active: 0, inactive: 1 }

  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :paused, :cancelled, :ended], to: :starting, guard: :may_start?
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  private

  def may_start?
    item.quantity > 0 && time.current < item.offline_at && status == 'active'
  end
end
