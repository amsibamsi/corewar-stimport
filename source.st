SystemOrganization addCategory: #CoreWar!
SystemOrganization addCategory: #'CoreWar-Redcode'!
SystemOrganization addCategory: #'CoreWar-Redcode-Tests'!
SystemOrganization addCategory: #'CoreWar-Tests'!

Error subclass: #CWRedcodeException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeException commentStamp: 'as 4/16/2007 16:34' prior: 0!
Generic Redcode exception.!

CWRedcodeException subclass: #CWRedcodeSyntaxException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeSyntaxException commentStamp: 'as 4/17/2007 13:50' prior: 0!
There was an error when trying to compile a Redcode program from source code.!

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

!CWMars methodsFor: 'public' stamp: 'as 4/17/2007 15:52'!
addProgram: aCWRedcode

	self programs add: aCWRedcode.! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/17/2007 19:34'!
core

	^ core ifNil: [ core _ OrderedCollection new: self size. ].! !

!CWMars methodsFor: 'public' stamp: 'as 4/16/2007 11:28'!
coreSize

	^ self core size.! !

!CWMars methodsFor: 'defaults' stamp: 'as 4/15/2007 21:19'!
defaultSize

	^ 4096.! !

!CWMars methodsFor: 'core' stamp: 'as 4/17/2007 15:48'!
initialCoreValue

	"The initial value at any address in the core."
	
	^ 0.! !

!CWMars methodsFor: 'core' stamp: 'as 4/17/2007 15:07'!
internalAddress: anInteger

	"Internally the core is an array with indices from 1 to <size>.
	 From outside addresses go normally from 0 to size-1.
	 The address space is interpreted as ring, so out of bounds
	 addresses are not possible."
	
	| address |
	
	"Divide module for addresses that are too high."
	address _ anInteger \\ self coreSize.
	
	"Convert negative addresses."
	address negative ifTrue: [ address _ self coreSize - address. ].
	
	"Internal addressing starts with 1, not 0."
	address + 1.
	
	^ address.! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/17/2007 11:53'!
programs

	^ programs ifNil: [ programs _ OrderedCollection new. ].! !

!CWMars methodsFor: 'public' stamp: 'as 4/17/2007 15:47'!
read: integerAddress

	"Read value from the specified address."
	
	| address value |
	address _ self internalAddress: integerAddress.
	value _ (self core at: address) ifNil: [ self core at: address put: self initialCoreValue. ].
	^ value.! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/17/2007 11:54'!
size

	^ size ifNil: [ size _ self defaultSize. ].! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/15/2007 21:50'!
size: anInteger

	size _ anInteger.! !

!CWMars methodsFor: 'public' stamp: 'as 4/17/2007 15:50'!
write: anInteger at: integerAddress

	"Write value at the specified address."
	
	self core at: (self internalAddress: integerAddress) put: anInteger.
	^ anInteger.! !

Object subclass: #CWRedcode
	instanceVariableNames: 'lines'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcode commentStamp: 'as 4/17/2007 17:48' prior: 0!
A Core War program in Redcode language.
This is a object representation of a Redcode program. It can either be build from source code (string) or binary code (integers).!

!CWRedcode class methodsFor: 'instance creation' stamp: 'as 4/18/2007 10:12'!
fromIntegers: aCollection

	"Initialize the program from binary code."

	| program |
	aCollection isEmpty ifTrue: [ CWRedcodeSyntaxException signal: 'Empty source'. ].
	program _ self new.
	aCollection do: [
		:integer |
		program addLine: (CWRedcodeInstruction fromInteger: integer).
	].
	^ program.! !

