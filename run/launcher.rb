# frozen_string_literal: true

require_relative '../core/armor'
require_relative '../core/weapon'
require_relative '../core/equipment'
require_relative '../core/abilities'
require_relative '../core/character'
require_relative '../rules/combat'

padded_armor_h = {
  name: 'Padded',
  base_armor_class: 11,
  max_dexterity_bonus: nil,
  armor_check_penalty: 0,
  spell_failure: 0,
  feats_requirements: nil
}
padded_armor = Armor.new(**padded_armor_h)

short_sword_h = {
  name: 'Shortsword',
  type: 'melee',
  cost: 10,
  damage: '1d6',
  weight: 2,
  properties: nil
}
short_sword = Weapon.new(**short_sword_h)

basic_equipment_h = {
  armor: padded_armor,
  left_hand_ring: nil,
  right_hand_ring: nil,
  amulet: nil,
  helmet: nil,
  cloak: nil,
  gloves: nil,
  bracers: nil,
  belt: nil,
  boots: nil,
  main_hand: short_sword,
  off_hand: nil
}
basic_equipment = Equipment.new(**basic_equipment_h)

basic_abilities_h = {
  strength: 17,
  dexterity: 10,
  constitution: 10,
  intelligence: 10,
  wisdom: 10,
  charisma: 10
}
basic_abilities = Abilities.new(**basic_abilities_h)

hero_h = {
  name: 'Hero',
  race: 'houman',
  level: 1,
  order: 'nil',
  background: 'blabla',
  abilities: basic_abilities,
  living_player: true,
  team: 1,
  max_hit_points: 30,
  equipment: basic_equipment,
  inventory: 'truc'
}
hero = Character.new(**hero_h)

enemy_h = {
  name: 'Gobelin',
  race: 'gobelin',
  level: 1,
  order: 'nil',
  background: 'blublu',
  abilities: basic_abilities,
  living_player: false,
  team: 2,
  max_hit_points: 20,
  equipment: basic_equipment,
  inventory: 'truc'
}

enemy_l_h = {
  name: 'Yuan-ti',
  race: 'yuan-ti',
  level: 1,
  order: 'nil',
  background: 'blublu',
  abilities: basic_abilities,
  living_player: false,
  team: 3,
  max_hit_points: 27,
  equipment: basic_equipment,
  inventory: 'truc'
}

enemy_d_h = {
  name: 'Walking dead bear-owl',
  race: 'undead',
  level: 1,
  order: 'nil',
  background: 'blublu',
  abilities: basic_abilities,
  living_player: false,
  team: 4,
  max_hit_points: 46,
  equipment: basic_equipment,
  inventory: 'truc'
}
enemy = Character.new(**enemy_h)
enemy2 = Character.new(**enemy_h)
enemy3 = Character.new(**enemy_l_h)
enemy4 = Character.new(**enemy_d_h)

combat = Combat.new(involved_fighters: [hero, enemy, enemy2, enemy3, enemy4])
puts "\n"
combat.resolve_initiative!
puts "\n"
round = 0
until combat.count_involved_teams <= 1
  round += 1
  puts `clear` if round > 1
  puts '_.-o•O0    -•-    0O•o-._'.center(101)
  combat.round_sequence
end
victors = combat.involved_fighters.map(&:name)
puts "`'°-•O0    -•-    0O•-°'´".center(101)
puts "\n"
puts "The fight is over. #{victors.join(', ')} #{victors.length > 1 ? 'are' : 'is'} victorious!"
