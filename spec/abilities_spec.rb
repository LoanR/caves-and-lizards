# frozen_string_literal: true

require 'spec_helper'
require_relative '../core/abilities'

describe Abilities do
  describe '#modifier' do
    context 'with strength of 5' do
      subject { abilities_strlvl5.modifier(ability_str_id: 'strength') }

      let(:abilities_strlvl5) { FactoryBot.build(:abilities, strength: 5) }

      it { is_expected.to eq(-3) }
    end

    context 'with constitution of 17' do
      subject { abilities_conlvl27.modifier(ability_str_id: 'constitution') }

      let(:abilities_conlvl27) { FactoryBot.build(:abilities, constitution: 27) }

      it { is_expected.to be 8 }
    end

    context 'with random abilities' do
      subject { abilities.modifier(ability_str_id: 'wisdom') }

      let(:abilities) { FactoryBot.build(:abilities) }

      it { is_expected.to be abilities.wisdom / 2 - 5 }
    end
  end
end
