# frozen_string_literal: true

require_relative './factory_helper'
require_relative '../../core/abilities'

FactoryBot.define do
  factory :abilities do
    strength { rand(1..30) }
    dexterity { rand(1..30) }
    constitution { rand(1..30) }
    intelligence { rand(1..30) }
    wisdom { rand(1..30) }
    charisma { rand(1..30) }

    initialize_with { new(attributes) }
  end
end
