# == Schema Information
#
# Table name: preferences
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  restriction :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
  #
  # Table name: preferences
  #
  #  id          :bigint           not null, primary key
  #  name        :string
  #  description :text
  #  restriction :boolean
  #  created_at  :datetime         not null
  #  updated_at  :datetime         not null
  #
  class Preference < ApplicationRecord
    MAX_PREFERENCES = 5

    validates :name, presence: true
    validates :description, presence: true
    validates :restriction, inclusion: { in: [true, false] }

    validate :limit_number_of_preferences

    private

    def limit_number_of_preferences
      if Preference && Preference.count >= MAX_PREFERENCES
        errors.add(:base, "Cannot create more than #{MAX_PREFERENCES} preferences")
      end
    end
  end
