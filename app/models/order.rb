class Order < ApplicationRecord
    has_many :lineitems, dependent: :destroy

    PAYMENT_TYPES = ["Credit Card", "PayPal", "Venmo", "AliPay", "WeChat Pay"]

    validates :name, :address, :email, :phonenumber, presence: true
    validates :paytype, inclusion: PAYMENT_TYPES

    def add_items_from_cart(cart)
        cart.lineitems.each do |item|
            item.cart_id = nil
            item.order_id = self.id
            
            item.save
        end
    end
end
