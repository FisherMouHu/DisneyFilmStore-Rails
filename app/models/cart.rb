class Cart < ApplicationRecord
    has_many :lineitems, dependent: :destroy

    def add_item(product_id)
        current_item = lineitems.find_by(product_id: product_id)

        # If Item Exist or not
        if current_item
            current_item.quantity += 1
        else
            current_item = self.lineitems.build(product_id: product_id)
        end

        return current_item
    end

    def total_price
        return lineitems.to_a.sum { |item| item.item_total_price }
    end
end
