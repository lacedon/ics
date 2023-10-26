extends Node

class_name State

func getStateName(): return 'State'

func activate(_previousState: State): pass

func deactivate(_nextState: State): pass
