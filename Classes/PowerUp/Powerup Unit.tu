unit
class StandardPowerUpsUnit
    export setMaxPowerUps, initializePowerUp, sameAnglePowerUp, drawPowerUps, stopAllPowerUps, setWalls,
	setAngleX, setAngleY, getAngleX, getAngleY, angleNormalize, setCharX, setCharY, setCharacterParam,
	setIsCharDead, getIsCharDead, charCenterX, charCenterY, setFPSMultiplier, PowerUp, BombUp, LifeUp,
	setPowerUp, setBombUp, setLifeUp, powerBoolean, setPowerBoolean
    %%%%%%%%% PowerUpType Variables %%%%%%%%%
    % 100 different types of powerups %
    % 1st variable is the picture %
    % 2nd variable used store its powerup number %
    % Use Syntax(1,PowerUp(i)) for making your life easier %
    var PowerUpTypes : array 1 .. 5 of int
    var PowerUpTypeCaptureRadius : array 1 .. 5 of real
    var PowerUpTypeCenter : array 1 .. 5 of real
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% VARIABLES %%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% PowerUps %%%%%    %%%%
    % Life PowerUps %
    PowerUpTypes (1) := Pic.FileNew ("Images/PowerUps/1UP.bmp")
    PowerUpTypeCaptureRadius (1) := 40
    PowerUpTypeCenter (1) := 8.5
    Pic.SetTransparentColour (PowerUpTypes (1), brightgreen)
    % Big PowerUps %
    PowerUpTypes (2) := Pic.FileNew ("Images/PowerUps/BigPowerUp.bmp")
    PowerUpTypeCaptureRadius (2) := 40
    PowerUpTypeCenter (2) := 8.5
    Pic.SetTransparentColour (PowerUpTypes (2), brightgreen)
    % Bomb PowerUps %
    PowerUpTypes (3) := Pic.FileNew ("Images/PowerUps/Bomb.bmp")
    PowerUpTypeCaptureRadius (3) := 40
    PowerUpTypeCenter (3) := 8.5
    Pic.SetTransparentColour (PowerUpTypes (3), brightgreen)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MAX PowerUps %
    PowerUpTypes (4) := Pic.FileNew ("Images/PowerUps/MAXPowerUp.bmp")
    PowerUpTypeCaptureRadius (4) := 40
    PowerUpTypeCenter (4) := 8.5
    Pic.SetTransparentColour (PowerUpTypes (3), brightgreen)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Mini PowerUps %
    PowerUpTypes (5) := Pic.FileNew ("Images/PowerUps/MiniPower.bmp")
    PowerUpTypeCaptureRadius (5) := 40
    PowerUpTypeCenter (5) := 6.5
    Pic.SetTransparentColour (PowerUpTypes (3), brightgreen)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % WALLS!!! %
    % 70 is the largest powerup size so far %
    var leftWall : int := 0 - 70
    var rightWall : int := 800 + 70
    var topWall : int := 600 + 70
    var bottomWall : int := 0 - 70

    %%%%%% Parameters used when a powerup is fired %%%%%%
    % Have a maximum of 1000 Blue PowerUps...not that I will use it all up %
    % Max PowerUps %
    var maxPowerUps : int := 1000
    % PowerUp information %
    var PowerUps : array 1 .. maxPowerUps of int
    % Speed of the powerup     and a counter to make it happen %
    % Was velocity a scalar or magnitude? I forget %
    % *Looks up 2 lines* Oh yeah, it was a scalar, it's speed with a DIRECTION %
    % Increases the x and y of a powerup in such a way it creates a direction/angle %
    var velocity : array 1 .. 2, 1 .. maxPowerUps of real
    var vCounter : array 1 .. 2, 1 .. maxPowerUps of real
    % Where the powerup is %
    var powerupPositions : array 1 .. 2, 1 .. maxPowerUps of real
    % Which powerups are drawn %
    var powerupBoolean : array 1 .. maxPowerUps of boolean
    for i : 1 .. maxPowerUps
	powerupBoolean (i) := false
    end for
    % How many powerups are there %
    var powerupCounter : int := 0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    var FPSMultiplier : real := 1
    proc setFPSMultiplier (value : real)
	FPSMultiplier := value
    end setFPSMultiplier

    var PowerUp : int := 0

    var BombUp : int := 0

    var LifeUp : int := 0

    var powerBoolean : boolean := false

    %%%%%%%%%%%%%%%%%%%%%%
    % Character Funtions %
    %%%%%%%%%%%%%%%%%%%%%%
    % You only need to know where the character is, and if the powerup killed it %
    % Must be updated every frame %
    var charPosX, charPosY : real
    var charCenterX, charCenterY, charRad : real
    var isCharDead : boolean

    proc setCharX (posX : real)
	charPosX := posX
    end setCharX

    proc setCharY (posY : real)
	charPosY := posY
    end setCharY

    proc setCharacterParam (chCenterX, chCenterY, chRad : real)
	charCenterX := chCenterX
	charCenterY := chCenterY
	charRad := chRad
    end setCharacterParam

    proc setIsCharDead (isDead : boolean)
	isCharDead := isDead
    end setIsCharDead

    fcn getIsCharDead : boolean
	result isCharDead
    end getIsCharDead


    %%%%%%%%%%%%%%%%%%%%%%%
    % Get angle functions %
    %%%%%%%%%%%%%%%%%%%%%%%
    var angleX, angleY, angleMag : real := 0

    proc setAngleX (X : real)
	angleX := X
    end setAngleX

    fcn getAngleX : real
	result angleX
    end getAngleX

    proc setAngleY (Y : real)
	angleY := Y
    end setAngleY

    fcn getAngleY : real
	result angleY
    end getAngleY

    fcn angleMagnitude () : real
	result sqrt (angleX ** 2 + angleY ** 2)
    end angleMagnitude

    proc angleNormalize ()
	angleMag := angleMagnitude ()
	if getAngleX () not= angleMag and getAngleY () not= angleMag then
	    angleX := angleX / angleMag
	    angleY := angleY / angleMag
	end if
    end angleNormalize
    %%%%%%%%%%%%%%%%%%%%
    % PowerUp functions %
    %%%%%%%%%%%%%%%%%%%%
    proc setMaxPowerUps (number : int)
	maxPowerUps := number
    end setMaxPowerUps

    proc setPowerBoolean (state : boolean)
	powerBoolean := state
    end setPowerBoolean

    proc setPowerUp (value : int)
	PowerUp := value
    end setPowerUp

    proc setBombUp (value : int)
	BombUp := value
    end setBombUp

    proc setLifeUp (value : int)
	LifeUp := value
    end setLifeUp

    proc setWalls (left, right, up, down : int)
	leftWall := left - 70
	rightWall := right + 70
	topWall := up + 70
	bottomWall := down - 70
    end setWalls

    fcn getArrayPosition : int
	result powerupCounter + 1
    end getArrayPosition

    fcn getPowerUpx (arrayPos : int) : int
	result round (powerupPositions (1, arrayPos) + vCounter (1, arrayPos))
    end getPowerUpx

    fcn getPowerUpy (arrayPos : int) : int
	result round (powerupPositions (2, arrayPos) + vCounter (2, arrayPos))
    end getPowerUpy

    % Deletes all powerups %
    proc stopAllPowerUps
	for i : 1 .. maxPowerUps
	    if powerupBoolean (i) = true then
		powerupBoolean (i) := false
	    end if
	end for
    end stopAllPowerUps

    % To set the velocity, the vCounter will be reset for the velocity to work %
    proc setVelocity (speedX, speedY : real, arrayPos : int)
	velocity (1, arrayPos) := speedX * FPSMultiplier
	velocity (2, arrayPos) := speedY * FPSMultiplier
	vCounter (1, arrayPos) := 0
	vCounter (2, arrayPos) := 0
    end setVelocity

    % To sort powerup information when a powerup is erased %
    % Trying to make this game faster... %
    % ...at the cost of flashing powerups whenever this procedure runs %
    % REMEMBER BULLET COUNTER HAS BEEN DECREASED, BULLETCOUNTER + 1 IS A MUST! %
    proc sortPowerUpInfo (arrayPos : int)

	% If there is still another powerup after this array %
	if powerupBoolean (arrayPos + 1) = true then

	    % Assuming powerupBoolean was set to false %
	    powerupBoolean (arrayPos) := true
	    powerupBoolean (powerupCounter + 1) := false
	    powerupPositions (1, arrayPos) := powerupPositions (1, powerupCounter + 1)
	    powerupPositions (2, arrayPos) := powerupPositions (2, powerupCounter + 1)
	    velocity (1, arrayPos) := velocity (1, powerupCounter + 1)
	    velocity (2, arrayPos) := velocity (2, powerupCounter + 1)
	    vCounter (1, arrayPos) := vCounter (1, powerupCounter + 1)
	    vCounter (2, arrayPos) := vCounter (2, powerupCounter + 1)
	    PowerUps (arrayPos) := PowerUps (powerupCounter + 1)

	    % Stops flickering with this chunk of code %
	    var netPosition : array 1 .. 2 of int
	    netPosition (1) := round (powerupPositions (1, arrayPos) + vCounter (1, arrayPos))
	    netPosition (2) := round (powerupPositions (2, arrayPos) + vCounter (2, arrayPos))
	    % PowerUpTypes(PowerUps(i)) contain which powerup type it is, PowerUps(i) show the type of powerup in the array %
	    Pic.Draw (PowerUpTypes (PowerUps (arrayPos)), netPosition (1), netPosition (2), picMerge)
	    vCounter (1, arrayPos) += velocity (1, arrayPos)
	    vCounter (2, arrayPos) += velocity (2, arrayPos)
	else
	    % Do nothing %
	end if
    end sortPowerUpInfo

    % Stop the powerup from drawing %
    proc powerupErase (arrayPos : int)
	powerupBoolean (arrayPos) := false
	powerupCounter -= 1
	% This was not used with stop all powerups because we don't know whether the powerup killed the player yet %
	% You can leave the work to the procedure below %
	sortPowerUpInfo (arrayPos)
    end powerupErase

    % Did the powerup hit the character %
    proc didPowerUpHitChar (centerPowerUpPositionX, centerPowerUpPositionY : real, arrayPos : int)
	% If the powerup hits the character, kill it and delete the powerups %
	if sqrt (((charPosX + charCenterX - centerPowerUpPositionX) ** 2) + ((charPosY + charCenterY - centerPowerUpPositionY) ** 2)) <= PowerUpTypeCaptureRadius (PowerUps (arrayPos)) + charRad then
	    case (PowerUps (arrayPos)) of
		label 1 :
		    LifeUp += 1
		label 2 :
		    PowerUp += 10
		label 3 :
		    BombUp += 1
		label 4 :
		    PowerUp += 128
		label 5 :
		    PowerUp += 1
		label :
	    end case
	    powerBoolean := true
	    powerupErase (arrayPos)
	end if
    end didPowerUpHitChar

    % To initialize a powerup to be ready for drawing %
    proc initializePowerUp (speedX, speedY : real, setPositionX, setPositionY, powerupType : int)
	if powerupCounter < maxPowerUps then
	    var arrayPos : int := getArrayPosition
	    setVelocity (speedX, speedY, arrayPos)
	    powerupPositions (1, arrayPos) := setPositionX - PowerUpTypeCenter (powerupType)
	    powerupPositions (2, arrayPos) := setPositionY - PowerUpTypeCenter (powerupType)
	    PowerUps (arrayPos) := powerupType
	    powerupCounter += 1
	    powerupBoolean (arrayPos) := true
	end if
    end initializePowerUp

    % Where the powerup goes to, where it begins to be drawn, and its type %
    proc sameAnglePowerUp (endX, endY, speed : real, startX, startY, powerupType : int)
	setAngleX (endX - (startX + PowerUpTypeCenter (powerupType)))
	setAngleY (endY - (startY + PowerUpTypeCenter (powerupType)))
	angleNormalize
	initializePowerUp (getAngleX * speed, getAngleY * speed, startX, startY, powerupType)
    end sameAnglePowerUp

    % Draws powerups, updates them, and analyzes them %
    proc drawPowerUps
	% Variable used for an attempt to speed up processing %
	var netPosition : array 1 .. 2 of int

	% Precalculations to make the powerup kill %
	var charPositionX : real := charPosX + charCenterX
	var charPositionY : real := charPosY + charCenterY
	var centerPowerUpPositionX : real
	var centerPowerUpPositionY : real

	for i : 1 .. maxPowerUps
	    if powerupBoolean (i) = true then
		% To stop when you get to the end of the powerup boolean %
		exit when i >= powerupCounter + 1

		netPosition (1) := round (powerupPositions (1, i) + vCounter (1, i))
		netPosition (2) := round (powerupPositions (2, i) + vCounter (2, i))

		% To calculate the center of powerups and the character %
		centerPowerUpPositionX := netPosition (1) + PowerUpTypeCenter (PowerUps (i))
		centerPowerUpPositionY := netPosition (2) + PowerUpTypeCenter (PowerUps (i))

		% PowerUpTypes(PowerUps(i)) contain which powerup type it is, PowerUps(i) show the type of powerup in the array %
		Pic.Draw (PowerUpTypes (PowerUps (i)), netPosition (1), netPosition (2), picMerge)
		vCounter (1, i) += velocity (1, i)
		vCounter (2, i) += velocity (2, i)

		% If the powerup goes off screen %
		if netPosition (1) < leftWall or netPosition (1) > rightWall then
		    powerupErase (i)
		elsif netPosition (2) < bottomWall or netPosition (2) > topWall then
		    powerupErase (i)
		end if

		didPowerUpHitChar (centerPowerUpPositionX, centerPowerUpPositionY, i)

	    end if
	end for

    end drawPowerUps

end StandardPowerUpsUnit
