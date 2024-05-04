class Note < ApplicationRecord
    belongs_to :cat
    belongs_to :user
end
