# frozen_string_literal: true

require_relative './factory_helper'
require_relative '../../core/equipment'

FactoryBot.define do
  factory :equipment do
    armor { FactoryBot.build(:armor) }
    left_hand_ring { nil }
    right_hand_ring { nil }
    amulet { nil }
    helmet { nil }
    cloak { nil }
    gloves { nil }
    bracers { nil }
    belt { nil }
    boots { nil }
    main_hand { FactoryBot.build(:weapon) }
    off_hand { nil }

    initialize_with { new(attributes) }
  end
end
