class Item < ApplicationRecord
  enum status: { active: 0, inactive: 1 }


  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

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
    quantity > 0 && Time.current < offline_at && status == 'active'
  end
end
