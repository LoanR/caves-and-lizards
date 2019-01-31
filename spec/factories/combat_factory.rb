# frozen_string_literal: true

require_relative './factory_helper'
require_relative '../../rules/combat'

FactoryBot.define do
  factory :combat do
    involved_fighters { FactoryBot.build_list(:character, 5) }

    initialize_with { new(attributes) }
  end
end
