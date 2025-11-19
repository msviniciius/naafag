class Persona < ApplicationRecord
  belongs_to :gender
  belongs_to :level_education

  has_one :persona_address, dependent: :destroy
  has_one :persona_responsability, dependent: :destroy
  has_many :info_doctors, dependent: :destroy
end
