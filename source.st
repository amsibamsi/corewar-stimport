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

!CWMars methodsFor: 'public' stamp: 'as 4/16/2007 01:25'!
addProgram: aCWProgram

	self programs add: aCWProgram.! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/17/2007 11:53'!
core

	^ core ifNil: [ core _ Array with: self size. ].! !

!CWMars methodsFor: 'public' stamp: 'as 4/16/2007 11:28'!
coreSize

	^ self core size.! !

!CWMars methodsFor: 'defaults' stamp: 'as 4/15/2007 21:19'!
defaultSize

	^ 4096.! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/17/2007 11:53'!
programs

	^ programs ifNil: [ programs _ OrderedCollection new. ].! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/17/2007 11:54'!
size

	^ size ifNil: [ size _ self defaultSize. ].! !

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

!CWProgram class methodsFor: 'instance creation' stamp: 'as 4/17/2007 11:49'!
fromString: aString

	"Initialize the program from source code (parse/compile)."

	self subclassResponsibility.! !

!CWProgram methodsFor: 'public' stamp: 'as 4/17/2007 11:41'!
addLine: aCWProgramInstruction

	self lines add: aCWProgramInstruction.! !

!CWProgram methodsFor: 'converting' stamp: 'as 4/17/2007 12:54'!
asString

	"Return the source code of the program."
	
	self subclassResponsibility.! !

!CWProgram methodsFor: 'accessing' stamp: 'as 4/17/2007 11:52'!
lines

	^ lines ifNil: [ lines _ OrderedCollection new. ].! !

CWProgram subclass: #CWRedcode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcode commentStamp: 'as 4/17/2007 01:11' prior: 0!
A Core War program in Redcode language.!

!CWRedcode class methodsFor: 'instance creation' stamp: 'as 4/17/2007 13:15'!
fromString: aString

	| program source |
	program _ self new.
	source _ aString withSeparatorsCompacted.
	source linesDo: [
		:line |
		program addLine: (CWRedcodeInstruction fromString: line).
	].
	^ program.! !

!CWRedcode methodsFor: 'converting' stamp: 'as 4/17/2007 12:55'!
asString

	self notYetImplemented.! !

Object subclass: #CWProgramInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar'!

!CWProgramInstruction commentStamp: 'as 4/17/2007 11:43' prior: 0!
A single instruction of a program. The string representation is usually one line in the form of "<instruction> <operand> ...".!

!CWProgramInstruction methodsFor: 'converting' stamp: 'as 4/17/2007 11:46'!
asInteger

	"Return an integer encoding of this instruction."
	
	self subclassResponsibility.! !

!CWProgramInstruction methodsFor: 'executing' stamp: 'as 4/17/2007 11:45'!
executeOn: aCWMars

	"Execute the instruction on the MARS simulator."
	
	self subclassResponsibility.! !

CWProgramInstruction subclass: #CWRedcodeInstruction
	instanceVariableNames: 'operand1 operand2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeInstruction commentStamp: 'as 4/17/2007 11:44' prior: 0!
A Redcode command in the form of "<instruction> <operand1> [<operand2>]".!

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

!CWRedcodeAddInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 08:26'!
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

!CWRedcodeCompareInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 11:08'!
symbol

	^ #CMP.! !

CWRedcodeInstruction subclass: #CWRedcodeDataInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeDataInstruction commentStamp: 'as 4/17/2007 08:17' prior: 0!
DAT B - Initialize location to value B.!

!CWRedcodeDataInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:28'!
encoding

	^ 0.! !

!CWRedcodeDataInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 08:22'!
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

!CWRedcodeDecrementJumpZeroInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 11:06'!
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

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 12:51'!
fromString: aString

	| instruction tokens |
	instruction _ self new.
	tokens _ self tokensFor: aString.
	instruction _ self instructionForString: (tokens at: 1).
	instruction operand1: (CWRedcodeOperand fromString: (tokens at: 2)).
	instruction operand2: (CWRedcodeOperand fromString: (tokens at: 3)).
	^ instruction.! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 14:12'!
instructionForString: aString

	self allInstructions do: [
		:class |
		class symbol = aString asSymbol ifTrue: [ ^ class new. ].
	].
	CWRedcodeSyntaxException signal: '"', aString, '" is not a valid instruction'.! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/16/2007 16:31'!
symbol

	"The mnemonic symbol used in Redcode source for this instruction
	 (case sensitive)."

	self subclassResponsibility.! !

!CWRedcodeInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 12:51'!
tokensFor: aString

	| tokens stream |
	tokens _ OrderedCollection new.
	"Append a space, each token must be terminated with a space."
	stream _ ReadStream on: aString, ' '.
	3 timesRepeat: [
		tokens add: (stream nextDelimited: ' ' asCharacter).
	].
	^ tokens.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/16/2007 17:07'!
asInteger

	self notYetImplemented.! !

