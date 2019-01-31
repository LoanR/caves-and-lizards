# frozen_string_literal: true

require 'spec_helper'
require_relative '../core/character' # to del

describe Character do
  let(:character) { FactoryBot.build(:character) }

  describe '#attack_throw' do
    context 'when executed' do
      subject { character.attack_throw }

      it { is_expected.to be <= 20 }
    end
  end

  describe '#damage_throw' do
    context 'with 1d3' do
      subject { character_1d3.damage_throw }

      let(:character_1d3) do
        FactoryBot.build(
          :character,
          equipment: FactoryBot.build(
            :equipment,
            main_hand: FactoryBot.build(
              :weapon,
              damage: '1d3'
            )
          )
        )
      end

      it { is_expected.to be <= 1 * 3 }
    end

    context 'with 3d10' do
      subject { character_3d10.damage_throw }

      let(:character_3d10) do
        FactoryBot.build(
          :character,
          equipment: FactoryBot.build(
            :equipment,
            main_hand: FactoryBot.build(
              :weapon,
              damage: '3d10'
            )
          )
        )
      end

      it { is_expected.to be <= 3 * 10 }
    end

    context 'with random damage dice' do
      it do
        weapon_damage = character.equipment.get_weapon_damage
        max_damage = weapon_damage[/^\d*/].to_i * weapon_damage[/\d*$/].to_i
        expect(character.damage_throw).to be <= max_damage
      end
    end
  end

  describe '#proficiency' do
    context 'with level 3 character' do
      subject { character_lvl3.proficiency }

      let(:character_lvl3) { FactoryBot.build(:character, level: 3) }

      it { is_expected.to be 2 }
    end

    context 'with level 18 character' do
      subject { character_lvl18.proficiency }

      let(:character_lvl18) { FactoryBot.build(:character, level: 18) }

      it { is_expected.to be 6 }
    end

    context 'with random level character' do
      subject { character.proficiency }

      it { is_expected.to eq((character.level - 1) / 4 + 2) }
    end
  end

  describe '#attack_modifier' do
    context 'with melee weapon and strength 13' do
      subject { character_melee_strength_13.attack_modifier }

      let(:character_melee_strength_13) do
        FactoryBot.build(
          :character,
          abilities: FactoryBot.build(
            :abilities,
            strength: 13
          ),
          equipment: FactoryBot.build(
            :equipment,
            main_hand: FactoryBot.build(
              :weapon,
              type: 'melee'
            )
          )
        )
      end

      it { is_expected.to be 1 }
    end

    context 'with ranged weapon and dexterity 29' do
      subject { character_melee_strength_13.attack_modifier }

      let(:character_melee_strength_13) do
        FactoryBot.build(
          :character,
          abilities: FactoryBot.build(
            :abilities,
            dexterity: 29
          ),
          equipment: FactoryBot.build(
            :equipment,
            main_hand: FactoryBot.build(
              :weapon,
              type: 'ranged'
            )
          )
        )
      end

      it { is_expected.to be 9 }
    end
  end

  describe '#armor_class' do
    context 'with leather and dexterity 25' do
      subject { character_leather_dext_25.armor_class }

      let(:character_leather_dext_25) do
        FactoryBot.build(
          :character,
          abilities: FactoryBot.build(
            :abilities,
            dexterity: 25
          ),
          equipment: FactoryBot.build(
            :equipment,
            armor: FactoryBot.build(
              :armor,
              base_armor_class: 11,
              max_dexterity_bonus: nil
            )
          )
        )
      end

      it { is_expected.to be 18 }
    end

    context 'with hide and dexterity 25' do
      subject { character_hide_dext_25.armor_class }

      let(:character_hide_dext_25) do
        FactoryBot.build(
          :character,
          abilities: FactoryBot.build(
            :abilities,
            dexterity: 25
          ),
          equipment: FactoryBot.build(
            :equipment,
            armor: FactoryBot.build(
              :armor,
              base_armor_class: 12,
              max_dexterity_bonus: 2
            )
          )
        )
      end

      it { is_expected.to be 14 }
    end

    context 'with half_plate and dexterity 7' do
      subject { character_half_plate_dext_7.armor_class }

      let(:character_half_plate_dext_7) do
        FactoryBot.build(
          :character,
          abilities: FactoryBot.build(
            :abilities,
            dexterity: 7
          ),
          equipment: FactoryBot.build(
            :equipment,
            armor: FactoryBot.build(
              :armor,
              base_armor_class: 15,
              max_dexterity_bonus: 2
            )
          )
        )
      end

      it { is_expected.to be 15 }
    end

    context 'with plate and dexterity 5' do
      subject { character_plate_dext_5.armor_class }

      let(:character_plate_dext_5) do
        FactoryBot.build(
          :character,
          abilities: FactoryBot.build(
            :abilities,
            dexterity: 5
          ),
          equipment: FactoryBot.build(
            :equipment,
            armor: FactoryBot.build(
              :armor,
              base_armor_class: 18,
              max_dexterity_bonus: 0
            )
          )
        )
      end

      it { is_expected.to be 18 }
    end

    context 'with plate and dexterity 29' do
      subject { character_plate_dext_29.armor_class }

      let(:character_plate_dext_29) do
        FactoryBot.build(
          :character,
          abilities: FactoryBot.build(
            :abilities,
            dexterity: 29
          ),
          equipment: FactoryBot.build(
            :equipment,
            armor: FactoryBot.build(
              :armor,
              base_armor_class: 18,
              max_dexterity_bonus: 0
            )
          )
        )
      end

      it { is_expected.to be 18 }
    end
  end

  describe '#suffers_damages!' do
    context 'when positive damages' do
      it do
        character.suffers_damages!(damages: 3)
        expect(character.hit_points).to eq(character.max_hit_points - 3)
      end
    end

    context 'when negative damages' do
      it do
        character.suffers_damages!(damages: -27)
        expect(character.hit_points).to eq(character.max_hit_points)
      end
    end
  end
end
