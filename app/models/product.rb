class Product < ApplicationRecord
    has_many :lineitems

    before_destroy :make_sure_no_line_items

    validates :name, :description, :image, :price, presence: true
    validates :name, uniqueness: true
    validates :image, allow_blank: true, format: {with: %r{\.(jpeg|jpg|png|gif)\z}i, message: "Image Format must be JPEG, JPG, PNG or GIF ! "}
    validates :price, numericality: {greater_than_or_equal_to: 0.01}

    def make_sure_no_line_items
        if lineitems.empty?
            return true
        else
            error.add(:base, "Lineitems Exists in Other's Cart ! ")
            return false
        end
    end

    def self.search(name)
        if name
            return Product.where('name ILIKE ?', "%#{name}%").order(:name)
        else
            return Product.order(:name)
        end
    end
end
