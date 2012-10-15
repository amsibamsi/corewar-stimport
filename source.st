SystemOrganization addCategory: #CoreWar!
SystemOrganization addCategory: #'CoreWar-Redcode'!
SystemOrganization addCategory: #'CoreWar-Tests'!

Error subclass: #CWMarsException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar'!

!CWMarsException commentStamp: 'as 4/26/2007 11:08' prior: 0!
MARS interpreter error.!

Error subclass: #CWRedcodeException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeException commentStamp: 'as 4/16/2007 16:34' prior: 0!
Generic Redcode exception.!

CWRedcodeException subclass: #CWRedcodeDecodeException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeDecodeException commentStamp: 'as 4/18/2007 21:19' prior: 0!
There was an error while trying to decode a redcode program from binary code.!

CWRedcodeException subclass: #CWRedcodeExecutionException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeExecutionException commentStamp: 'as 8/29/2007 23:39' prior: 0!
There was an error while executing a Redcode instruction. This is he case when an instruction is syntactically correct but not semanically.!

CWRedcodeException subclass: #CWRedcodeSyntaxException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeSyntaxException commentStamp: 'as 8/29/2007 23:38' prior: 0!
There was an error while trying to compile a Redcode program from source.!

Morph subclass: #CWMarsMorph
	instanceVariableNames: 'mars cellSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar'!

!CWMarsMorph commentStamp: 'as 8/27/2007 13:57' prior: 0!
Graphical representation of MARS.!

!CWMarsMorph class methodsFor: 'instance creation' stamp: 'as 9/3/2007 16:44'!
on: aCWMars

	^ self new
		mars: aCWMars;
		updateExtent;
		yourself.! !

!CWMarsMorph methodsFor: 'drawing' stamp: 'as 9/3/2007 12:57'!
border

	^ 10.! !

!CWMarsMorph methodsFor: 'drawing' stamp: 'as 8/30/2007 17:49'!
cellColor: index

	^ (mars color: index) ifNil: [ self neutralColor. ].! !

!CWMarsMorph methodsFor: 'drawing' stamp: 'as 9/3/2007 12:56'!
cellGap

	^ self cellSize // 2.! !

!CWMarsMorph methodsFor: 'drawing' stamp: 'as 9/3/2007 13:08'!
cellRectangle: aNumber

	| x y r |
	x _ (aNumber \\ self columns) * (self cellSize + self cellGap) + self border.
	y _ (aNumber // self columns) * (self cellSize + self cellGap) + self border.
	r _ (self bounds left + x) @ (self bounds top + y) extent: self cellSize @ self cellSize.
	^ r.! !

!CWMarsMorph methodsFor: 'accessing' stamp: 'as 8/29/2007 14:55'!
cellSize

	^ cellSize ifNil: [ cellSize _ self defaultCellSize. ].! !

!CWMarsMorph methodsFor: 'accessing' stamp: 'as 9/3/2007 16:46'!
cellSize: aNumber

	cellSize _ aNumber.
	self updateExtent; changed.! !

!CWMarsMorph methodsFor: 'drawing' stamp: 'as 9/3/2007 17:34'!
columns

	owner ifNil: [
		^ self defaultColumns.
	] ifNotNil: [
		^ ((owner width / owner height) * mars size sqrt) rounded.
	].! !

!CWMarsMorph methodsFor: 'accessing' stamp: 'as 8/31/2007 17:33'!
defaultCellSize

	^ 5.! !

!CWMarsMorph methodsFor: 'drawing' stamp: 'as 9/3/2007 17:34'!
defaultColumns

	^ 30.! !

!CWMarsMorph methodsFor: 'drawing' stamp: 'as 9/3/2007 16:43'!
drawOn: aCanvas

	"Clear canvas"
	aCanvas fillRectangle: self bounds fillStyle: Color transparent borderStyle: self borderStyle.
	
	"Draw cells"
	0 to: mars size - 1 do: [
		:index |
		self drawRect: index on: aCanvas.
	].! !

!CWMarsMorph methodsFor: 'drawing' stamp: 'as 9/3/2007 12:58'!
drawRect: index on: aCanvas

	aCanvas
		fillRectangle: (self cellRectangle: index)
		color: (self cellColor: index).! !

!CWMarsMorph methodsFor: 'accessing' stamp: 'as 8/27/2007 11:49'!
mars: aCWMars

	mars _ aCWMars.
	mars addDependent: self.! !

!CWMarsMorph methodsFor: 'drawing' stamp: 'as 8/24/2007 17:36'!
neutralColor

	^ Color gray lighter.! !

!CWMarsMorph methodsFor: 'updating' stamp: 'as 8/30/2007 16:41'!
update: aSymbol

	(self updates includes: aSymbol) ifTrue: [
		self perform: ('update', aSymbol asString capitalized) asSymbol.
	].! !

!CWMarsMorph methodsFor: 'updating' stamp: 'as 9/3/2007 16:43'!
updateCoreOwnership

	self changed.! !

!CWMarsMorph methodsFor: 'updating' stamp: 'as 9/3/2007 16:44'!
updateCoreSize

	self updateExtent; changed.! !

!CWMarsMorph methodsFor: 'updating' stamp: 'as 9/3/2007 17:30'!
updateExtent

	| x y |
	x _ self columns * (self cellSize + self cellGap) + (2 * self border).
	y _ (mars size // self columns) ceiling * (self cellSize + self cellGap) + (2 * self border).
	self extent: x @ y.! !

!CWMarsMorph methodsFor: 'updating' stamp: 'as 9/3/2007 16:43'!
updates

	^ #(#coreOwnership #coreSize).! !

Object subclass: #CWCoreWar
	instanceVariableNames: 'mars window programs players morphs selectedProgramIndex selectedPlayerIndex coreSize logText playerColors simulation rounds'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar'!

!CWCoreWar commentStamp: 'as 8/27/2007 13:57' prior: 0!
Core War morphic GUI.!

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/31/2007 10:07'!
abort

	simulation ifNotNil: [
		simulation terminate.
		self logError: 'Aborted'.
		simulation _ nil.
	].! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/30/2007 11:09'!
addPlayer

	| program color |
	program _ programs at: selectedProgramIndex ifAbsent: [ nil. ].
	program ifNotNil: [
		color _ self findLeastUsedPlayerColor.
		self addPlayerColor: color.
		players add: (CWPlayer program: program color: color).
		self refreshPlayerSelection.
		self changed: #players.
	].! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/17/2007 13:54'!
addPlayerColor: aColor

	| value |
	value _ playerColors at: aColor.
	playerColors at: aColor put: value + 1.! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/17/2007 20:04'!
buildAddRemovePlayerButtons

	morphs at: #addPlayerButton put: (
		(self
			buildButtonOn: self
			getState: #offButtonState
			action: #addPlayer
			label: '+')
		setBalloonText: 'Add selected program as player'
	).
	morphs at: #removePlayerButton put: (
		(self
			buildButtonOn: self
			getState: #offButtonState
			action: #removePlayer
			label: '-')
		setBalloonText: 'Remove selected player'
	).
	^ Morph new
		color: Color transparent;
		layoutPolicy: ProportionalLayout new;
		layoutInset: 1;
		addMorph: (morphs at: #addPlayerButton)
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 0.5 @ 1));
		addMorph: (morphs at: #removePlayerButton)
			fullFrame: (LayoutFrame fractions: (0.5 @ 0 corner: 1 @ 1)).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/11/2007 15:18'!
buildButtonOn: anObject getState: getStateSel action: actionSel label: aString

	^ (PluggableButtonMorph
			on: anObject
			getState: getStateSel
			action: actionSel)
		color: Color white;
		label: aString;
		onColor: Color gray muchLighter offColor: Color gray muchLighter.! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/29/2007 13:52'!
buildCellSizeOption

	morphs at: #cellSizeText put: (
		(PluggableTextMorph
			on: self
			text: #cellSizeText
			accept: #cellSizeText:)
		color: Color white;
		setBalloonText: 'Width and height of one core cell';
		acceptOnCR: true
	).
	(morphs at: #cellSizeText) extension setProperty: #noVScrollBarPlease toValue: true.
	^ Morph new
		color: self windowColor;
		layoutInset: 3;
		layoutPolicy: ProportionalLayout new;
		addMorph: (StringMorph contents: 'Cell size:')
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 0.5 @ 1));
		addMorph: (morphs at: #cellSizeText)
			fullFrame: (LayoutFrame fractions: (0.5 @ 0 corner: 0.5 @ 0)
				offsets: (0 @ 0 corner: self buttonWidth * 3 @ self buttonHeight)).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/22/2007 00:54'!
buildCoreSizeOption

	morphs at: #coreSizeText put: (
		(PluggableTextMorph
			on: self
			text: #coreSizeText
			accept: #coreSizeText:)
		color: Color white;
		setBalloonText: 'Number of cells in the core';
		acceptOnCR: true
	).
	(morphs at: #coreSizeText) extension setProperty: #noVScrollBarPlease toValue: true.
	^ Morph new
		color: self windowColor;
		layoutInset: 3;
		layoutPolicy: ProportionalLayout new;
		addMorph: (StringMorph contents: 'Core:')
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 0.5 @ 1));
		addMorph: (morphs at: #coreSizeText)
			fullFrame: (LayoutFrame fractions: (0.5 @ 0 corner: 0.5 @ 0)
				offsets: (0 @ 0 corner: self buttonWidth * 3 @ self buttonHeight)).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/22/2007 01:00'!
buildDelayOption

	morphs at: #delayText put: (
		(PluggableTextMorph
			on: self
			text: #delayText
			accept: #delayText:)
		color: Color white;
		setBalloonText: 'Delay in milliseconds between steps';
		acceptOnCR: true
	).
	(morphs at: #delayText) extension setProperty: #noVScrollBarPlease toValue: true.
	^ Morph new
		color: self windowColor;
		layoutInset: 3;
		layoutPolicy: ProportionalLayout new;
		addMorph: (StringMorph contents: 'Delay:')
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 0.5 @ 1));
		addMorph: (morphs at: #delayText)
			fullFrame: (LayoutFrame fractions: (0.5 @ 0 corner: 0.5 @ 0)
				offsets: (0 @ 0 corner: self buttonWidth * 3 @ self buttonHeight)).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/29/2007 13:14'!
buildLogPanel

	^ morphs at: #logText put: (
		PluggableTextMorph
			on: self
			text: #logText
			accept: nil
	).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 9/3/2007 16:47'!
