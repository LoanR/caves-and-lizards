# frozen_string_literal: true

# require_relative './abilities_fact'
require_relative './factory_helper'
require_relative '../../core/character'

FactoryBot.define do
  factory :character do
    name do
      [Faker::Witcher.character, Faker::WorldOfWarcraft.hero, Faker::Zelda.character,
       Faker::LordOfTheRings.character, Faker::ElderScrolls.name, Faker::Ancient.hero].sample
    end
    race { Faker::ElderScrolls.race }
    level { rand(1..5) }
    order { Faker::Superhero.prefix }
    background { Faker::TwinPeaks.quote }
    abilities { FactoryBot.build(:abilities) }
    living_player { false }
    team { rand(1..6) }
    max_hit_points { rand(18..45) }
    equipment { FactoryBot.build(:equipment) }
    inventory { 'truc' }

    initialize_with { new(attributes) }
  end
end
