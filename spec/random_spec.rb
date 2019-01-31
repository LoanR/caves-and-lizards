# frozen_string_literal: true

require 'spec_helper'
require_relative '../core/random'

describe 'Dice' do
  context 'roll' do
    it 'returns a positive integer' do
      5.times do
        dice_faces = rand(1..9)
        expect(dice(faces: dice_faces)).to be > 0
      end
    end
    it 'returns a integer within dice faces' do
      5.times do
        dice_faces = rand(1..9)
        expect(dice(faces: dice_faces)).to be <= dice_faces
      end
    end
  end
end
