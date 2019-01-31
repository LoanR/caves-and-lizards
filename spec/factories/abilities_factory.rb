# frozen_string_literal: true

require_relative './factory_helper'
require_relative '../../core/abilities'

FactoryBot.define do
  factory :abilities do
    strength { rand(8..14) }
    dexterity { rand(8..14) }
    constitution { rand(8..14) }
    intelligence { rand(8..14) }
    wisdom { rand(8..14) }
    charisma { rand(8..14) }

    initialize_with { new(attributes) }
  end
end
