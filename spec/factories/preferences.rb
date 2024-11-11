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
FactoryBot.define do
  factory :preference do
    name { "MyString" }
    description { "MyText" }
    restriction { false }
  end
end