buildMarsMorph

	| pane |
	morphs at: #marsMorph put: (CWMarsMorph on: mars).
	pane _ ScrollPane new.
	morphs at: #marsMorphScroller put: pane.
	pane scroller addMorph: (morphs at: #marsMorph).
	^ pane.! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/29/2007 15:24'!
buildOptionsPanel

	^ Morph new
		layoutPolicy: ProportionalLayout new;
		addMorph: self buildRunButtons
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 1 @ 0.2));
		addMorph: self buildCoreSizeOption
			fullFrame: (LayoutFrame fractions: (0 @ 0.2 corner: 1 @ 0.4));
		addMorph: self buildDelayOption
			fullFrame: (LayoutFrame fractions: (0 @ 0.4 corner: 1 @ 0.6));
		addMorph: self buildRoundsOption
			fullFrame: (LayoutFrame fractions: (0 @ 0.6 corner: 1 @ 0.8));
		addMorph: self buildCellSizeOption
			fullFrame: (LayoutFrame fractions: (0 @ 0.8 corner: 1 @ 1)).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/30/2007 10:55'!
buildPlayerPanel

	^ Morph new
		color: Color transparent;
		layoutPolicy: ProportionalLayout new;
		addMorph: self buildProgramSelection
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 1 @ 0.5));
		addMorph: self buildAddRemovePlayerButtons
			fullFrame: (LayoutFrame fractions: (0 @ 0.5 corner: 0 @ 0.5)
				offsets: (self buttonWidth @ 0
					corner: self buttonWidth * 3 @ self buttonHeight));
		addMorph: self buildPlayerSelection
			fullFrame: (LayoutFrame fractions: (0 @ 0.5 corner: 1 @ 1)
				offsets: (0 @ self buttonHeight corner: 0 @ 0)).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/11/2007 15:44'!
buildPlayerSelection

	^ Morph new
		color: Color transparent;
		layoutPolicy: ProportionalLayout new;
		addMorph: self buildPlayerSelectionButtons
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 0 @ 0)
				offsets: (0 @ 0 corner: (self buttonWidth) @ (self buttonHeight * 3)));
		addMorph: self buildPlayerSelectionList
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 1 @ 1)
				offsets: (self buttonWidth @ 0 corner: 0 @ 0)).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/17/2007 20:05'!
buildPlayerSelectionButtons

	morphs at: #playerUpButton put: (
		(self
			buildButtonOn: self
			getState: #offButtonState
			action: #playerUp
			label: 'u')
		setBalloonText: 'Move selected player upwards'
	).
	morphs at: #playerDownButton put: (
		(self
			buildButtonOn: self
			getState: #offButtonState
			action: #playerDown
			label: 'd')
		setBalloonText: 'Move selected player downwards'
	).
	morphs at: #cleanPlayersButton put: (
		(self
			buildButtonOn: self
			getState: #offButtonState
			action: #cleanPlayers
			label: 'c')
		setBalloonText: 'Clean up all players'
	).
	^ Morph new
		color: Color transparent;
		layoutPolicy: ProportionalLayout new;
		layoutInset: 1;
		addMorph: (morphs at: #playerUpButton)
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 1 @ (1/3)));
		addMorph: (morphs at: #playerDownButton)
			fullFrame: (LayoutFrame fractions: (0 @ (1/3) corner: 1 @ (2/3)));
		addMorph: (morphs at: #cleanPlayersButton)
			fullFrame: (LayoutFrame fractions: (0 @ (2/3) corner: 1 @ 1)).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/30/2007 11:58'!
buildPlayerSelectionList

	^ morphs at: #playerSelectionList put: (
		(PluggableListMorph
			on: self
			list: #players
			selected: #selectedPlayerIndex
			changeSelected: #selectPlayerIndex:)
		setBalloonText: 'Players';
		borderWidth: 1;
		borderColor: Color gray muchLighter
	).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/11/2007 12:41'!
buildProgramSelection

	^ Morph new
		color: Color transparent;
		layoutPolicy: ProportionalLayout new;
		addMorph: self buildProgramSelectionButtons
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 0 @ 0)
				offsets: (0 @ 0 corner: (self buttonWidth) @ (self buttonHeight * 3)));
		addMorph: self buildProgramSelectionList
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 1 @ 1)
				offsets: (self buttonWidth @ 0 corner: 0 @ 0)).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/30/2007 11:13'!
buildProgramSelectionButtons

	morphs at: #refreshProgramsButton put: (
		(self
			buildButtonOn: self
			getState: #offButtonState
			action: #refreshPrograms
			label: 'r')
		setBalloonText: 'Refresh programs list'
	).
	^ Morph new
		color: Color transparent;
		layoutPolicy: ProportionalLayout new;
		layoutInset: 1;
		addMorph: (morphs at: #refreshProgramsButton)
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 1 @ (1/3))).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/30/2007 11:13'!
buildProgramSelectionList

	^ morphs at: #programSelectionList put: (
		(PluggableListMorph
			on: self
			list: #programs
			selected: #selectedProgramIndex
			changeSelected: #selectProgramIndex:)
		setBalloonText: 'Available programs';
		borderWidth: 1;
		borderColor: Color gray muchLighter
	).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/29/2007 13:49'!
