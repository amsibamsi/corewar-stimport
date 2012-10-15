SystemOrganization addCategory: #CoreWar!
SystemOrganization addCategory: #'CoreWar-Redcode'!
SystemOrganization addCategory: #'CoreWar-Redcode-Tests'!
SystemOrganization addCategory: #'CoreWar-Tests'!

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

!CWMarsTest methodsFor: 'testing' stamp: 'as 4/19/2007 17:13'!
testCoreSize
	
	self assert: (CWMars withCoreSize: 1024) coreSize = 1024.! !

TestCase subclass: #CWRedcodeInstructionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode-Tests'!

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

TestCase subclass: #CWRedcodeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode-Tests'!

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

Object subclass: #CWMars
	instanceVariableNames: 'core programs pc counters size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar'!

!CWMars commentStamp: 'as 4/16/2007 11:51' prior: 0!
Memory Array Redcode Simulator - the Core War interpreter.!

!CWMars class methodsFor: 'core' stamp: 'as 4/19/2007 17:01'!
maxValue

	^ self valueSize - 1.! !

!CWMars class methodsFor: 'core' stamp: 'as 4/19/2007 17:01'!
minValue

	^ 0.! !

!CWMars class methodsFor: 'limits' stamp: 'as 4/18/2007 17:11'!
valueBits

	^ CWRedcodeInstruction encodingBits.! !

!CWMars class methodsFor: 'limits' stamp: 'as 4/18/2007 23:14'!
valueSize

	^ 2 raisedTo: self valueBits.! !

!CWMars class methodsFor: 'instance creation' stamp: 'as 4/16/2007 11:52'!
withCoreSize: anInteger

	^ self new
		size: anInteger;
		yourself.! !

!CWMars methodsFor: 'public' stamp: 'as 4/17/2007 15:52'!
addProgram: aCWRedcode

	self programs add: aCWRedcode.! !

!CWMars methodsFor: 'private' stamp: 'as 4/19/2007 17:19'!
core

	^ core ifNil: [ core _ Array new: self size. ].! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/16/2007 11:28'!
coreSize

	^ self core size.! !

!CWMars methodsFor: 'defaults' stamp: 'as 4/15/2007 21:19'!
defaultSize

	^ 4096.! !

!CWMars methodsFor: 'defaults' stamp: 'as 4/18/2007 17:09'!
defaultValue

	"The initial value at any address in the core."
	
	^ 0.! !

!CWMars methodsFor: 'core' stamp: 'as 4/18/2007 23:09'!
internalAddress: anInteger

	"Internally the core is an array with indices from 1 to <size>.
	 From outside addresses go normally from 0 to size-1.
	 The address space is interpreted as ring, so out of bounds
	 addresses are not possible."
	
	| address |
	
	"Divide modulo for addresses that are out of bounds."
	address _ anInteger \\ self coreSize.
	
	"Convert negative addresses."
	address negative ifTrue: [ address _ self coreSize - address. ].
	
	"Internal addressing starts with 1, not 0."
	address + 1.
	
	^ address.! !

!CWMars methodsFor: 'core' stamp: 'as 4/18/2007 23:12'!
internalValue: anInteger

	| value |
	anInteger > self maxValue ifTrue: [
		value _ self maxValue.
	] ifFalse: [
		anInteger < self minValue ifTrue: [
			value_ self minValue.
		] ifFalse: [
			value _ anInteger.
		].
	].
	^ value.! !

!CWMars methodsFor: 'core' stamp: 'as 4/18/2007 23:09'!
maxValue

	^ self class maxValue.! !

!CWMars methodsFor: 'core' stamp: 'as 4/18/2007 23:09'!
minValue

	^ self class minValue.! !

!CWMars methodsFor: 'accessing' stamp: 'as 4/17/2007 11:53'!
programs

	^ programs ifNil: [ programs _ OrderedCollection new. ].! !

!CWMars methodsFor: 'core' stamp: 'as 4/18/2007 17:09'!
read: integerAddress

	"Read value from the specified address."
	
	| address value |
	address _ self internalAddress: integerAddress.
	value _ (self core at: address) ifNil: [ self core at: address put: self defaultValue. ].
	^ value.! !

!CWMars methodsFor: 'private' stamp: 'as 4/19/2007 17:15'!
size

	^ size ifNil: [ size _ self defaultSize. ].! !

!CWMars methodsFor: 'private' stamp: 'as 4/15/2007 21:50'!
size: anInteger

	size _ anInteger.! !

!CWMars methodsFor: 'core' stamp: 'as 4/18/2007 17:12'!
write: anInteger at: integerAddress

	"Write value at the specified address."
	
	self core at: (self internalAddress: integerAddress) put: (self internalValue: anInteger).
	^ anInteger.! !

Object subclass: #CWRedcode
	instanceVariableNames: 'lines'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcode commentStamp: 'as 4/18/2007 23:15' prior: 0!
A Core War program in Redcode language.
This is a object representation of a Redcode program. It can either be build from source code (string) or encoded binary code (integers).!

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

!CWRedcodeDataInstruction class methodsFor: 'private' stamp: 'as 4/19/2007 16:02'!
operand2Types

	^ Set new add: CWRedcodeEmptyOperand; yourself.! !

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

!CWRedcodeDecrementJumpZeroInstruction class methodsFor: 'private' stamp: 'as 4/19/2007 16:07'!
operand2Types

	^ CWRedcodeOperand relativeOperands.! !

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

!CWRedcodeInstruction class methodsFor: 'private' stamp: 'as 4/19/2007 15:22'!
operand1Types

	"Allowed operand types for operand 1."

	^ CWRedcodeOperand allOperands.! !

!CWRedcodeInstruction class methodsFor: 'converting' stamp: 'as 4/19/2007 13:11'!
operand2BitShift

	^ self operand1BitShift + CWRedcodeOperand encodingBits.! !

!CWRedcodeInstruction class methodsFor: 'private' stamp: 'as 4/19/2007 15:22'!
operand2Types

	"Allowed operand types of operand 2."

	^ CWRedcodeOperand allOperands.! !

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

!CWRedcodeInstruction methodsFor: 'executing' stamp: 'as 4/17/2007 11:33'!
executeOn: aCWMars

	"Execute the instruction on the MARS simulator."
	
	self subclassResponsibility.! !

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

!CWRedcodeEmptyOperand methodsFor: 'converting' stamp: 'as 4/19/2007 17:12'!
source

	^ ''.! !

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

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/18/2007 10:20'!
allOperands

	"A set of operands allowed in this language."
	
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

!CWRedcodeOperand class methodsFor: 'instance creation' stamp: 'as 4/19/2007 15:32'!
relativeOperands

	"A set of operands allowed in this language."
	
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

CWRedcodeException subclass: #CWRedcodeSyntaxException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeSyntaxException commentStamp: 'as 4/17/2007 13:50' prior: 0!
There was an error when trying to compile a Redcode program from source code.!
