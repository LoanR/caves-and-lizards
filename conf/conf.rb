# frozen_string_literal: true

strength_ability = 'strength'
dexterity_ability = 'dexterity'

melee_weapon_type = 'melee'
ranged_weapon_type = 'ranged'

ABILITY_MODIFIER_CORRESPONDANCES = Hash[
  melee_weapon_type => strength_ability,
  ranged_weapon_type => dexterity_ability
]
