unit
class StandardBulletUnit
    export setMaxBullets, initializeBullet, sameAngleBullet, drawBullets, stopAllBullets, setWalls,
	setAngleX, setAngleY, getAngleX, getAngleY, angleNormalize, setCharX, setCharY, setCharacterParam,
	setIsCharDead, getIsCharDead, charCenterX, charCenterY, setFPSMultiplier
    %%%%%%%%% BulletType Variables %%%%%%%%%
    % 100 different types of bullets %
    % 1st variable is the picture %
    % 2nd variable used store its bullet number %
    % Use Syntax(1,Bullet(i)) for making your life easier %
    var BulletTypes : array 1 .. 100 of int
    var BulletTypeKillRadius : array 1 .. 100 of real
    var BulletTypeCenter : array 1 .. 100 of real
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% VARIABLES %%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% Bullets %%%%%    %%%%
    % Blue Bullet %
    BulletTypes (1) := Pic.FileNew ("Images/Bullets/BlueBullet.bmp")
    BulletTypeKillRadius (1) := 8
    BulletTypeCenter (1) := 7.5
    Pic.SetTransparentColour (BulletTypes (1), brightgreen)
    % Red Bullet %
    BulletTypes (2) := Pic.FileNew ("Images/Bullets/RedBullet.bmp")
    BulletTypeKillRadius (2) := 8
    BulletTypeCenter (2) := 7.5
    Pic.SetTransparentColour (BulletTypes (2), brightgreen)
    % Red Bullet %
    BulletTypes (3) := Pic.FileNew ("Images/Bullets/BigRedBullet.bmp")
    BulletTypeKillRadius (3) := 18
    BulletTypeCenter (3) := 31.5
    Pic.SetTransparentColour (BulletTypes (3), brightgreen)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % WALLS!!! %
    % 31 is the largest bullet size so far %
    var leftWall : int := 0 - 31
    var rightWall : int := 800 + 31
    var topWall : int := 600 + 31
    var bottomWall : int := 0 - 31

    %%%%%% Parameters used when a bullet is fired %%%%%%
    % Have a maximum of 1000 Blue Bullets...not that I will use it all up %
    % Max Bullets %
    var maxBullets : int := 10000
    % Bullet information %
    var Bullets : array 1 .. maxBullets of int
    % Speed of the bullet     and a counter to make it happen %
    % Was velocity a scalar or magnitude? I forget %
    % *Looks up 2 lines* Oh yeah, it was a scalar, it's speed with a DIRECTION %
    % Increases the x and y of a bullet in such a way it creates a direction/angle %
    var velocity : array 1 .. 2, 1 .. maxBullets of real
    var vCounter : array 1 .. 2, 1 .. maxBullets of real
    % Where the bullet is %
    var bulletPositions : array 1 .. 2, 1 .. maxBullets of real
    % Which bullets are drawn %
    var bulletBoolean : array 1 .. maxBullets of boolean
    for i : 1 .. maxBullets
	bulletBoolean (i) := false
    end for
    % How many bullets are there %
    var bulletCounter : int := 0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    var FPSMultiplier : real := 1
    proc setFPSMultiplier (value : real)
	FPSMultiplier := value
    end setFPSMultiplier

    %%%%%%%%%%%%%%%%%%%%%%
    % Character Funtions %
    %%%%%%%%%%%%%%%%%%%%%%
    % You only need to know where the character is, and if the bullet killed it %
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
    % Bullet functions %
    %%%%%%%%%%%%%%%%%%%%
    proc setMaxBullets (number : int)
	maxBullets := number
    end setMaxBullets

    proc setWalls (left, right, up, down : int)
	leftWall := left - 31
	rightWall := right + 31
	topWall := up + 31
	bottomWall := down - 31
    end setWalls

    fcn getArrayPosition : int
	result bulletCounter + 1
    end getArrayPosition

    fcn getBulletx (arrayPos : int) : int
	result round (bulletPositions (1, arrayPos) + vCounter (1, arrayPos))
    end getBulletx

    fcn getBullety (arrayPos : int) : int
	result round (bulletPositions (2, arrayPos) + vCounter (2, arrayPos))
    end getBullety

    % Deletes all bullets %
    proc stopAllBullets
	for i : 1 .. maxBullets
	    if bulletBoolean (i) = true then
		bulletBoolean (i) := false
	    end if
	end for
    end stopAllBullets

    % To set the velocity, the vCounter will be reset for the velocity to work %
    proc setVelocity (speedX, speedY : real, arrayPos : int)
	velocity (1, arrayPos) := speedX * FPSMultiplier
	velocity (2, arrayPos) := speedY * FPSMultiplier
	vCounter (1, arrayPos) := 0
	vCounter (2, arrayPos) := 0
    end setVelocity

    % To sort bullet information when a bullet is erased %
    % Trying to make this game faster... %
    % ...at the cost of flashing bullets whenever this procedure runs %
    % REMEMBER BULLET COUNTER HAS BEEN DECREASED, BULLETCOUNTER + 1 IS A MUST! %
    proc sortBulletInfo (arrayPos : int)

	% If there is still another bullet after this array %
	if bulletBoolean (arrayPos + 1) = true then

	    % Assuming bulletBoolean was set to false %
	    bulletBoolean (arrayPos) := true
	    bulletBoolean (bulletCounter + 1) := false
	    bulletPositions (1, arrayPos) := bulletPositions (1, bulletCounter + 1)
	    bulletPositions (2, arrayPos) := bulletPositions (2, bulletCounter + 1)
	    velocity (1, arrayPos) := velocity (1, bulletCounter + 1)
	    velocity (2, arrayPos) := velocity (2, bulletCounter + 1)
	    vCounter (1, arrayPos) := vCounter (1, bulletCounter + 1)
	    vCounter (2, arrayPos) := vCounter (2, bulletCounter + 1)
	    Bullets (arrayPos) := Bullets (bulletCounter + 1)

	    % Stops flickering with this chunk of code %
	    var netPosition : array 1 .. 2 of int
	    netPosition (1) := round (bulletPositions (1, arrayPos) + vCounter (1, arrayPos))
	    netPosition (2) := round (bulletPositions (2, arrayPos) + vCounter (2, arrayPos))
	    % BulletTypes(Bullets(i)) contain which bullet type it is, Bullets(i) show the type of bullet in the array %
	    Pic.Draw (BulletTypes (Bullets (arrayPos)), netPosition (1), netPosition (2), picMerge)
	    vCounter (1, arrayPos) += velocity (1, arrayPos)
	    vCounter (2, arrayPos) += velocity (2, arrayPos)
	else
	    % Do nothing %
	end if
    end sortBulletInfo

    % Stop the bullet from drawing %
    proc bulletErase (arrayPos : int)
	bulletBoolean (arrayPos) := false
	bulletCounter -= 1
	% This was not used with stop all bullets because we don't know whether the bullet killed the player yet %
	% You can leave the work to the procedure below %
	sortBulletInfo (arrayPos)
    end bulletErase

    % Did the bullet hit the character %
    proc didBulletHitChar (centerBulletPositionX, centerBulletPositionY : real, arrayPos : int)
	% If the bullet hits the character, kill it and delete the bullets %
	if sqrt (((charPosX + charCenterX - centerBulletPositionX) ** 2) + ((charPosY + charCenterY - centerBulletPositionY) ** 2)) <= BulletTypeKillRadius (Bullets (arrayPos)) + charRad then
	    setIsCharDead (true)
	    stopAllBullets
	end if
    end didBulletHitChar

    % To initialize a bullet to be ready for drawing %
    proc initializeBullet (speedX, speedY : real, setPositionX, setPositionY, bulletType : int)
	if bulletCounter < maxBullets then
	    var arrayPos : int := getArrayPosition
	    setVelocity (speedX, speedY, arrayPos)
	    bulletPositions (1, arrayPos) := setPositionX - BulletTypeCenter (bulletType)
	    bulletPositions (2, arrayPos) := setPositionY - BulletTypeCenter (bulletType)
	    Bullets (arrayPos) := bulletType
	    bulletCounter += 1
	    bulletBoolean (arrayPos) := true
	end if
    end initializeBullet

    % Where the bullet goes to, where it begins to be drawn, and its type %
    proc sameAngleBullet (endX, endY, speed : real, startX, startY, bulletType : int)
	setAngleX (endX - (startX + BulletTypeCenter (bulletType)))
	setAngleY (endY - (startY + BulletTypeCenter (bulletType)))
	angleNormalize
	initializeBullet (getAngleX * speed, getAngleY * speed, startX, startY, bulletType)
    end sameAngleBullet

    % Draws bullets, updates them, and analyzes them %
    proc drawBullets
	if getIsCharDead = false then
	    % Variable used for an attempt to speed up processing %
	    var netPosition : array 1 .. 2 of int

	    % Precalculations to make the bullet kill %
	    var charPositionX : real := charPosX + charCenterX
	    var charPositionY : real := charPosY + charCenterY
	    var centerBulletPositionX : real
	    var centerBulletPositionY : real

	    for i : 1 .. maxBullets
		if bulletBoolean (i) = true then
		    % To stop when you get to the end of the bullet boolean %
		    exit when i >= bulletCounter + 1

		    netPosition (1) := round (bulletPositions (1, i) + vCounter (1, i))
		    netPosition (2) := round (bulletPositions (2, i) + vCounter (2, i))

		    % To calculate the center of bullets and the character %
		    centerBulletPositionX := netPosition (1) + BulletTypeCenter (Bullets (i))
		    centerBulletPositionY := netPosition (2) + BulletTypeCenter (Bullets (i))

		    % BulletTypes(Bullets(i)) contain which bullet type it is, Bullets(i) show the type of bullet in the array %
		    Pic.Draw (BulletTypes (Bullets (i)), netPosition (1), netPosition (2), picMerge)
		    vCounter (1, i) += velocity (1, i)
		    vCounter (2, i) += velocity (2, i)

		    % If the bullet goes off screen %
		    if netPosition (1) < leftWall or netPosition (1) > rightWall then
			bulletErase (i)
		    elsif netPosition (2) < bottomWall or netPosition (2) > topWall then
			bulletErase (i)
		    end if

		    didBulletHitChar (centerBulletPositionX, centerBulletPositionY, i)

		end if
	    end for
	else
	    stopAllBullets
	end if
    end drawBullets

end StandardBulletUnit