!CWRedcode class methodsFor: 'instance creation' stamp: 'as 4/18/2007 11:27'!
fromString: aString

	"Initialize the program from source code."

	| program source count |
	aString isEmpty ifTrue: [ CWRedcodeSyntaxException signal: 'Empty source'. ].
	program _ self new.
	source _ aString withBlanksCondensed.
	count _ 1.
	source linesDo: [
		:line |
		[ program addLine: (CWRedcodeInstruction fromString: line) ]
			on: CWRedcodeSyntaxException
			do: [ :ex | CWRedcodeSyntaxException signal: 'In line ', count asString, ': ', ex messageText. ].
		count _ count + 1.
	].
	^ program.! !

!CWRedcode methodsFor: 'public' stamp: 'as 4/17/2007 18:06'!
addLine: aCWRedcodeInstruction

	self lines add: aCWRedcodeInstruction.! !

!CWRedcode methodsFor: 'converting' stamp: 'as 4/17/2007 19:58'!
asBinaryString

	| string |
	string _ String new.
	self asIntegers do: [
		:integer |
		string _ string, (integer printStringRadix: 2), String cr.
	].
	^ string.! !

!CWRedcode methodsFor: 'converting' stamp: 'as 4/18/2007 11:24'!
asIntegers

	| collection |
	collection _ OrderedCollection new.
	self lines doWithIndex: [
		:line :index |
		collection add: line asInteger.
	].
	^ collection.! !

!CWRedcode methodsFor: 'converting' stamp: 'as 4/18/2007 11:41'!
asString

	| string |
	string _ String new.
	self lines do: [
		:line |
		string _ string, line asString, String cr.
	].
	^ string withBlanksCondensed.! !

!CWRedcode methodsFor: 'accessing' stamp: 'as 4/17/2007 15:52'!
lines

	^ lines ifNil: [ lines _ OrderedCollection new. ].! !

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

!CWRedcodeAddInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 08:26'!
symbol

	^ #ADD.! !

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

!CWRedcodeDataInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 08:22'!
symbol

	^ #DAT.! !

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

!CWRedcodeDecrementJumpZeroInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:06'!
symbol

	^ #DJZ.! !

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

!CWRedcodeInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:25'!
encoding

	"All instructions must be sequentially numbered with an integer for integer encoding."

	self subclassResponsibility.! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 19:44'!
fromInteger: anInteger

	| instruction tokens |
	instruction _ self new.
	tokens _ self tokensFor: anInteger.
	instruction _ self instructionForString: (tokens at: 1).
	instruction operand1: (CWRedcodeOperand fromString: (tokens at: 2)).
	instruction operand2: (CWRedcodeOperand fromString: (tokens at: 3)).
	^ instruction.! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/18/2007 11:27'!
fromString: aString

	| instruction tokens rest |
	instruction _ self new.
	tokens _ self tokensFor: aString.
	instruction _ self instructionForString: (tokens at: 1).
	instruction operand1: (CWRedcodeOperand fromString: (tokens at: 2)).
	instruction hasSecondOperand ifTrue: [
		instruction operand2: (CWRedcodeOperand fromString: (tokens at: 3)).
		rest _ tokens at: 4.
	] ifFalse: [
		instruction operand2: (CWRedcodeEmptyOperand new).
		rest _ (tokens at: 3), (tokens at: 4).
	].
	rest isEmpty ifFalse:
		[ CWRedcodeSyntaxException signal: 'Expected end of line instead of "', rest, '"'. ].
	^ instruction.! !

!CWRedcodeInstruction class methodsFor: 'testing' stamp: 'as 4/18/2007 10:16'!
hasSecondOperand

	^ true.! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 14:12'!
instructionForString: aString

	self allInstructions do: [
		:class |
		class symbol = aString asSymbol ifTrue: [ ^ class new. ].
	].
	CWRedcodeSyntaxException signal: '"', aString, '" is not a valid instruction'.! !

!CWRedcodeInstruction class methodsFor: 'converting' stamp: 'as 4/16/2007 16:31'!
symbol

	"The mnemonic symbol used in Redcode source for this instruction
	 (case sensitive)."

	self subclassResponsibility.! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/18/2007 10:53'!
