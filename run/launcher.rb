# frozen_string_literal: true

require 'factory_bot'
FactoryBot.find_definitions

involved_fighters = []
rand(2..10).times do
  involved_fighters << FactoryBot.build(:character)
end
involved_fighters << FactoryBot.build(:character, living_player: true)

combat = Combat.new(involved_fighters: involved_fighters)
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