buildRoundsOption

	morphs at: #roundsText put: (
		(PluggableTextMorph
			on: self
			text: #roundsText
			accept: #roundsText:)
		color: Color white;
		setBalloonText: 'Maximum number of rounds in the battle';
		acceptOnCR: true
	).
	(morphs at: #roundsText) extension setProperty: #noVScrollBarPlease toValue: true.
	^ Morph new
		color: self windowColor;
		layoutInset: 3;
		layoutPolicy: ProportionalLayout new;
		addMorph: (StringMorph contents: 'Rounds:')
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 0.5 @ 1));
		addMorph: (morphs at: #roundsText)
			fullFrame: (LayoutFrame fractions: (0.5 @ 0 corner: 0.5 @ 0)
				offsets: (0 @ 0 corner: self buttonWidth * 3 @ self buttonHeight)).! !

!CWCoreWar methodsFor: 'window-building' stamp: 'as 8/24/2007 11:42'!
buildRunButtons

	morphs at: #runButton put: (
		(self
			buildButtonOn: self
			getState: #offButtonState
			action: #runPause
			label: 'Run')
		setBalloonText: 'Start the battle or pause running battle'
	).
	morphs at: #abortButton put: (
		(self
			buildButtonOn: self
			getState: #offButtonState
			action: #abort
			label: 'Abort')
		setBalloonText: 'Abort running battle'
	).
	^ Morph new
		color: self windowColor;
		layoutPolicy: ProportionalLayout new;
		layoutInset: 3;
		addMorph: (morphs at: #runButton)
			fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 0 @ 0)
				offsets: (0 @ 0 corner: self buttonWidth * 3 @ self buttonHeight));
		addMorph: (morphs at: #abortButton)
			fullFrame: (LayoutFrame fractions: (0.5 @ 0 corner: 0.5 @ 0)
				offsets: (0 @ 0 corner: self buttonWidth * 3 @ self buttonHeight)).! !

!CWCoreWar methodsFor: 'view' stamp: 'as 8/11/2007 15:06'!
buttonHeight

	^ 20.! !

!CWCoreWar methodsFor: 'view' stamp: 'as 8/11/2007 15:06'!
buttonWidth

	^ 20.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/29/2007 14:54'!
cellSizeText

	^ Text fromString: (morphs at: #marsMorph) cellSize asString.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 9/3/2007 15:53'!
cellSizeText: aText

	| size |
	size _ aText asString asInteger.
	size ifNil: [ size _ (morphs at: #marsMorph) defaultCellSize. ].
	size < 1 ifTrue: [ size _ 1. ].
	(morphs at: #marsMorph) cellSize: size.
	self updateMarsScroller.
	self changed: #cellSizeText.
	^ true.! !

!CWCoreWar methodsFor: 'logging' stamp: 'as 8/29/2007 13:24'!
characterLimit

	^ 1000.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/17/2007 14:23'!
cleanPlayers

	players copy do: [
		:player |
		self removePlayerColor: (players remove: player) color.
	].
	self unselectPlayer.
	self changed: #players.! !

!CWCoreWar methodsFor: 'logging' stamp: 'as 8/12/2007 14:11'!
contents

	^ self logText.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/22/2007 00:52'!
coreSizeText

	^ Text fromString: coreSize asString.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/24/2007 16:03'!
coreSizeText: aText

	| size |
	size _ aText asString asInteger.
	size ifNil: [ size _ mars defaultSize. ].
	size < 1 ifTrue: [ size _ 1. ].
	coreSize _ size.
	self changed: #coreSizeText.
	^ true.! !

!CWCoreWar methodsFor: 'accessing' stamp: 'as 8/17/2007 09:09'!
customPrograms

	^ OrderedCollection new.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/23/2007 15:10'!
delayText

	^ Text fromString: mars stepDelay asString.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/24/2007 16:04'!
delayText: aText

	| size |
	size _ aText asString asInteger.
	size ifNil: [ size _ mars defaultStepDelay. ].
	size < 0 ifTrue: [ size _ 0. ].
	mars stepDelay: size.
	self changed: #delayText.
	^ true.! !

!CWCoreWar methodsFor: 'view' stamp: 'as 8/17/2007 09:32'!
findLeastUsedPlayerColor

	| color |
	color _ nil.
	playerColors associationsDo: [
		:asc |
		color ifNil: [ color _ asc. ]
		ifNotNil: [ asc value < color value ifTrue: [ color _ asc. ]. ].
	].
	^ color key.! !

!CWCoreWar methodsFor: 'initialize-release' stamp: 'as 8/30/2007 11:04'!
initialize

	mars _ CWMars new.
	mars addDependent: self.
	players _ OrderedCollection new.
	morphs _ Dictionary new.
	selectedProgramIndex _ selectedPlayerIndex _ 0.
	coreSize _ mars defaultSize.
	rounds _ mars defaultRounds.
	self initializePrograms.
	self initializePlayerColors.
	self initializeWindow.! !

!CWCoreWar methodsFor: 'initialize-release' stamp: 'as 8/29/2007 15:50'!
initializePlayerColors

	playerColors _ Dictionary new.
	#(blue green red black brown cyan orange magenta) do: [
		:colorSymbol |
		playerColors at: (Color perform: colorSymbol) put: 0.
	].! !

!CWCoreWar methodsFor: 'initialize-release' stamp: 'as 8/17/2007 11:47'!
initializePrograms

	programs _ OrderedCollection newFrom: CWRedcode allRedcodes.! !

!CWCoreWar methodsFor: 'initialize-release' stamp: 'as 8/31/2007 09:46'!
initializeWindow

	window _ SystemWindow labelled: self windowTitle.
	window setWindowColor: self windowColor.
	window minimumExtent: 640@480.

	window
		addMorph: self buildPlayerPanel frame: (0 @ 0.4 corner: 0.3 @ 1);
		addMorph: self buildMarsMorph frame: (0.3 @ 0 corner: 1 @ 0.8);
		addMorph: self buildLogPanel frame: (0.3 @ 0.8 corner: 1 @ 1);

		"The option panel depends on other morphs and should be initialized in the end"
		addMorph: self buildOptionsPanel frame: (0 @ 0 corner: 0.3 @ 0.4).! !

!CWCoreWar methodsFor: 'testing' stamp: 'as 8/17/2007 11:14'!
isCustomProgramSelected

	^ self selectedCustomProgramIndex ~= 0.! !

!CWCoreWar methodsFor: 'testing' stamp: 'as 8/17/2007 13:43'!
isPlayerSelected

	^ self selectedPlayerIndex ~= 0.! !

!CWCoreWar methodsFor: 'testing' stamp: 'as 8/17/2007 11:14'!
isProgramSelected

	^ self selectedProgramIndex ~= 0.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/31/2007 10:02'!
isRunning

	^ simulation notNil and: [ simulation isSuspended. ]! !

!CWCoreWar methodsFor: 'logging' stamp: 'as 8/12/2007 13:54'!
logClear

	logText _ nil.
	(morphs at: #logText) update: #clearText.! !

!CWCoreWar methodsFor: 'logging' stamp: 'as 8/12/2007 13:53'!
logError: aString

	self logText: '(!!) ', aString.! !

!CWCoreWar methodsFor: 'logging' stamp: 'as 8/29/2007 13:26'!
logInfo: aString

	self logText: aString.! !

!CWCoreWar methodsFor: 'logging' stamp: 'as 8/12/2007 12:07'!
logText

	^ logText ifNil: [ logText _ String new. ].! !

!CWCoreWar methodsFor: 'logging' stamp: 'as 8/29/2007 13:35'!
logText: aString

	logText _ aString, Character cr asString.
	(morphs at: #logText) update: #appendEntry.! !

!CWCoreWar methodsFor: 'utility' stamp: 'as 8/12/2007 11:56'!
noop: anything

	.! !

!CWCoreWar methodsFor: 'view' stamp: 'as 8/9/2007 14:15'!
offButtonState

	^ false.! !

!CWCoreWar methodsFor: 'view' stamp: 'as 8/9/2007 18:24'!
open

	window openInWorld.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/18/2007 11:52'!
playerDown

	| index |
	self isPlayerSelected ifTrue: [
	index _ selectedPlayerIndex.
		(index > 0 and: [ index < players size. ]) ifTrue: [
			players swap: index with: index + 1.
			self selectPlayerIndex: index + 1.
			self changed: #players.
		].
	].! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/18/2007 11:51'!
playerUp

	| index |
	self isPlayerSelected ifTrue: [
	index _ selectedPlayerIndex.
		(index > 1 and: [ index <= players size. ]) ifTrue: [
			players swap: index with: index - 1.
			self selectPlayerIndex: index - 1.
			self changed: #players.
		].
	].! !

!CWCoreWar methodsFor: 'accessing' stamp: 'as 8/8/2007 16:56'!
players

	^ players.! !

!CWCoreWar methodsFor: 'accessing' stamp: 'as 8/17/2007 11:55'!
programs

	^ programs.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/17/2007 20:10'!
refreshPlayerSelection

	selectedPlayerIndex _ self selectedPlayerIndex min: players size max: 0.
	self changed: #selectPlayerIndex.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/17/2007 20:10'!
refreshProgramSelection

	selectedProgramIndex _ self selectedProgramIndex min: programs size max: 0.
	self changed: #selectProgramIndex.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/17/2007 20:03'!
refreshPrograms

	self initializePrograms.
	self refreshProgramSelection.
	self changed: #programs.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/17/2007 17:01'!
removePlayer

	self isPlayerSelected ifTrue: [
		self removePlayerColor: (players removeAt: selectedPlayerIndex) color.
		self refreshPlayerSelection.
		self changed: #players.
	].! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/17/2007 13:54'!
removePlayerColor: aColor

	| value |
	value _ playerColors at: aColor.
	playerColors at: aColor put: value - 1.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/29/2007 14:43'!
roundsText

	^ Text fromString: rounds asString.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/29/2007 14:41'!
roundsText: aText

	| size |
	size _ aText asString asInteger.
	size ifNil: [ size _ mars defaultRounds. ].
	size < 0 ifTrue: [ size _ 0. ].
	rounds _ size.
	self changed: #roundsText.
	^ true.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 9/3/2007 15:36'!
runPause

	simulation ifNil: [
		mars
			setPlayers: players;
			size: coreSize;
			rounds: rounds.
		simulation _ [ self simulate. ] newProcess.
		simulation resume.
	] ifNotNil: [
		simulation isSuspended ifTrue: [
			simulation resume.
			self logInfo: 'Resuming'.
		] ifFalse: [
			simulation suspend.
			self logInfo: 'Pausing'.
		].
	].! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/17/2007 11:59'!
selectPlayerIndex: aNumber

	selectedPlayerIndex _ aNumber.
	self changed: #selectedPlayerIndex.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/30/2007 11:02'!
selectProgramIndex: aNumber

	selectedProgramIndex _ aNumber.
	self changed: #selectedProgramIndex.! !

!CWCoreWar methodsFor: 'accessing' stamp: 'as 8/18/2007 11:43'!
selectedPlayerIndex

	^ selectedPlayerIndex.! !

!CWCoreWar methodsFor: 'accessing' stamp: 'as 8/18/2007 11:43'!
selectedProgramIndex

	^ selectedProgramIndex.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/31/2007 10:06'!
simulate

	| winners |
	self logClear; logInfo: 'Starting'.
	winners _ ''.
	[
		mars run do: [ :winner | winners _ winners, ' ', winner asString. ].
		self logInfo: 'Finished, winners are:', winners.
	] on: CWMarsException do: [
		:e |
		self logError: e asString.
	].
	simulation _ nil.! !

!CWCoreWar methodsFor: 'controller' stamp: 'as 8/17/2007 14:06'!
unselectPlayer

	selectedPlayerIndex _ 0.
	self changed: #selectedPlayerIndex.! !

!CWCoreWar methodsFor: 'updating' stamp: 'as 8/31/2007 09:44'!
update: aSymbol

	(self updates includes: aSymbol) ifTrue: [
		self perform: ('update', aSymbol asString capitalized) asSymbol.
	].! !

!CWCoreWar methodsFor: 'updating' stamp: 'as 8/31/2007 09:43'!
update: aSymbol with: anObject

	(self updateWiths includes: aSymbol) ifTrue: [
		self perform: ('update', aSymbol asString capitalized, ':') asSymbol with: anObject.
	].! !

!CWCoreWar methodsFor: 'updating' stamp: 'as 9/3/2007 15:52'!
updateCoreSize

	self updateMarsScroller.! !

!CWCoreWar methodsFor: 'updating' stamp: 'as 9/3/2007 16:48'!
updateMarsScroller

	(morphs at: #marsMorphScroller) setScrollDeltas.! !

!CWCoreWar methodsFor: 'updating' stamp: 'as 9/3/2007 12:44'!
updatePlayerDeath: aCWPlayer

	self logInfo: 'Player ', aCWPlayer asString, ' died'.! !

!CWCoreWar methodsFor: 'updating' stamp: 'as 9/3/2007 16:38'!
updateRound

	window setLabel: self windowTitle, ' (round ', mars currentRound asString, ' of ', mars rounds asString, ')'; changed.! !

!CWCoreWar methodsFor: 'updating' stamp: 'as 8/31/2007 09:43'!
updateWiths

	^ #(#playerDeath).! !

!CWCoreWar methodsFor: 'updating' stamp: 'as 9/3/2007 16:38'!
updates

	^ #(#round #coreSize).! !

!CWCoreWar methodsFor: 'view' stamp: 'as 8/11/2007 16:23'!
windowColor

	^ Color orange lighter.! !

!CWCoreWar methodsFor: 'view' stamp: 'as 8/31/2007 09:46'!
windowTitle

	^ 'Core War'.! !

Object subclass: #CWMars
	instanceVariableNames: 'core ownerships players pc counters size stepDelay rounds currentRound'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar'!

!CWMars commentStamp: 'as 4/16/2007 11:51' prior: 0!
Memory Array Redcode Simulator - the Core War interpreter.!

!CWMars class methodsFor: 'core' stamp: 'as 4/26/2007 21:20'!
maxValue

	^ self valueSize / 2.! !

!CWMars class methodsFor: 'core' stamp: 'as 4/27/2007 10:34'!
minValue

	^ self maxValue negated + 1.! !

!CWMars class methodsFor: 'limits' stamp: 'as 4/26/2007 21:19'!
valueBits

	^ CWRedcodeInstruction encodingBits + 1.! !

!CWMars class methodsFor: 'limits' stamp: 'as 4/26/2007 21:19'!
valueSize

	^ 2 raisedTo: self valueBits.! !

!CWMars methodsFor: 'core' stamp: 'as 8/24/2007 19:45'!
color: integerAddress

	| owner |
	owner _ ownerships at: (self internalAddress: integerAddress) ifAbsent: nil.
	^ owner ifNil: [ nil. ] ifNotNil: [ owner color. ].! !

!CWMars methodsFor: 'private' stamp: 'as 9/3/2007 15:36'!
coreAddress: anInteger

	"The address space is interpreted as ring, so out of bounds
	 addresses are not possible."
	
	| address |
	
	"Divide modulo for addresses that are out of bounds."
	address _ anInteger \\ self size.
	
	"Convert negative addresses."
	address negative ifTrue: [ address _ self coreSize - address. ].
	
	^ address.! !

!CWMars methodsFor: 'accessing' stamp: 'as 8/28/2007 13:38'!
counters

	^ counters.! !

!CWMars methodsFor: 'public' stamp: 'as 8/30/2007 11:49'!
currentRound

	^ currentRound ifNil: [ 0. ].! !

!CWMars methodsFor: 'private' stamp: 'as 9/3/2007 16:38'!
currentRound: aNumber

	currentRound _ aNumber.
	self changed: #round.! !

!CWMars methodsFor: 'defaults' stamp: 'as 4/20/2007 13:09'!
defaultRounds

	^ 1000.! !

!CWMars methodsFor: 'defaults' stamp: 'as 8/28/2007 14:00'!
defaultSize

	^ 1024.! !

!CWMars methodsFor: 'defaults' stamp: 'as 8/28/2007 13:54'!
defaultStepDelay

	^ 50.! !

!CWMars methodsFor: 'private' stamp: 'as 9/3/2007 16:49'!
freeCoreRange: anInteger

	| start free address |
	start _ self size atRandom.
	1 to: self size - anInteger do: [
		:count |
		address _ start + count.
		free _ true.
		0 to: anInteger - 1 do: [
			:offset |
			free _ free and: [ (self owner: (address + offset)) isNil. ].
		].
		free ifTrue: [ ^ address. ].
	].
	^ nil.
			! !

!CWMars methodsFor: 'initialize-release' stamp: 'as 8/24/2007 18:16'!
initialize

	self reset.! !

!CWMars methodsFor: 'initialize-release' stamp: 'as 4/26/2007 10:53'!
initializeCore

	core _ Array new: self size.
	core withIndexDo: [
		:value :index |
		core at: index put: self randomValue.
	].
	^ core.! !

!CWMars methodsFor: 'initialize-release' stamp: 'as 4/26/2007 11:58'!
initializeCounters

	^ counters _ Dictionary new.! !

!CWMars methodsFor: 'initialize-release' stamp: 'as 4/20/2007 17:10'!
initializeOwnerships

	^ ownerships _ Array new: self size.! !

!CWMars methodsFor: 'private' stamp: 'as 8/27/2007 14:51'!
internalAddress: anInteger

	"Internally the core is an array with indices from 1 to <size>.
	 From outside addresses normally go from 0 to size-1."
	
	^ (self coreAddress: anInteger) + 1.! !

!CWMars methodsFor: 'private' stamp: 'as 8/27/2007 14:53'!
internalValue: anInteger

	^ (anInteger min: self maxValue) max: self minValue.
! !

!CWMars methodsFor: 'private' stamp: 'as 8/26/2007 16:07'!
loadProgram: aCWPlayer

	| program start |
	program _ aCWPlayer program.
	start _ self freeCoreRange: program size.
	start ifNil: [ CWMarsException signal: 'No free space to load program'. ].
	program lines withIndexDo: [
		:line :index |
		self write: line encoded at: start + index - 1 for: aCWPlayer.
	].
	^ start.! !

!CWMars methodsFor: 'private' stamp: 'as 8/26/2007 16:06'!
loadPrograms

	self players do: [
		:player |
		counters at: player put: (self loadProgram: player).
	].! !

!CWMars methodsFor: 'core' stamp: 'as 4/26/2007 21:26'!
maxValue

	^ self class maxValue.! !

!CWMars methodsFor: 'core' stamp: 'as 4/18/2007 23:09'!
minValue

	^ self class minValue.! !

!CWMars methodsFor: 'core' stamp: 'as 8/24/2007 18:50'!
owner: integerAddress

	^ ownerships at: (self internalAddress: integerAddress) ifAbsent: nil.! !

!CWMars methodsFor: 'private' stamp: 'as 9/3/2007 16:32'!
owner: aCWPlayer at: integerAddress

	ownerships at: (self internalAddress: integerAddress) put: aCWPlayer.
	self changed: #coreOwnership.
	^ aCWPlayer.! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/20/2007 13:32'!
pc

	^ pc.! !

!CWMars methodsFor: 'accessing' stamp: 'as 8/24/2007 18:17'!
players

	^ players ifNil: [ players _ OrderedCollection new. ].! !

!CWMars methodsFor: 'initialize-release' stamp: 'as 4/26/2007 21:25'!
randomValue

	^ self valueSize atRandom - self maxValue.! !

!CWMars methodsFor: 'core' stamp: 'as 4/26/2007 11:57'!
read: integerAddress

	"Read value from the specified address."
	
	| address value |
	address _ self internalAddress: integerAddress.
	value _ (core at: address).
	^ value.! !

!CWMars methodsFor: 'initialize-release' stamp: 'as 8/24/2007 18:16'!
reset

	self
		initializeCore;
		initializeOwnerships;
		initializeCounters.! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/20/2007 13:09'!
rounds

	^ rounds ifNil: [ rounds _ self defaultRounds. ].! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/20/2007 13:26'!
rounds: anInteger

	rounds _ anInteger.! !

!CWMars methodsFor: 'public' stamp: 'as 8/30/2007 11:49'!
run

	| activePlayers instruction counter |
	self reset; loadPrograms.
	activePlayers _ self players copy.
	1 to: self rounds do: [
		:round |
		self currentRound: round.
		activePlayers do: [
			:player |
			pc _ counters at: player.
			[
				instruction _ CWRedcodeInstruction encoded: (self read: pc).
				self owner: player at: pc.
				counter _ instruction runOn: self for: player.
				counters at: player put: counter.
			]
				on: CWRedcodeDecodeException, CWRedcodeExecutionException
				do: [
					activePlayers remove: player.
					self changed: #playerDeath with: player.
					activePlayers size = 1 ifTrue: [ ^ activePlayers. ].
				].
		].
		(Delay forMilliseconds: self stepDelay) wait.
	].
	^ activePlayers.! !

!CWMars methodsFor: 'accessing' stamp: 'as 8/24/2007 18:50'!
setPlayers: aCollection

	players _ nil.
	self players addAll: aCollection.! !

!CWMars methodsFor: 'private' stamp: 'as 8/27/2007 13:44'!
size

	^ size ifNil: [ self size: self defaultSize. size. ].! !

!CWMars methodsFor: 'private' stamp: 'as 9/3/2007 15:39'!
size: anInteger

	size _ anInteger.
	self changed: #coreSize.! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/20/2007 13:08'!
stepDelay

	^ stepDelay ifNil: [ stepDelay _ self defaultStepDelay. ].! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/20/2007 13:26'!
stepDelay: anInteger

	stepDelay _ anInteger.! !

!CWMars methodsFor: 'limits' stamp: 'as 4/26/2007 21:26'!
valueSize

	^ self class valueSize.! !

!CWMars methodsFor: 'core' stamp: 'as 8/24/2007 19:00'!
write: valueInteger at: integerAddress for: aCWPlayer

	"Write value at the specified address."
	
	| value |
	value _ self internalValue: valueInteger.
	core at: (self internalAddress: integerAddress) put: value.
	self owner: aCWPlayer at: integerAddress.
	^ value.! !

Object subclass: #CWPlayer
	instanceVariableNames: 'program color'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar'!

!CWPlayer commentStamp: 'as 8/17/2007 11:07' prior: 0!
A program participating in a Core War game.!

!CWPlayer class methodsFor: 'instance creation' stamp: 'as 8/17/2007 11:08'!
program: aCWRedcode color: aColor

	^ self new
		program: aCWRedcode;
		color: aColor;
		yourself.! !

!CWPlayer methodsFor: 'accessing' stamp: 'as 8/17/2007 13:50'!
color

	^ color.! !

!CWPlayer methodsFor: 'accessing' stamp: 'as 8/8/2007 17:39'!
color: aColor

	color _ aColor.! !

!CWPlayer methodsFor: 'printing' stamp: 'as 8/29/2007 17:15'!
printOn: aStream

	aStream nextPutAll: program name, '(', (color name ifNil: [ 'unknown color'. ]), ')'.! !

!CWPlayer methodsFor: 'accessing' stamp: 'as 8/23/2007 17:06'!
program

	^ program.! !

!CWPlayer methodsFor: 'accessing' stamp: 'as 8/8/2007 17:39'!
program: aCWRedcode

	program _ aCWRedcode.! !

Object subclass: #CWRedcode
	instanceVariableNames: 'lines name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcode commentStamp: 'as 4/18/2007 23:15' prior: 0!
A Core War program in Redcode language.
This is a object representation of a Redcode program. It can either be build from source code (string) or encoded binary code (integers).!

!CWRedcode class methodsFor: 'redcodes' stamp: 'as 8/8/2007 21:40'!
allRedcodes

	| redcodes |
	redcodes _ OrderedCollection new.
	self class localSelectors select: [
		:selector |
		selector asString beginsWith: self newSelectorPrefix.
	] thenDo: [
		:selector |
		redcodes add: (self perform: selector).
	].
	^ redcodes.! !

!CWRedcode class methodsFor: 'instance creation' stamp: 'as 4/20/2007 11:44'!
encoded: aCollection

	"Initialize the program from binary code (a collection of integers)."

	| program count |
	aCollection isEmpty ifTrue: [ CWRedcodeDecodeException signal: 'Empty encoding'. ].
	program _ self new.
	count _ 1.
	aCollection do: [
		:integer |
		[ program addLine: (CWRedcodeInstruction encoded: integer). ]
			on: CWRedcodeDecodeException
			do: [ :ex | CWRedcodeDecodeException signal: 'In line ', count asString, ': ', ex messageText. ].
		count _ count + 1.
	].
	^ program.! !

!CWRedcode class methodsFor: 'instance creation' stamp: 'as 8/8/2007 21:43'!
encoded: aCollection name: aString

	^ (self encoded: aCollection) name: aString; yourself.! !

!CWRedcode class methodsFor: 'redcodes' stamp: 'as 8/27/2007 17:54'!
newRedcodeDwarf

	^ self source: '
		DAT #0
		ADD #4 -1
		MOV #0 @-2
		JMP -2'
	name: 'Dwarf4'.! !

!CWRedcode class methodsFor: 'redcodes' stamp: 'as 8/17/2007 09:05'!
newRedcodeImp

	^ self source: '
		MOV 0 1'
	name: 'Imp'.! !

!CWRedcode class methodsFor: 'redcodes' stamp: 'as 8/29/2007 23:32'!
newRedcodeStuck

	^ self source: '
		JMP 0'
	name: 'Stuck'.! !

!CWRedcode class methodsFor: 'redcodes' stamp: 'as 8/29/2007 23:31'!
newRedcodeSuicide

	^ self source: '
		JMP 1'
	name: 'Suicide'.! !

!CWRedcode class methodsFor: 'instance creation' stamp: 'as 8/8/2007 21:40'!
newSelectorPrefix

	^ 'newRedcode'.! !

!CWRedcode class methodsFor: 'instance creation' stamp: 'as 4/20/2007 11:51'!
source: aString

	"Initialize the program from source code (a string with instruction lines)."

	| program count |
	program _ self new.
	count _ 1.
	aString linesDo: [
		:line |
		line withSeparatorsCompacted isEmpty ifFalse: [
			[ program addLine: (CWRedcodeInstruction source: line) ]
				on: CWRedcodeSyntaxException
				do: [ :ex | CWRedcodeSyntaxException signal: 'In line ', count asString, ': ', ex messageText. ].
		].
		count _ count + 1.
	].
	program lines isEmpty ifTrue: [ CWRedcodeSyntaxException signal: 'Empty source'. ].
	^ program.! !

!CWRedcode class methodsFor: 'instance creation' stamp: 'as 8/8/2007 21:41'!
source: sourceString name: nameString

	^ (self source: sourceString) name: nameString; yourself.! !

!CWRedcode methodsFor: 'public' stamp: 'as 4/17/2007 18:06'!
addLine: aCWRedcodeInstruction

	self lines add: aCWRedcodeInstruction.! !

!CWRedcode methodsFor: 'converting' stamp: 'as 4/19/2007 09:21'!
binarySource

	| string |
	string _ String new.
	self asIntegers do: [
		:integer |
		string _ string, (integer printStringRadix: 2), String cr.
	].
	^ string.! !

!CWRedcode methodsFor: 'defaults' stamp: 'as 8/8/2007 18:05'!
defaultName

	^ 'Noname'.! !

!CWRedcode methodsFor: 'converting' stamp: 'as 4/18/2007 23:29'!
encoded

	| collection |
	collection _ OrderedCollection new.
	self lines doWithIndex: [
		:line :index |
		collection add: line encoded.
	].
	^ collection.! !

!CWRedcode methodsFor: 'accessing' stamp: 'as 4/17/2007 15:52'!
lines

	^ lines ifNil: [ lines _ OrderedCollection new. ].! !

!CWRedcode methodsFor: 'accessing' stamp: 'as 8/8/2007 18:05'!
name

	^ name ifNil: [ name _ self defaultName. ].! !

!CWRedcode methodsFor: 'accessing' stamp: 'as 8/8/2007 18:05'!
name: aString

	name _ aString.! !

!CWRedcode methodsFor: 'printing' stamp: 'as 8/9/2007 11:23'!
printOn: aStream

	aStream nextPutAll: self name, ' (', self lines size asString, ' lines)'.! !

!CWRedcode methodsFor: 'public' stamp: 'as 4/20/2007 14:02'!
size

	^ self lines size.! !

!CWRedcode methodsFor: 'converting' stamp: 'as 4/20/2007 11:48'!
source

	| string |
	string _ String new.
	self lines do: [
		:line |
		string _ string, line source, String cr.
	].
	^ string withBlanksCondensed.! !

Object subclass: #CWRedcodeInstruction
	instanceVariableNames: 'operand1 operand2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeInstruction commentStamp: 'as 4/17/2007 17:47' prior: 0!
A command in the form of "<instruction> <operand1> [<operand2>]".
New subclasses must be registered in self>>allInstructions to be recognized during build from source or binary code.!

CWRedcodeInstruction subclass: #CWRedcodeAddInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeAddInstruction commentStamp: 'as 4/17/2007 08:19' prior: 0!
ADD A B - Add operand A to contents of location B and store result in location B.!

!CWRedcodeAddInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:27'!
encoding

	^ 2.! !

!CWRedcodeAddInstruction class methodsFor: 'private' stamp: 'as 4/19/2007 16:06'!
operand2Types

	^ CWRedcodeOperand relativeOperands.! !

!CWRedcodeAddInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 08:26'!
symbol

	^ #ADD.! !

!CWRedcodeAddInstruction methodsFor: 'executing' stamp: 'as 8/24/2007 19:01'!
executeOn: mars for: player

	| value |
	value _ (operand1 valueOn: mars) + (operand2 valueOn: mars).
	mars write: value at: (operand2 locationOn: mars) for: player.
	^ super executeOn: mars for: player.! !

CWRedcodeInstruction subclass: #CWRedcodeCompareInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeCompareInstruction commentStamp: 'as 4/17/2007 11:08' prior: 0!
CMP A B - Compare operand A with operand B. If they are not equal, skip next instruction; otherwise continue with next instruction.
!

!CWRedcodeCompareInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:27'!
encoding

	^ 7.! !

!CWRedcodeCompareInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:08'!
symbol

	^ #CMP.! !

!CWRedcodeCompareInstruction methodsFor: 'executing' stamp: 'as 8/24/2007 19:32'!
executeOn: mars for: player

	(operand1 valueOn: mars) = (operand2 valueOn: mars) ifTrue: [
		^ super executeOn: mars for: player.
	] ifFalse: [
		^ mars pc + 2.
	].! !

CWRedcodeInstruction subclass: #CWRedcodeDataInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeDataInstruction commentStamp: 'as 4/18/2007 10:31' prior: 0!
DAT A - Initialize location to value A.!

!CWRedcodeDataInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:28'!
encoding

	^ 0.! !

!CWRedcodeDataInstruction class methodsFor: 'testing' stamp: 'as 4/18/2007 10:17'!
hasSecondOperand

	^ false.! !

!CWRedcodeDataInstruction class methodsFor: 'private' stamp: 'as 4/19/2007 16:02'!
operand2Types

	^ Set new add: CWRedcodeEmptyOperand; yourself.! !

!CWRedcodeDataInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 08:22'!
symbol

	^ #DAT.! !

!CWRedcodeDataInstruction methodsFor: 'executing' stamp: 'as 8/27/2007 17:50'!
executeOn: mars for: player

	mars write: (operand1 valueOn: mars) at: mars pc for: player.
	^ super executeOn: mars for: player.! !

CWRedcodeInstruction subclass: #CWRedcodeDecrementJumpZeroInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeDecrementJumpZeroInstruction commentStamp: 'as 4/17/2007 11:06' prior: 0!
DJZ A B - Decrement contents of location A by 1. If location A now holds 0, jump to location B; otherwise continue with next instruction.!

!CWRedcodeDecrementJumpZeroInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:28'!
encoding

	^ 6.! !

!CWRedcodeDecrementJumpZeroInstruction class methodsFor: 'private' stamp: 'as 4/19/2007 16:07'!
operand2Types

	^ CWRedcodeOperand relativeOperands.! !

!CWRedcodeDecrementJumpZeroInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:06'!
symbol

	^ #DJZ.! !

!CWRedcodeDecrementJumpZeroInstruction methodsFor: 'executing' stamp: 'as 8/24/2007 19:32'!
executeOn: mars for: player

	((operand1 valueOn: mars) - 1) = 0 ifTrue: [
		^ operand2 locationOn: mars.
	] ifFalse: [
		^ super executeOn: mars for: player.
	].
	! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 11:22'!
allInstructions

	"A set of instructions allowed in this language."

	^ Set new
		add: CWRedcodeDataInstruction;
		add: CWRedcodeMoveInstruction;
		add: CWRedcodeAddInstruction;
		add: CWRedcodeSubtractInstruction;
		add: CWRedcodeJumpInstruction;
		add: CWRedcodeJumpZeroInstruction;
		add: CWRedcodeDecrementJumpZeroInstruction;
		add: CWRedcodeCompareInstruction;
		yourself.! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/19/2007 16:26'!
encoded: anInteger

	| instruction val type op1 op2 |
	val _ anInteger.
	op2 _ val // (2 raisedTo: self operand2BitShift).
	val _ val \\ (2 raisedTo: self operand2BitShift).
	op1 _ val // (2 raisedTo: self operand1BitShift).
	type _ val \\ (2 raisedTo: self operand1BitShift).
	instruction _ self instructionForInteger: type.
	[
		instruction
			operand1: (CWRedcodeOperand encoded: op1);
			operand2: (CWRedcodeOperand encoded: op2).
	]
		on: CWRedcodeException
		do: [ :ex | CWRedcodeDecodeException signal: ex messageText. ].
	^ instruction.! !

!CWRedcodeInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:25'!
encoding

	"All instructions must be sequentially numbered with an integer for integer encoding."

	self subclassResponsibility.! !

!CWRedcodeInstruction class methodsFor: 'converting' stamp: 'as 4/18/2007 13:05'!
encodingBits

	^ self typeEncodingBits + CWRedcodeOperand encodingBits * 2.! !

!CWRedcodeInstruction class methodsFor: 'testing' stamp: 'as 4/18/2007 10:16'!
hasSecondOperand

	^ true.! !

!CWRedcodeInstruction class methodsFor: 'private' stamp: 'as 4/18/2007 21:18'!
instructionForInteger: anInteger

	self allInstructions do: [
		:class |
		class encoding = anInteger ifTrue: [ ^ class new. ].
	].
	CWRedcodeDecodeException signal: '"', anInteger asString, '" is not a valid instruction type'.! !

!CWRedcodeInstruction class methodsFor: 'private' stamp: 'as 4/17/2007 14:12'!
instructionForString: aString

	self allInstructions do: [
		:class |
		class symbol = aString asSymbol ifTrue: [ ^ class new. ].
	].
	CWRedcodeSyntaxException signal: '"', aString, '" is not a valid instruction'.! !

!CWRedcodeInstruction class methodsFor: 'converting' stamp: 'as 4/19/2007 13:10'!
operand1BitShift

	^ self typeEncodingBits.! !

!CWRedcodeInstruction class methodsFor: 'private' stamp: 'as 4/26/2007 14:59'!
operand1Types

	"Allowed operand types for operand 1."

	^ CWRedcodeOperand normalOperands.! !

!CWRedcodeInstruction class methodsFor: 'converting' stamp: 'as 4/19/2007 13:11'!
operand2BitShift

	^ self operand1BitShift + CWRedcodeOperand encodingBits.! !

!CWRedcodeInstruction class methodsFor: 'private' stamp: 'as 4/26/2007 14:59'!
operand2Types

	"Allowed operand types of operand 2."

	^ CWRedcodeOperand normalOperands.! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/20/2007 11:53'!
source: aString

	| instruction tokens rest |
	tokens _ self tokensFor: aString withSeparatorsCompacted withBlanksTrimmed.
	instruction _ self instructionForString: (tokens at: 1).
	[
		instruction operand1: (CWRedcodeOperand source: (tokens at: 2)).
		instruction hasSecondOperand ifTrue: [
			instruction operand2: (CWRedcodeOperand source: (tokens at: 3)).
			rest _ tokens at: 4.
		] ifFalse: [
			instruction operand2: (CWRedcodeEmptyOperand new).
			rest _ (tokens at: 3).
		].
	]
		on: CWRedcodeException
		do: [ :ex | CWRedcodeSyntaxException signal: ex messageText. ].
	rest isEmpty ifFalse:
		[ CWRedcodeSyntaxException signal: 'Expected end of line instead of "', rest, '"'. ].
	^ instruction.! !

!CWRedcodeInstruction class methodsFor: 'converting' stamp: 'as 4/16/2007 16:31'!
symbol

	"The mnemonic symbol used in Redcode source for this instruction
	 (case sensitive)."

	self subclassResponsibility.! !

!CWRedcodeInstruction class methodsFor: 'private' stamp: 'as 4/18/2007 10:53'!
tokensFor: aString

	| tokens stream |
	tokens _ OrderedCollection new.
	stream _ ReadStream on: aString, ' '.
	4 timesRepeat: [
		tokens add: (stream nextDelimited: ' ' asCharacter).
	].
	^ tokens.! !

!CWRedcodeInstruction class methodsFor: 'converting' stamp: 'as 4/18/2007 22:06'!
typeEncodingBits

	^ (self allInstructions size log: 2) ceiling.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/17/2007 17:27'!
allInstructions

	^ self class allInstructions.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/19/2007 13:13'!
encoded

	^ self encoding +
		(operand1 encoded * (2 raisedTo: self operand1BitShift)) +
		(operand2 encoded * (2 raisedTo: self operand2BitShift)).! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/17/2007 11:25'!
encoding

	^ self class encoding.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/18/2007 13:07'!
encodingBits

	^ self class encodingBits.! !

!CWRedcodeInstruction methodsFor: 'executing' stamp: 'as 8/24/2007 19:01'!
executeOn: aCWMars for: aCWPlayer

	"Execute the instruction on the MARS simulator.
	 Return the address for the next instruction."
	
	^ aCWMars pc + 1.! !

!CWRedcodeInstruction methodsFor: 'testing' stamp: 'as 4/18/2007 10:16'!
hasSecondOperand

	^ self class hasSecondOperand.! !

!CWRedcodeInstruction methodsFor: 'private' stamp: 'as 4/19/2007 21:07'!
operand1

	^ operand1.! !

!CWRedcodeInstruction methodsFor: 'private' stamp: 'as 4/19/2007 16:46'!
operand1: aCWRedcodeOperand

	(self operand1Types includes: aCWRedcodeOperand class) ifFalse: [
		CWRedcodeException signal: 'Invalid type for operand 1'.
	].
	operand1 _ aCWRedcodeOperand.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/19/2007 13:11'!
operand1BitShift

	^ self class operand1BitShift.! !

!CWRedcodeInstruction methodsFor: 'private' stamp: 'as 4/19/2007 15:30'!
operand1Types

	^ self class operand1Types.! !

!CWRedcodeInstruction methodsFor: 'private' stamp: 'as 4/19/2007 21:07'!
operand2

	^ operand2.! !

!CWRedcodeInstruction methodsFor: 'private' stamp: 'as 4/19/2007 16:46'!
operand2: aCWRedcodeOperand

	(self operand2Types includes: aCWRedcodeOperand class) ifFalse: [
		CWRedcodeException signal: 'Invalid type for operand 2'.
	].
	operand2 _ aCWRedcodeOperand.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/19/2007 13:11'!
operand2BitShift

	^ self class operand2BitShift.! !

!CWRedcodeInstruction methodsFor: 'private' stamp: 'as 4/19/2007 15:30'!
operand2Types

	^ self class operand2Types.! !

!CWRedcodeInstruction methodsFor: 'executing' stamp: 'as 8/29/2007 23:45'!
runOn: aCWMars for: aCWPlayer

	[ ^ self executeOn: aCWMars for: aCWPlayer.	]
		on: CWRedcodeException
		do: [ :ex | CWRedcodeExecutionException signal: ex messageText. ].! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/19/2007 17:11'!
source

	^ (self symbol asString, ' ', operand1 source, ' ', operand2 source) withBlanksCondensed.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/18/2007 11:31'!
symbol

	^ self class symbol.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/18/2007 17:20'!
typeEncodingBits

	^ self class typeEncodingBits.! !

CWRedcodeInstruction subclass: #CWRedcodeJumpInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeJumpInstruction commentStamp: 'as 4/18/2007 10:31' prior: 0!
JMP A - Jump to location A.!

!CWRedcodeJumpInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:29'!
encoding

	^ 4.! !

!CWRedcodeJumpInstruction class methodsFor: 'testing' stamp: 'as 4/18/2007 10:17'!
hasSecondOperand

	^ false.! !

!CWRedcodeJumpInstruction class methodsFor: 'private' stamp: 'as 4/19/2007 16:07'!
operand1Types

	^ CWRedcodeOperand relativeOperands.! !

!CWRedcodeJumpInstruction class methodsFor: 'private' stamp: 'as 4/19/2007 16:06'!
operand2Types

	^ Set new add: CWRedcodeEmptyOperand; yourself.! !

!CWRedcodeJumpInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:23'!
symbol

	^ #JMP.! !

!CWRedcodeJumpInstruction methodsFor: 'executing' stamp: 'as 8/24/2007 19:32'!
executeOn: mars for: player

	^ operand1 locationOn: mars.! !

CWRedcodeInstruction subclass: #CWRedcodeJumpZeroInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeJumpZeroInstruction commentStamp: 'as 4/17/2007 11:00' prior: 0!
JMZ A B - If operand A is 0, jump to location B; otherwise continue with next instruction.!

!CWRedcodeJumpZeroInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:29'!
encoding

	^ 5.! !

!CWRedcodeJumpZeroInstruction class methodsFor: 'private' stamp: 'as 4/19/2007 16:19'!
operand2Types

	^ CWRedcodeOperand relativeOperands.! !

!CWRedcodeJumpZeroInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:04'!
symbol

	^ #JMZ.! !

!CWRedcodeJumpZeroInstruction methodsFor: 'executing' stamp: 'as 8/24/2007 19:33'!
executeOn: mars for: player

	(operand1 valueOn: mars) = 0 ifTrue: [
		^ operand2 locationOn: mars.
	] ifFalse: [
		^ super executeOn: mars for: player.
	].! !

CWRedcodeInstruction subclass: #CWRedcodeMoveInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeMoveInstruction commentStamp: 'as 4/17/2007 01:13' prior: 0!
MOV A B - Move A into location B.!

!CWRedcodeMoveInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:29'!
encoding

	^ 1.! !

!CWRedcodeMoveInstruction class methodsFor: 'private' stamp: 'as 4/19/2007 16:19'!
operand2Types

	^ CWRedcodeOperand relativeOperands.! !

!CWRedcodeMoveInstruction class methodsFor: 'converting' stamp: 'as 4/16/2007 16:43'!
symbol

	^ #MOV.! !

!CWRedcodeMoveInstruction methodsFor: 'executing' stamp: 'as 8/27/2007 17:47'!
executeOn: mars for: player

	mars write: (operand1 valueOn: mars) at: (operand2 locationOn: mars) for: player.
	^ super executeOn: mars for: player.! !

CWRedcodeInstruction subclass: #CWRedcodeSubtractInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeSubtractInstruction commentStamp: 'as 4/17/2007 08:20' prior: 0!
SUB A B - Subtract operand A from contents of location B and store result in location B.!

!CWRedcodeSubtractInstruction class methodsFor: 'converting' stamp: 'as 4/19/2007 17:10'!
encoding

	^ 3.! !

!CWRedcodeSubtractInstruction class methodsFor: 'private' stamp: 'as 4/19/2007 16:20'!
operand2Types

	^ CWRedcodeOperand relativeOperands.! !

!CWRedcodeSubtractInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 08:28'!
symbol

	^ #SUB.! !

!CWRedcodeSubtractInstruction methodsFor: 'executing' stamp: 'as 8/24/2007 19:33'!
executeOn: mars for: player

	| value |
	value _ (operand2 valueOn: mars) - (operand1 valueOn: mars).
	mars write: value at: (operand2 locationOn: mars) for: player.
	^ super executeOn: mars for: player.! !

Object subclass: #CWRedcodeOperand
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeOperand commentStamp: 'as 4/17/2007 17:46' prior: 0!
An operand of a Redcode instruction.
New operands must be registered in self>>allOperands to be recognized during build from source or binary code.!

CWRedcodeOperand subclass: #CWRedcodeEmptyOperand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeEmptyOperand commentStamp: 'as 4/18/2007 10:22' prior: 0!
A placeholder for instructions that use just one operand.!

!CWRedcodeEmptyOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 23:40'!
encoded: anInteger

	^ self new.! !

!CWRedcodeEmptyOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 10:30'!
encoding

	^ 3.! !

!CWRedcodeEmptyOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 23:40'!
source: aString

	self shouldNotImplement.! !

!CWRedcodeEmptyOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 11:38'!
symbol

	^ #''.! !

!CWRedcodeEmptyOperand class methodsFor: 'private' stamp: 'as 4/18/2007 11:38'!
valueRegex

	^ ''.! !

!CWRedcodeEmptyOperand methodsFor: 'initialize-release' stamp: 'as 4/18/2007 10:35'!
initialize

	value _ 0.! !

!CWRedcodeEmptyOperand methodsFor: 'executing' stamp: 'as 8/27/2007 17:37'!
locationOn: mars

	CWRedcodeException signal: 'An empty operand does not have an address'.! !

!CWRedcodeEmptyOperand methodsFor: 'converting' stamp: 'as 4/19/2007 17:12'!
source

	^ ''.! !

!CWRedcodeEmptyOperand methodsFor: 'executing' stamp: 'as 8/27/2007 17:37'!
valueOn: mars

	CWRedcodeException signal: 'An empty operand does not have a value'.! !

CWRedcodeOperand subclass: #CWRedcodeImmediateOperand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeImmediateOperand commentStamp: 'as 4/17/2007 01:30' prior: 0!
String representation: #<number>. The operand is <number>.!

!CWRedcodeImmediateOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 23:40'!
encoded: anInteger

	^ self new
		value: anInteger;
		yourself.! !

!CWRedcodeImmediateOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 10:29'!
encoding

	^ 0.! !

!CWRedcodeImmediateOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 23:40'!
source: aString

	^ self new
		value: (aString copyFrom: 2 to: aString size) asInteger;
		yourself.! !

!CWRedcodeImmediateOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 11:37'!
symbol

	^ #'#'.! !

!CWRedcodeImmediateOperand methodsFor: 'executing' stamp: 'as 8/27/2007 17:36'!
locationOn: mars

	CWRedcodeException signal: 'A immediate operand does not have an address.'.! !

!CWRedcodeImmediateOperand methodsFor: 'executing' stamp: 'as 4/26/2007 14:31'!
valueOn: mars

	^ value.! !

CWRedcodeOperand subclass: #CWRedcodeIndirectOperand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeIndirectOperand commentStamp: 'as 4/17/2007 01:33' prior: 0!
String representation: @<number>. Like a relative operand but the resulting operand is interpreted as address where the real operand resides.!

!CWRedcodeIndirectOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 23:40'!
encoded: anInteger

	^ self new
		value: anInteger;
		yourself.! !

!CWRedcodeIndirectOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 10:30'!
encoding

	^ 2.! !

!CWRedcodeIndirectOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 23:41'!
source: aString

	^ self new
		value: (aString copyFrom: 2 to: aString size) asInteger;
		yourself.! !

!CWRedcodeIndirectOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 11:37'!
symbol

	^ #@.! !

!CWRedcodeIndirectOperand methodsFor: 'executing' stamp: 'as 8/27/2007 15:16'!
locationOn: mars

	| address |
	address _ mars pc + value.
	^ address + (mars read: address).! !

!CWRedcodeIndirectOperand methodsFor: 'executing' stamp: 'as 4/26/2007 14:30'!
valueOn: mars

	^ mars read: (self locationOn: mars).! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 8/24/2007 19:41'!
allOperands

	"A set of operands allowed in Redcode."
	
	^ Set new
		add: CWRedcodeImmediateOperand;
		add: CWRedcodeRelativeOperand;
		add: CWRedcodeIndirectOperand;
		add: CWRedcodeEmptyOperand;
		yourself.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/19/2007 23:39'!
encoded: anInteger

	| type negative absValue val |
	val _ anInteger.
	absValue _ val // (2 raisedTo: self typeEncodingBits + 1).
	val _ val \\ (2 raisedTo: self typeEncodingBits + 1).
	negative _ val // (2 raisedTo: self typeEncodingBits).
	type _ val \\ (2 raisedTo: self typeEncodingBits).
	self allOperands do: [
		:class |
		type = class encoding ifTrue: [ ^ class encoded: (1 - (2 * negative)) * absValue. ].
	].
	CWRedcodeDecodeException signal: '"', type asString, '" is not a valid operand type'.! !

!CWRedcodeOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 10:29'!
encoding

	"All operands must be sequentially numbered with an integer for integer encoding."

	^ self subclassResponsibility.! !

!CWRedcodeOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 13:06'!
encodingBits

	^ self typeEncodingBits + self sizeBits + 1.! !

!CWRedcodeOperand class methodsFor: 'limits' stamp: 'as 4/18/2007 13:00'!
max

	^ self size / 2.! !

!CWRedcodeOperand class methodsFor: 'limits' stamp: 'as 4/18/2007 13:00'!
min

	^ self max negated - 1.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/26/2007 14:59'!
normalOperands
	
	^ self allOperands remove: CWRedcodeEmptyOperand; yourself.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/26/2007 14:58'!
relativeOperands
	
	^ self allOperands remove: CWRedcodeImmediateOperand; yourself.! !

!CWRedcodeOperand class methodsFor: 'limits' stamp: 'as 4/18/2007 13:00'!
size

	^ 2 raisedTo: self sizeBits.! !

!CWRedcodeOperand class methodsFor: 'limits' stamp: 'as 4/18/2007 17:31'!
sizeBits

	"The number of bits used to store the integer.
	 Determines the minimum and maximum values."
	
	"Warning: Changing this might break any already initilized
	 objects of the Core War package."

	^ 12.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 23:38'!
source: aString

	aString ifEmpty: [ CWRedcodeSyntaxException signal: 'Operand is empty'. ].
	self allOperands do: [
		:class |
		(aString matchesRegex: class valueRegex)
			ifTrue: [ ^ class source: aString. ].
	].
	CWRedcodeSyntaxException signal: '"', aString, '" is not a valid operand'.! !

!CWRedcodeOperand class methodsFor: 'converting' stamp: 'as 4/19/2007 21:39'!
typeEncodingBits

	^ (self allOperands size log: 2) ceiling.! !

!CWRedcodeOperand class methodsFor: 'private' stamp: 'as 4/18/2007 11:34'!
valueRegex

	"Should return a regular expression as documented in RxParser that
	 is used to verify the string value before initializing an instance from."

	^ self symbol asString, '-?[0-9]+'.! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/17/2007 19:27'!
allOperands

	^ self class allOperands.! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/18/2007 23:36'!
encoded

	| negative |
	value negative ifTrue: [ negative _ 1. ] ifFalse: [ negative _ 0. ].
	^ self encoding +
		(negative * (2 raisedTo: self typeEncodingBits)) +
		(value abs * (2 raisedTo: self typeEncodingBits + 1)).! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/18/2007 10:29'!
encoding

	^ self class encoding.! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/18/2007 13:04'!
encodingBits

	^ self class encodingBits.! !

!CWRedcodeOperand methodsFor: 'executing' stamp: 'as 4/26/2007 14:05'!
locationOn: aCWMars

	"Return the final location of the operand, interpreting
	 all relative, indirect or other addresses."

	self subclassResponsibility.! !

!CWRedcodeOperand methodsFor: 'settings' stamp: 'as 4/18/2007 13:01'!
max

	^ self class max.! !

!CWRedcodeOperand methodsFor: 'settings' stamp: 'as 4/18/2007 13:01'!
min

	^ self class min.! !

!CWRedcodeOperand methodsFor: 'settings' stamp: 'as 4/18/2007 13:00'!
size

	^ self class size.! !

!CWRedcodeOperand methodsFor: 'settings' stamp: 'as 4/18/2007 12:58'!
sizeBits

	^ self class sizeBits.! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/18/2007 23:36'!
source

	^ self symbol asString, value asString.! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/18/2007 11:40'!
symbol

	^ self class symbol.! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/18/2007 13:06'!
typeEncodingBits

	^ self class typeEncodingBits.! !

!CWRedcodeOperand methodsFor: 'accessing' stamp: 'as 4/16/2007 17:07'!
value

	^ value.! !

!CWRedcodeOperand methodsFor: 'private' stamp: 'as 4/18/2007 12:55'!
value: anInteger

	anInteger > self max ifTrue: [
		value _ self max.
	] ifFalse: [
		anInteger < self min ifTrue: [
			value_ self min.
		] ifFalse: [
			value _ anInteger.
		].
	].! !

!CWRedcodeOperand methodsFor: 'executing' stamp: 'as 4/26/2007 13:33'!
valueOn: aCWMars

	"Return the final value of the operand, interpreting
	 all relative, indirect or other addresses."

	self subclassResponsibility.! !

CWRedcodeOperand subclass: #CWRedcodeRelativeOperand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeRelativeOperand commentStamp: 'as 4/20/2007 00:07' prior: 0!
String representation: <number>. The operand is the value at the address that is build from the value of the current location plus the offset <number>.!

!CWRedcodeRelativeOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 23:39'!
encoded: anInteger

	^ self new
		value: anInteger;
		yourself.! !

!CWRedcodeRelativeOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 10:30'!
encoding

	^ 1.! !

!CWRedcodeRelativeOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 23:39'!
source: aString

	^ self new
		value: aString asInteger;
		yourself.! !

!CWRedcodeRelativeOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 11:36'!
symbol

	^ #''.! !

!CWRedcodeRelativeOperand methodsFor: 'accessing' stamp: 'as 4/26/2007 14:30'!
locationOn: mars

	^ mars pc + value.! !

!CWRedcodeRelativeOperand methodsFor: 'accessing' stamp: 'as 4/26/2007 14:30'!
valueOn: mars

	^ mars read: (self locationOn: mars).! !

TestCase subclass: #CWCodingTest
	instanceVariableNames: 'mars'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Tests'!

!CWCodingTest commentStamp: 'as 4/16/2007 11:52' prior: 0!
CoreWar coding style tests.!

!CWCodingTest methodsFor: 'testing' stamp: 'as 4/16/2007 11:27'!
testClassComments

	| package |
	package _ PackageOrganizer default packageOfClass: self class.
	package classes do: [
		:class |
		self assert: class hasComment.
	].! !

TestCase subclass: #CWMarsTest
	instanceVariableNames: 'mars'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Tests'!

!CWMarsTest commentStamp: 'as 4/16/2007 11:03' prior: 0!
CWMars tests.!

!CWMarsTest methodsFor: 'running' stamp: 'as 4/16/2007 11:04'!
setUp

	mars _ CWMars new.! !

!CWMarsTest methodsFor: 'testing' stamp: 'as 9/3/2007 15:36'!
testCoreSize
	
	self assert: (CWMars new size: 1024; yourself) coreSize = 1024.! !

!CWMarsTest methodsFor: 'testing' stamp: 'as 9/3/2007 15:37'!
testDefaults
	
	self assert: mars size notNil.
	self assert: mars rounds notNil.
	self assert: mars stepDelay notNil.! !

!CWMarsTest methodsFor: 'testing' stamp: 'as 4/27/2007 10:20'!
testMaxValue
	
	"Otherwise not all encoded instructions can't be stored in the core."
	self assert: CWMars maxValue >= (2 raisedTo: CWRedcodeInstruction encodingBits).! !

TestCase subclass: #CWRedcodeInstructionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Tests'!

!CWRedcodeInstructionTest commentStamp: 'as 4/18/2007 10:27' prior: 0!
Test Redcode instructions.!

!CWRedcodeInstructionTest methodsFor: 'testing' stamp: 'as 4/20/2007 00:10'!
testBuildingFromEncoding

	| encoding redcode |
	encoding _ Integer readFrom: (ReadStream on: '1001000000000100110101') radix: 2.
	self
		shouldnt: [ redcode _ CWRedcodeInstruction encoded: encoding. ]
		raise: CWRedcodeDecodeException.
	self assert: redcode class = CWRedcodeJumpZeroInstruction.
	self assert: redcode operand1 class = CWRedcodeIndirectOperand.
	self assert: redcode operand1 value = -4.
	self assert: redcode operand2 class = CWRedcodeRelativeOperand.
	self assert: redcode operand2 value = 1.! !

!CWRedcodeInstructionTest methodsFor: 'testing' stamp: 'as 4/20/2007 00:10'!
testBuildingFromSource

	| redcode |
	self
		shouldnt: [ redcode _ CWRedcodeInstruction source: 'ADD #1 @2'. ]
		raise: CWRedcodeSyntaxException.
	self assert: redcode class = CWRedcodeAddInstruction.
	self assert: redcode operand1 class = CWRedcodeImmediateOperand.
	self assert: redcode operand1 value = 1.
	self assert: redcode operand2 class = CWRedcodeIndirectOperand.
	self assert: redcode operand2 value = 2.! !

!CWRedcodeInstructionTest methodsFor: 'testing' stamp: 'as 4/20/2007 00:09'!
testEmptyOperand

	| redcode |
	redcode _ CWRedcodeInstruction source: 'JMP 0'.
	self assert: redcode operand2 class = CWRedcodeEmptyOperand.! !

!CWRedcodeInstructionTest methodsFor: 'testing' stamp: 'as 4/20/2007 00:01'!
testEncoding

	| op1 op2 redcode |
	op1 _ CWRedcodeImmediateOperand new value: -1; yourself.
	op2 _ CWRedcodeRelativeOperand new value: -2; yourself.
	redcode _ CWRedcodeSubtractInstruction new
		operand1: op1;
		operand2: op2;
		yourself.
	self assert: redcode encoded = 5505123.! !

!CWRedcodeInstructionTest methodsFor: 'testing' stamp: 'as 4/20/2007 00:05'!
testInvalidInstruction

	self should: [ CWRedcodeInstruction source: 'DATA 0'. ] raise: CWRedcodeSyntaxException.! !

!CWRedcodeInstructionTest methodsFor: 'testing' stamp: 'as 4/20/2007 00:06'!
testLineTooLong

	self should: [ CWRedcodeInstruction source: 'ADD #1 @0 4'. ] raise: CWRedcodeSyntaxException.! !

!CWRedcodeInstructionTest methodsFor: 'testing' stamp: 'as 4/19/2007 23:59'!
testSource

	| op1 op2 redcode |
	op1 _ CWRedcodeImmediateOperand new value: -1; yourself.
	op2 _ CWRedcodeRelativeOperand new value: -2; yourself.
	redcode _ CWRedcodeSubtractInstruction new
		operand1: op1;
		operand2: op2;
		yourself.
	self assert: redcode source = 'SUB #-1 -2'.! !

!CWRedcodeInstructionTest methodsFor: 'testing' stamp: 'as 4/20/2007 00:04'!
testTooFewOperands

	self should: [ CWRedcodeInstruction source: 'MOV #1'. ] raise: CWRedcodeSyntaxException.! !

!CWRedcodeInstructionTest methodsFor: 'testing' stamp: 'as 4/20/2007 00:04'!
testTooManyOperands

	self should: [ CWRedcodeInstruction source: 'DAT #1 #1'. ] raise: CWRedcodeSyntaxException.! !

!CWRedcodeInstructionTest methodsFor: 'testing' stamp: 'as 4/17/2007 11:25'!
testUniqueEncodings

	| count encodings |
	count _ CWRedcodeInstruction allInstructions size.
	encodings _ Set new.
	CWRedcodeInstruction allInstructions do: [
		:class |
		encodings add: class encoding.
	].
	self assert: count = encodings size.! !

!CWRedcodeInstructionTest methodsFor: 'testing' stamp: 'as 4/17/2007 11:23'!
testUniqueSymbols

	| count symbols |
	count _ CWRedcodeInstruction allInstructions size.
	symbols _ Set new.
	CWRedcodeInstruction allInstructions do: [
		:class |
		symbols add: class symbol.
	].
	self assert: count = symbols size.! !

TestCase subclass: #CWRedcodeOperandTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Tests'!

!CWRedcodeOperandTest commentStamp: 'as 4/18/2007 10:26' prior: 0!
Test Redcode operands.!

!CWRedcodeOperandTest methodsFor: 'testing' stamp: 'as 4/18/2007 10:28'!
testUniqueEncodings

	| count encodings |
	count _ CWRedcodeOperand allOperands size.
	encodings _ Set new.
	CWRedcodeOperand allOperands do: [
		:class |
		encodings add: class encoding.
	].
	self assert: count = encodings size.! !

TestCase subclass: #CWRedcodeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Tests'!

!CWRedcodeTest commentStamp: 'as 4/20/2007 08:14' prior: 0!
Test Redcode.!

!CWRedcodeTest methodsFor: 'testing' stamp: 'as 4/20/2007 08:16'!
testEmptyProgram

	self should: [ CWRedcode source: ''. ] raise: CWRedcodeSyntaxException.
	self should: [ CWRedcode encoded: Set new. ] raise: CWRedcodeDecodeException.! !

!CWRedcodeTest methodsFor: 'testing' stamp: 'as 4/20/2007 08:25'!
testEmptySourceLines

	| redcode |
	redcode _ CWRedcode source:
		String cr, String cr, 'ADD 1 2', String cr, 'SUB #3 @-5', String cr.
	self assert: redcode source = ('ADD 1 2', String cr, 'SUB #3 @-5').! !

!CWRedcodeTest methodsFor: 'testing' stamp: 'as 4/20/2007 11:57'!
testWhitespace

	| redcode |
	redcode _ CWRedcode source:
		'   ADD  1   2      ', String cr, '	SUB	 #3		 @-5		'.
	self assert: redcode source = ('ADD 1 2', String cr, 'SUB #3 @-5').! !
