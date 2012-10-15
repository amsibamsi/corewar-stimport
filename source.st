SystemOrganization addCategory: #CoreWar!
SystemOrganization addCategory: #'CoreWar-Redcode'!
SystemOrganization addCategory: #'CoreWar-Redcode-Tests'!
SystemOrganization addCategory: #'CoreWar-Tests'!

Exception subclass: #CWRedcodeException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeException commentStamp: 'as 4/16/2007 16:34' prior: 0!
Generic Redcode exception.!

Object subclass: #CWMars
	instanceVariableNames: 'core programs pc counters size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar'!

!CWMars commentStamp: 'as 4/16/2007 11:51' prior: 0!
Memory Array Redcode Simulator - the Core War interpreter.!

!CWMars class methodsFor: 'instance creation' stamp: 'as 4/16/2007 11:52'!
withCoreSize: anInteger

	^ self new
		size: anInteger;
		yourself.! !

!CWMars methodsFor: 'public' stamp: 'as 4/16/2007 01:25'!
addProgram: aCWProgram

	self programs add: aCWProgram.! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/16/2007 10:55'!
core

	^ core ifNil: [ self initializeCore. ].! !

!CWMars methodsFor: 'public' stamp: 'as 4/16/2007 11:28'!
coreSize

	^ self core size.! !

!CWMars methodsFor: 'public' stamp: 'as 4/16/2007 11:28'!
coreSize: anInteger

	size _ anInteger.
	core ifNotNil: [ self initializeCore. ].! !

!CWMars methodsFor: 'defaults' stamp: 'as 4/15/2007 21:19'!
defaultSize

	^ 4096.! !

!CWMars methodsFor: 'initialize-release' stamp: 'as 4/16/2007 10:55'!
initializeCore

	core _ Array with: self size.! !

!CWMars methodsFor: 'initialize-release' stamp: 'as 4/16/2007 10:56'!
initializePrograms

	programs _ OrderedCollection new.! !

!CWMars methodsFor: 'initialize-release' stamp: 'as 4/16/2007 10:56'!
initializeSize

	size _ self defaultSize.! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/16/2007 10:55'!
programs

	^ programs ifNil: [ self initializePrograms. ].! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/16/2007 10:56'!
size

	^ size ifNil: [ self initializeSize. ].! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/15/2007 21:50'!
size: anInteger

	size _ anInteger.! !

Object subclass: #CWProgram
	instanceVariableNames: 'lines'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar'!

!CWProgram commentStamp: 'as 4/16/2007 11:51' prior: 0!
A Core War program.!

!CWProgram class methodsFor: 'instance creation' stamp: 'as 4/16/2007 15:49'!
fromString: aString

	self subclassResponsibility.! !

!CWProgram methodsFor: 'public' stamp: 'as 4/16/2007 14:17'!
addLine: aCWProgramNode

	self lines add: aCWProgramNode.! !

!CWProgram methodsFor: 'initialize-release' stamp: 'as 4/16/2007 14:16'!
initializeLines

	lines _ OrderedCollection new.! !

!CWProgram methodsFor: 'accessing' stamp: 'as 4/16/2007 14:16'!
lines

	^ lines ifNil: [ self initializeLines. ].! !

CWProgram subclass: #CWRedcode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcode commentStamp: 'as 4/16/2007 01:17' prior: 0!
A Redcode program.!

!CWRedcode class methodsFor: 'instance creation' stamp: 'as 4/16/2007 16:18'!
fromString: aString

	| program |
	program _ self new.
	aString linesDo: [
		:line |
		program addLine: (CWRedcodeInstruction fromString: line).
	].
	^ program.! !

Object subclass: #CWRedcodeInstruction
	instanceVariableNames: 'operand1 operand2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeInstruction commentStamp: 'as 4/16/2007 15:52' prior: 0!
A Redcode command in the form of "<INSTRUCTION> <OPERAND1> <OPERAND2>".!

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/16/2007 17:04'!
fromString: aString

	| command tokens instruction |
	command _ self new.
	tokens _ self tokensFor: aString.
	instruction _ self instructionForString: (tokens at: 1).
	instruction operand1: (CWRedcodeOperand fromString: (tokens at: 2)).
	instruction operand1: (CWRedcodeOperand fromString: (tokens at: 3)).
	^ command.! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/16/2007 16:31'!
instructionForString: aString

	subclasses do: [
		:subclass |
		subclass symbol = aString asSymbol ifTrue: [ ^ subclass new. ].
	].
	CWRedcodeException signal: 'No instruction found for symbol #', aString.! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/16/2007 16:31'!
symbol

	"The mnemonic symbol used in Redcode source for this instruction
	 (case sensitive)."

	self subclassResponsibility.! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/16/2007 17:04'!
tokensFor: aString

	| tokens stream |
	tokens _ OrderedCollection new.
	stream _ ReadStream on: aString.
	1 to: 3 do: [
		tokens add: (stream nextDelimited: ' ' asCharacter).
	].
	^ tokens.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/16/2007 17:07'!
asInteger

	self notYetImplemented.! !

!CWRedcodeInstruction methodsFor: 'executing' stamp: 'as 4/16/2007 17:06'!
executeOn: aCWMars

	self notYetImplemented.! !

!CWRedcodeInstruction methodsFor: 'accessing' stamp: 'as 4/16/2007 16:10'!
operand1: aCWRedcodeOperand

	operand1 _ aCWRedcodeOperand.! !

!CWRedcodeInstruction methodsFor: 'accessing' stamp: 'as 4/16/2007 16:10'!
operand2: aCWRedcodeOperand

	operand2 _ aCWRedcodeOperand.! !

CWRedcodeInstruction subclass: #CWRedcodeMoveInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeMoveInstruction commentStamp: 'as 4/16/2007 16:42' prior: 0!
Redcode move instruction.!

!CWRedcodeMoveInstruction class methodsFor: 'instance creation' stamp: 'as 4/16/2007 16:43'!
symbol

	^ #MOV.! !

Object subclass: #CWRedcodeOperand
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeOperand commentStamp: 'as 4/16/2007 16:32' prior: 0!
An operand of a Redcode instruction.!

CWRedcodeOperand subclass: #CWRedcodeImmediateOperand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeImmediateOperand commentStamp: 'as 4/16/2007 21:15' prior: 0!
#<value>, where <value> is the operand.!

!CWRedcodeImmediateOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 21:57'!
fromString: aString

	^ self new
		value: (aString copyFrom: 2 to: aString size) asInteger;
		yourself.! !

!CWRedcodeImmediateOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 21:15'!
startCharacters

	^ '#'.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 21:09'!
fromString: aString

	subclasses do: [
		:subclass |
		(subclass startCharacters includes: aString first)
			ifTrue: [ ^ subclass fromString: aString. ].
	].
	CWRedcodeException signal: aString, ' is not a valid operand'.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 21:13'!
startCharacters

	"Should return a string whose characters can all be used as
	 starting character of the value to initialize an instance from."

	self subclassResponsibility.! !

!CWRedcodeOperand methodsFor: 'accessing' stamp: 'as 4/16/2007 17:07'!
value

	^ value.! !

!CWRedcodeOperand methodsFor: 'accessing' stamp: 'as 4/16/2007 17:07'!
value: anInteger

	value _ anInteger.! !

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

!CWMarsTest methodsFor: 'testing' stamp: 'as 4/16/2007 11:56'!
testCoreSize

	mars coreSize: 10.
	self assert: (mars coreSize = 10).
	
	self assert: (CWMars withCoreSize: 1024) coreSize = 1024.! !
