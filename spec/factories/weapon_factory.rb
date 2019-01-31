# frozen_string_literal: true

require_relative './factory_helper'
require_relative '../../core/weapon'

FactoryBot.define do
  factory :weapon do
    name { [Faker::SwordArtOnline.item, Faker::Zelda.item].sample }
    cost { rand(6) }
    type { %w[melee ranged].sample }
    damage { rand(1..3).to_s + 'd' + rand(3..12).to_s }
    weight { rand(5) }
    properties { nil }

    initialize_with { new(attributes) }
  end
end
