SystemOrganization addCategory: #'CoreWar-Redcode-Tests'!
SystemOrganization addCategory: #'CoreWar-Redcode'!
SystemOrganization addCategory: #'CoreWar-Tests'!
SystemOrganization addCategory: #CoreWar!

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

!CWProgram class methodsFor: 'instance creation' stamp: 'as 4/15/2007 22:42'!
fromString: aString

	self notYetImplemented.! !

CWProgram subclass: #CWRedcode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcode commentStamp: 'as 4/16/2007 01:17' prior: 0!
A Redcode program.!

Object subclass: #CWProgramNode
	instanceVariableNames: 'childs'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar'!

!CWProgramNode commentStamp: 'as 4/16/2007 11:51' prior: 0!
A node in the object representation of a Core War program.!

!CWProgramNode methodsFor: 'executing' stamp: 'as 4/16/2007 01:13'!
executeOn: aCWMars! !

!CWProgramNode methodsFor: 'executing' stamp: 'as 4/15/2007 23:26'!
value! !

CWProgramNode subclass: #CWRedcodeNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CoreWar-Redcode'!

!CWRedcodeNode commentStamp: 'as 4/15/2007 23:03' prior: 0!
A Redcode program node.!

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
