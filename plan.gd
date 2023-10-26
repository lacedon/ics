func plan():
	"""
		+ Create the UI buttons that allow to create a farm and a castle
		+ Buttons should icon and allow building to build
		+ Buttons on click should notify builder to start building a building
		+ Builder should show the half transparent building which is moving
			with mouse
		+ Builder should allow to build the building
		+ Building should notify if it can be builded
		- Building shouldn't allow to be build on wrong earth tiles
		- Builder should show animation if it cannot build building
		- There's a state with resources
		- Farm should increase resources
		- Farm should generate guys

		Стратегия не прямого управления
		
		Луп:
			игрок строит фермы
			фермы генерируют людей
			люди платят налоги
			??? игрок указывает какие товары продаются на рынке
				-> люди выбирают себе класс
			игрок указывает награды за действия:
					нарубить деревья, иследовать местность, убить того-то
			люди выстраивают свои приоритеты на основе наград и своего состояния
	"""
