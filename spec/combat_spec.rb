# frozen_string_literal: true

require 'spec_helper'
require_relative '../rules/combat'

describe Combat do
  describe '#resolve_initiative!' do
    context 'with small, medium and big initiative' do
      let(:small_initiative_fighter) do
        FactoryBot.build(
          :character,
          abilities: FactoryBot.build(
            :abilities,
            dexterity: 10
          )
        )
      end
      let(:medium_initiative_fighter) do
        FactoryBot.build(
          :character,
          abilities: FactoryBot.build(
            :abilities,
            dexterity: 50
          )
        )
      end
      let(:big_initiative_fighter) do
        FactoryBot.build(
          :character,
          abilities: FactoryBot.build(
            :abilities,
            dexterity: 90
          )
        )
      end
      let(:combat) do
        FactoryBot.build(
          :combat,
          involved_fighters: [
            big_initiative_fighter,
            small_initiative_fighter,
            medium_initiative_fighter
          ]
        )
      end

      it 'does not keep original order' do
        before_sorting = combat.involved_fighters.dup
        combat.resolve_initiative!
        expect(combat.involved_fighters).not_to eq(before_sorting)
      end

      it 'is in a specific order' do
        combat.resolve_initiative!
        expect(combat.involved_fighters).to eq([big_initiative_fighter, medium_initiative_fighter, small_initiative_fighter])
      end
    end
  end
end
