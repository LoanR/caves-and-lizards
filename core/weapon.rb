# frozen_string_literal: true

class Weapon
  attr_reader :name, :type, :cost, :damage, :weight, :properties

  def initialize(**opts)
    @name, @type, @cost, @damage, @weight,
    @properties = opts.values_at(
      :name, :type, :cost, :damage, :weight,
      :properties
    )
  end
end
