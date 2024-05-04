class Cat < ApplicationRecord
    include ActionView::Helpers::DateHelper
    CAT_COLOR = %w[black white orange grey].freeze


    validates :color, inclusion: { in: CAT_COLOR, message: "%{value} is not a valid color" }, presence: true
    validates :sex, inclusion: { in: %w(M F), message: "%{value} is not a valid sex"}, presence: true
    validates :birth_date, presence: true
    validates :name, presence: true
    validates :description, presence: true
    validate :birth_date_cannot_be_future

    has_many :rental_requests,
        primary_key: :id,
        foreign_key: :cat_id,
        class_name: :CatRentalRequest,
        dependent: :destroy

    belongs_to :owner,
        class_name: "User",
        foreign_key: :user_id,
        primary_key: :id,
        required: true
    
    has_many :notes, dependent: :destroy

    def birth_date_cannot_be_future
        return unless birth_date.present? && birth_date > Date.today
        errors.add(:birth_date, "can't be in the future")
    end

    def age
        time_ago_in_words(birth_date)
    end
end
