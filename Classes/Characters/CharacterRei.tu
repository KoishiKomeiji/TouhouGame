% ***NOTE: getCharX/Y does not get the center of the character %
unit
class characterRei
    export setCharX, setCharY, getCharX, getCharY, getDead, setLives, getLives, setPower, getPower, setBombs, getBombs,
	setKeyShift, setFPS, setFPSInterval, getFPS, getFPSInterval, setInvisTime, drawRei, charIsDead, charIsLive,
	reiLeft, reiRight, reiUp, reiDown, setFPSMultiplier, setInitialBombs

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Variables %
    % For user input %
    var key : array char of boolean
    % Where the character is %
    var mainCharx, mainChary : real := -100
    % How many pixels the character moves divided by a sensitivity %
    var characterStepMain : real := 4
    var characterStepShift : real := 2
    % To check whether character is dead %
    var isDead : boolean := false
    % A counter to check how long has passed since death %
    var deadCounter : int := 0
    % Set how many lives the character has %
    var Lives : int := 0
    % Set how much power the character has %
    var Power : int := 0
    % Set how much bombs the character has %
    var Bombs : int := 0
    % Set how much bombs the character has after death %
    var initialBombs : int := 0
    % To check if player pressed the shift key %
    var keyShift : boolean := false
    % Time of invincibility after death %
    var invisTime : int
    % Frames per second %
    var FPS : int
    % Milliseconds to achieve FPS %
    var FPSInterval : int
    % To make the game work for slow computers %
    var FPSMultiplier : real := 1
    proc setFPSMultiplier (value : real)
	FPSMultiplier := value
	characterStepMain := characterStepMain * value
	characterStepShift := characterStepShift * value
    end setFPSMultiplier
    % Pictures %
    % Reimu %
    var mainChar := Pic.FileNew ("Images/r sprites/r1.bmp")
    Pic.SetTransparentColour (mainChar, brightgreen)
    var mainCharSHIFT := Pic.FileNew ("Images/r sprites/r1 SHIFT.bmp")
    Pic.SetTransparentColour (mainCharSHIFT, brightgreen)
    % Dead Reimu %
    var mainCharDead := Pic.FileNew ("Images/r sprites dead/r1.bmp")
    Pic.SetTransparentColour (mainCharDead, brightgreen)
    %%%%%%%%%
    proc setCharX (chX : int)
	mainCharx := chX
    end setCharX

    proc setCharY (chY : int)
	mainChary := chY
    end setCharY

    fcn getCharX : int
	result round (mainCharx)
    end getCharX

    fcn getCharY : int
	result round (mainChary)
    end getCharY

    % Returns whether the character is dead or not %
    fcn getDead : boolean
	result isDead
    end getDead

    % Sets how many lives the character has %
    proc setLives (value : int)
	Lives := value
    end setLives

    fcn getLives : int
	result Lives
    end getLives

    % Sets how many lives the character has %
    proc setPower (value : int)
	Power := value
    end setPower

    fcn getPower : int
	result Power
    end getPower

    proc setInitialBombs (value : int)
	initialBombs := value
    end setInitialBombs

    % Sets how many bombs the character has %
    proc setBombs (value : int)
	Bombs := value
    end setBombs

    fcn getBombs : int
	result Bombs
    end getBombs

    procedure setKeyShift (keyShiftValue : boolean)
	keyShift := keyShiftValue
    end setKeyShift

    procedure setFPS (FPSvalue : int)
	FPS := FPSvalue
    end setFPS

    % To be used to with the FPS %
    procedure setFPSInterval (IntervalValue : int)
	FPSInterval := IntervalValue
    end setFPSInterval

    fcn getFPS : int
	result FPS
    end getFPS

    fcn getFPSInterval : int
	result FPSInterval
    end getFPSInterval

    procedure setInvisTime (timeSeconds : int)
	invisTime := FPS * timeSeconds
    end setInvisTime

    % To draw the main character %
    procedure drawRei
	if isDead = false then
	    if keyShift = true then
		Pic.Draw (mainCharSHIFT, getCharX, getCharY, picMerge)
	    else
		Pic.Draw (mainChar, getCharX, getCharY, picMerge)
	    end if
	else
	    Pic.Draw (mainCharDead, getCharX, getCharY, picMerge)
	    if deadCounter = 1 then
		Lives -= 1
		Power := Power div 2
		if Bombs < initialBombs then
		    Bombs := initialBombs
		end if
	    end if
	    if deadCounter >= invisTime then
		deadCounter := 0
		isDead := false
	    end if
	    deadCounter += 1
	end if
    end drawRei

    % To kill character %
    procedure charIsDead
	isDead := true
    end charIsDead

    % To make character alive %
    procedure charIsLive
	isDead := false
    end charIsLive

    % To move %
    % Moves more quickly when it is main %
    % Moves more slowly when it is shift %
    procedure reiLeft
	if keyShift = false then
	    mainCharx += -characterStepMain
	else
	    mainCharx += -characterStepShift
	end if
    end reiLeft

    procedure reiRight
	if keyShift = false then
	    mainCharx += characterStepMain
	else
	    mainCharx += characterStepShift
	end if
    end reiRight

    procedure reiUp
	if keyShift = false then
	    mainChary += characterStepMain
	else
	    mainChary += characterStepShift
	end if
    end reiUp

    procedure reiDown
	if keyShift = false then
	    mainChary += -characterStepMain
	else
	    mainChary += -characterStepShift
	end if
    end reiDown

end characterRei

