# frozen_string_literal: true

require_relative './factory_helper'
require_relative '../../core/armor'

FactoryBot.define do
  factory :armor do
    name { [Faker::SwordArtOnline.item, Faker::Zelda.item].sample }
    base_armor_class { rand(11..14) }
    max_dexterity_bonus { [nil, 0, 2].sample }
    armor_check_penalty { nil }
    spell_failure { '0%' }
    feats_requirements { nil }

    initialize_with { new(attributes) }
  end
end
