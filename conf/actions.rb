# frozen_string_literal: true

require_relative './conf'

attack_action_key = 'attack'
dodge_action_key = 'dodge'

COMBAT_ACTIONS_CHOICES = [
  OUTPUT_INDENT + '1: ' + attack_action_key,
  OUTPUT_INDENT + '2: ' + dodge_action_key
].freeze

COMBAT_ACTION_IDENTIFIERS = Hash[
  attack_action_key => %w[1 attack],
  dodge_action_key => %w[2 dodge]
]

COMBAT_ACTION_COMMANDS = Hash[
  attack_action_key => 'select_and_attack_target',
  dodge_action_key => 'dodge_until_next_turn'
]
