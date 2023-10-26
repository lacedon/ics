extends State
class_name UnitStateIdle

## Short flow:
# getQuest
# if quest exist
#   setTarget(quest)
# else if hasBar
#   setTarget(bar)
# else
#   setTarget(random)

# @onready var _parent: Building = get_parent()

func getStateName(): return 'Idle'

func activate(_previousState: State):
  pass
