class Order < ApplicationRecord
  before_create :generate_token
  def generate_token
  self.token = SecureRandom.uuid
  end
  belongs_to :user
  has_many :product_lists
  validates :billing_name, presence: true
  validates :billing_address, presence: true
  # validates :shipping_name, presence: true
  # validates :shipping_address, presence: true
  def set_payment_with!(method)
  self.update_columns(payment_method: method )
  end

  def pay!
  self.update_columns(is_paid: true )
  end
  include AASM

  # aasm do
  #   state :order_placed, initial: true
  #   state :paid
  #   state :shipping
  #   state :shipped
  #   state :order_cancelled
  #   state :good_returned
  #
  #
  #      event :make_payment, after_commit: :pay! do
  #     transitions from: :order_placed, to: :paid
  #   end
  #
  #   event :ship do
  #     transitions from: :paid,         to: :shipping
  #   end
  #
  #   event :deliver do
  #     transitions from: :shipping,     to: :shipped
  #   end
  #
  #   event :return_good do
  #     transitions from: :shipped,      to: :good_returned
  #   end
  #
  #   event :cancel_order do
  #     transitions from: [:order_placed, :paid], to: :order_cancelled
  #   end
  # end

  aasm do
    state :已下单, initial: true
    state :已付款
    state :出货中
    state :已出货
    state :订单已取消
    state :退货


       event :make_payment, after_commit: :pay! do
      transitions from: :已下单, to: :已付款
    end

    event :ship do
      transitions from: :已付款,         to: :出货中
    end

    event :deliver do
      transitions from: :出货中,     to: :已出货
    end

    event :return_good do
      transitions from: :已出货,      to: :退货
    end

    event :cancel_order do
      transitions from: [:已下单, :已付款], to: :订单已取消
    end
  end
end