!CWRedcodeInstruction methodsFor: 'converting' stamp: 'as 4/17/2007 11:25'!
encoding

	^ self class encoding.! !

!CWRedcodeInstruction methodsFor: 'executing' stamp: 'as 4/17/2007 11:33'!
executeOn: aCWMars

	"Execute the instruction on the MARS simulator."
	
	self subclassResponsibility.! !

!CWRedcodeInstruction methodsFor: 'accessing' stamp: 'as 4/16/2007 16:10'!
operand1: aCWRedcodeOperand

	operand1 _ aCWRedcodeOperand.! !

!CWRedcodeInstruction methodsFor: 'accessing' stamp: 'as 4/16/2007 16:10'!
operand2: aCWRedcodeOperand

	operand2 _ aCWRedcodeOperand.! !

CWRedcodeInstruction subclass: #CWRedcodeJumpInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeJumpInstruction commentStamp: 'as 4/17/2007 08:34' prior: 0!
JMP B - Jump to location B.!

!CWRedcodeJumpInstruction class methodsFor: 'converting' stamp: 'as 4/17/2007 11:29'!
encoding

	^ 4.! !

!CWRedcodeJumpInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 11:23'!
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

!CWRedcodeJumpZeroInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 11:04'!
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

!CWRedcodeMoveInstruction class methodsFor: 'instance creation' stamp: 'as 4/16/2007 16:43'!
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

!CWRedcodeSubtractInstruction class methodsFor: 'instance creation' stamp: 'as 4/17/2007 08:28'!
symbol

	^ #SUB.! !

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

!CWRedcodeImmediateOperand commentStamp: 'as 4/17/2007 01:30' prior: 0!
String representation: #<number>. The operand is <number>.!

!CWRedcodeImmediateOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 21:57'!
fromString: aString

	^ self new
		value: (aString copyFrom: 2 to: aString size) asInteger;
		yourself.! !

!CWRedcodeImmediateOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 21:15'!
startCharacters

	^ '#'.! !

!CWRedcodeImmediateOperand methodsFor: 'converting' stamp: 'as 4/17/2007 08:11'!
encoding

	^ 0.! !

CWRedcodeOperand subclass: #CWRedcodeIndirectOperand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeIndirectOperand commentStamp: 'as 4/17/2007 01:33' prior: 0!
String representation: @<number>. Like a relative operand but the resulting operand is interpreted as address where the real operand resides.!

!CWRedcodeIndirectOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 23:29'!
fromString: aString

	^ self new
		value: (aString copyFrom: 2 to: aString size) asInteger;
		yourself.! !

!CWRedcodeIndirectOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 23:22'!
startCharacters

	^ '@'.! !

!CWRedcodeIndirectOperand methodsFor: 'converting' stamp: 'as 4/17/2007 08:12'!
encoding

	^ 2.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/17/2007 11:18'!
allOperands

	"A set of operands allowed in this language."
	
	^ Set new
		add: CWRedcodeImmediateOperand;
		add: CWRedcodeRelativeOperand;
		add: CWRedcodeIndirectOperand;
		yourself.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/17/2007 14:12'!
fromString: aString

	aString ifEmpty: [ CWRedcodeSyntaxException signal: 'Empty operand'. ].
	self allOperands do: [
		:class |
		(class startCharacters includes: aString first)
			ifTrue: [ ^ class fromString: aString. ].
	].
	CWRedcodeSyntaxException signal: '"', aString, '" is not a valid operand'.! !

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 21:13'!
startCharacters

	"Should return a string whose characters can all be used as
	 starting character of the value to initialize an instance from."

	self subclassResponsibility.! !

!CWRedcodeOperand methodsFor: 'converting' stamp: 'as 4/17/2007 08:16'!
encoding

	"All operands must be sequentially numbered with an integer for integer encoding."

	^ self subclassResponsibility.! !

!CWRedcodeOperand methodsFor: 'accessing' stamp: 'as 4/16/2007 17:07'!
value

	^ value.! !

!CWRedcodeOperand methodsFor: 'accessing' stamp: 'as 4/16/2007 17:07'!
value: anInteger

	value _ anInteger.! !

CWRedcodeOperand subclass: #CWRedcodeRelativeOperand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeRelativeOperand commentStamp: 'as 4/17/2007 01:29' prior: 0!
String representation: <number>. The operand is the value at the address build from the program counter plus the offset <number>.!

!CWRedcodeRelativeOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 23:06'!
fromString: aString

	^ self new
		value: aString asInteger;
		yourself.! !

!CWRedcodeRelativeOperand class methodsFor: 'instance creation' stamp: 'as 4/16/2007 23:05'!
startCharacters

	^ '-1234567890'.! !

!CWRedcodeRelativeOperand methodsFor: 'converting' stamp: 'as 4/17/2007 08:11'!
encoding

	^ 1.! !

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

!CWRedcodeInstructionTest commentStamp: 'as 4/17/2007 08:30' prior: 0!
Test instruction encoding.!

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