tokensFor: aString

	| tokens stream |
	tokens _ OrderedCollection new.
	stream _ ReadStream on: aString, ' '.
	4 timesRepeat: [
		tokens add: (stream nextDelimited: ' ' asCharacter).
	].
	^ tokens.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/17/2007 17:27'!
allInstructions

	^ self class allInstructions.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/17/2007 18:19'!
asInteger

	^ self encoding +
		operand1 asInteger * self operand1Radix +
		operand2 asInteger * self operand2Radix.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/18/2007 11:32'!
asString

	^ (self symbol asString, ' ', operand1 asString, ' ', operand2 asString) withBlanksCondensed.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/17/2007 11:25'!
encoding

	^ self class encoding.! !

!CWRedcodeInstruction methodsFor: 'executing' stamp: 'as 4/17/2007 11:33'!
executeOn: aCWMars

	"Execute the instruction on the MARS simulator."
	
	self subclassResponsibility.! !

!CWRedcodeInstruction methodsFor: 'testing' stamp: 'as 4/18/2007 10:16'!
hasSecondOperand

	^ self class hasSecondOperand.! !

!CWRedcodeInstruction methodsFor: 'accessing' stamp: 'as 4/16/2007 16:10'!
operand1: aCWRedcodeOperand

	operand1 _ aCWRedcodeOperand.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/17/2007 19:41'!
operand1Radix

	^ 2 raisedTo: (self allInstructions size log: 2) ceiling.! !

!CWRedcodeInstruction methodsFor: 'accessing' stamp: 'as 4/16/2007 16:10'!
operand2: aCWRedcodeOperand

	operand2 _ aCWRedcodeOperand.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/17/2007 18:19'!
operand2Radix

	^ self operand1Radix * operand1 radix.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/18/2007 11:31'!
symbol

	^ self class symbol.! !

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

!CWRedcodeJumpInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:23'!
symbol

	^ #JMP.! !

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

!CWRedcodeJumpZeroInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:04'!
symbol

	^ #JMZ.! !

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

!CWRedcodeMoveInstruction class methodsFor: 'converting' stamp: 'as 4/16/2007 16:43'!
symbol

	^ #MOV.! !

CWRedcodeInstruction subclass: #CWRedcodeSubtractInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeSubtractInstruction commentStamp: 'as 4/17/2007 08:20' prior: 0!
SUB A B - Subtract operand A from contents of location B and store result in location B.!

!CWRedcodeSubtractInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:30'!
encoding

	^ 2.! !

!CWRedcodeSubtractInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 08:28'!
symbol

	^ #SUB.! !

Object subclass: #CWRedcodeOperand
	instanceVariableNames: 'value max'
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

!CWRedcodeEmptyOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 10:30'!
encoding

	^ 3.! !

!CWRedcodeEmptyOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 10:34'!
fromString: aString

	self shouldNotImplement.! !

!CWRedcodeEmptyOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 11:38'!
symbol

	^ #''.! !

!CWRedcodeEmptyOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 11:38'!
valueRegex

	^ ''.! !

!CWRedcodeEmptyOperand methodsFor: 'initialize-release' stamp: 'as 4/18/2007 10:35'!
initialize

	value _ 0.! !

CWRedcodeOperand subclass: #CWRedcodeImmediateOperand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeImmediateOperand commentStamp: 'as 4/17/2007 01:30' prior: 0!
String representation: #<number>. The operand is <number>.!

!CWRedcodeImmediateOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 10:29'!
encoding

	^ 0.! !

!CWRedcodeImmediateOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 21:57'!
fromString: aString

	^ self new
		value: (aString copyFrom: 2 to: aString size) asInteger;
		yourself.! !

!CWRedcodeImmediateOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 11:37'!
symbol

	^ #'#'.! !

CWRedcodeOperand subclass: #CWRedcodeIndirectOperand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeIndirectOperand commentStamp: 'as 4/17/2007 01:33' prior: 0!
String representation: @<number>. Like a relative operand but the resulting operand is interpreted as address where the real operand resides.!

!CWRedcodeIndirectOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 10:30'!
encoding

	^ 2.! !

!CWRedcodeIndirectOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 23:29'!
fromString: aString

	^ self new
		value: (aString copyFrom: 2 to: aString size) asInteger;
		yourself.! !

!CWRedcodeIndirectOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 11:37'!
symbol

	^ #@.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 10:20'!
allOperands

	"A set of operands allowed in this language."
	
	^ Set new
		add: CWRedcodeImmediateOperand;
		add: CWRedcodeRelativeOperand;
		add: CWRedcodeIndirectOperand;
		add: CWRedcodeEmptyOperand;
		yourself.! !

!CWRedcodeOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 10:29'!
encoding

	"All operands must be sequentially numbered with an integer for integer encoding."

	^ self subclassResponsibility.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 10:47'!
fromString: aString

	aString ifEmpty: [ CWRedcodeSyntaxException signal: 'Operand is empty'. ].
	self allOperands do: [
		:class |
		(aString matchesRegex: class valueRegex)
			ifTrue: [ ^ class fromString: aString. ].
	].
	CWRedcodeSyntaxException signal: '"', aString, '" is not a valid operand'.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/17/2007 18:26'!
fromString: aString max: anInteger

	^ (self fromString: aString)
		max: anInteger;
		yourself.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 11:34'!
valueRegex

	"Should return a regular expression as documented in RxParser that
	 is used to verify the string value before initializing an instance from."

	^ self symbol asString, '-?[0-9]+'.! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/17/2007 19:27'!
allOperands

	^ self class allOperands.! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/17/2007 18:20'!
asInteger

	^ self encoding +
		value * self valueRadix.! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/18/2007 11:40'!
asString

	^ self symbol asString, value asString.! !

!CWRedcodeOperand methodsFor: 'defaults' stamp: 'as 4/17/2007 18:25'!
defaultMax

	^ 2 raisedTo: 64.! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/18/2007 10:29'!
encoding

	^ self class encoding.! !

!CWRedcodeOperand methodsFor: 'accessing' stamp: 'as 4/17/2007 18:22'!
max

	^ max ifNil: [ max _ self defaultMax. ].! !

!CWRedcodeOperand methodsFor: 'accessing' stamp: 'as 4/17/2007 18:33'!
max: anInteger

	max _ anInteger.
	value ifNotNil: [ self value: value. ].! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/17/2007 19:26'!
radix

	^ self valueRadix * (2 raisedTo: (self max log: 2) ceiling).! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/18/2007 11:40'!
symbol

	^ self class symbol.! !

!CWRedcodeOperand methodsFor: 'accessing' stamp: 'as 4/16/2007 17:07'!
value

	^ value.! !

!CWRedcodeOperand methodsFor: 'accessing' stamp: 'as 4/17/2007 18:24'!
value: anInteger

	value _ anInteger \\ self max.! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/17/2007 19:24'!
valueRadix

	^ 2 raisedTo: (self allOperands size log: 2) ceiling.! !

CWRedcodeOperand subclass: #CWRedcodeRelativeOperand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeRelativeOperand commentStamp: 'as 4/17/2007 18:37' prior: 0!
String representation: <number>. The operand is the value at the address that is build from the value of the location plus the offset <number>.!

!CWRedcodeRelativeOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 10:30'!
encoding

	^ 1.! !

!CWRedcodeRelativeOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 23:06'!
fromString: aString

	^ self new
		value: aString asInteger;
		yourself.! !

!CWRedcodeRelativeOperand class methodsFor: 'converting' stamp: 'as 4/18/2007 11:36'!
symbol

	^ #''.! !

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

TestCase subclass: #CWRedcodeInstructionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode-Tests'!

!CWRedcodeInstructionTest commentStamp: 'as 4/18/2007 10:27' prior: 0!
Test Redcode instructions.!

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
	category: 'CoreWar-Redcode-Tests'!

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
