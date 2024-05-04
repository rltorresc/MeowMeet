class CatRentalRequest < ApplicationRecord
    STATUS_STATES = %w(PENDING APPROVED DENIED).freeze
    validates :status, inclusion: { in: STATUS_STATES, message: "%{value} is not a valid status" }, presence: true
    validates :end_date, :start_date, presence: true
    validate :does_not_overlap_approved_request
    validate :end_date_after_start_date

    belongs_to :requester,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id,
    inverse_of: :rental_requests

    belongs_to :cat

    def overlapping_requests
        CatRentalRequest
            .where.not(id: self.id)
            .where(cat_id: cat_id)
            .where.not('start_date > :end_date OR end_date < :start_date', start_date: start_date, end_date: end_date)
    end

    def overlapping_approved_requests
        overlapping_requests.where(status: 'APPROVED')
    end

    def does_not_overlap_approved_request
        return if overlapping_approved_requests.empty?
        errors[:base] << 'Request conflicts with existing approved request'
    end

    def overlapping_pending_requests
        overlapping_requests.where(status: 'PENDING')
    end

    def approve!
        transaction do
            self.status = 'APPROVED'
            self.save!
            overlapping_pending_requests.each do |request|
                request.deny!
            end
        end
    end
    def deny!
        self.status = 'DENIED'
        self.save!
    end
    def pending?
        self.status == 'PENDING'
    end

    private

    def end_date_after_start_date
        return if start_date.blank? || end_date.blank?

        if end_date < start_date
        errors.add(:end_date, "must be after the start date")
        end
    end
end