unit
class CharacterBulletUnit
    export setMaxBullets, initializeBullet, sameAngleBullet, drawBullets, setWalls, getBulletX, getBulletY,
	setAngleX, setAngleY, getAngleX, getAngleY, angleNormalize, BulletDamage, BulletTypeCenterX, BulletTypeCenterY,
	BulletTypeKillRadius, getBulletArrayCounter, getBulletArrayPos, getBullets, bulletErase, setFPSMultiplier,
	setVelocity, maxBullets, bulletCounter, setBulletDamage
    %%%%%%%%% BulletType Variables %%%%%%%%%
    % 8 different types of bullets %
    % 1st variable is the picture %
    % 2nd variable used store its bullet number %
    % Use Syntax(1,Bullet(i)) for making your life easier %
    var BulletTypes : array 1 .. 8 of int
    var BulletTypeKillRadius : array 1 .. 8 of real
    var BulletTypeCenterX : array 1 .. 8 of real
    var BulletTypeCenterY : array 1 .. 8 of real
    var BulletDamage : array 1 .. 8 of int
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% VARIABLES %%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% Bullets %%%%%    %%%%
    % Normal Bullet %
    BulletTypes (1) := Pic.FileNew ("Images/Bullets/YourBullet1.bmp")
    BulletTypeKillRadius (1) := 7
    BulletTypeCenterX (1) := 6.5
    BulletTypeCenterY (1) := 7.5
    BulletDamage (1) := 5
    Pic.SetTransparentColour (BulletTypes (1), brightgreen)
    % Larger normal Bullet %
    BulletTypes (2) := Pic.FileNew ("Images/Bullets/YourBullet5.bmp")
    BulletTypeKillRadius (2) := 14.5
    BulletTypeCenterX (2) := 15.5
    BulletTypeCenterY (2) := 15.5
    BulletDamage (2) := 20
    Pic.SetTransparentColour (BulletTypes (2), brightgreen)
    % Bomb 1 %
    BulletTypes (8) := Pic.FileNew ("Images/Bullets/Bomb1.bmp")
    BulletTypeKillRadius (8) := 39
    BulletTypeCenterX (8) := 38.5
    BulletTypeCenterY (8) := 39.0
    BulletDamage (8) := 500
    Pic.SetTransparentColour (BulletTypes (8), brightgreen)
    % Bomb 2 %
    BulletTypes (4) := Pic.FileNew ("Images/Bullets/Bomb2.bmp")
    BulletTypeKillRadius (4) := 39
    BulletTypeCenterX (4) := 38.5
    BulletTypeCenterY (4) := 39.0
    BulletDamage (4) := 500
    Pic.SetTransparentColour (BulletTypes (4), brightgreen)
    % Bomb 3 %
    BulletTypes (5) := Pic.FileNew ("Images/Bullets/Bomb3.bmp")
    BulletTypeKillRadius (5) := 39
    BulletTypeCenterX (5) := 38.5
    BulletTypeCenterY (5) := 39.0
    BulletDamage (5) := 500
    Pic.SetTransparentColour (BulletTypes (5), brightgreen)
    % Bomb 4 %
    BulletTypes (6) := Pic.FileNew ("Images/Bullets/Bomb4.bmp")
    BulletTypeKillRadius (6) := 39
    BulletTypeCenterX (6) := 38.5
    BulletTypeCenterY (6) := 39.0
    BulletDamage (6) := 500
    Pic.SetTransparentColour (BulletTypes (6), brightgreen)
    % Bomb 5 %
    BulletTypes (7) := Pic.FileNew ("Images/Bullets/Bomb5.bmp")
    BulletTypeKillRadius (7) := 39
    BulletTypeCenterX (7) := 38.5
    BulletTypeCenterY (7) := 39.0
    BulletDamage (7) := 500
    Pic.SetTransparentColour (BulletTypes (7), brightgreen)
    % Bomb 6 %
    BulletTypes (3) := Pic.FileNew ("Images/Bullets/YourBullet4.bmp")
    BulletTypeKillRadius (3) := 7
    BulletTypeCenterX (3) := 6.5
    BulletTypeCenterY (3) := 7.5
    BulletDamage (3) := 50
    Pic.SetTransparentColour (BulletTypes (3), brightgreen)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % WALLS!!! %
    % 30 is the largest bullet size so far %
    var leftWall : int := 0 - 30
    var rightWall : int := 800 + 30
    var topWall : int := 600 + 30
    var bottomWall : int := 0 - 30

    %%%%%% Parameters used when a bullet is fired %%%%%%
    % Have a maximum of 1000 Blue Bullets...not that I will use it all up %
    % Max Bullets %
    var maxBullets := 1000
    % Bullet information %
    var Bullets : array 1 .. 3, 1 .. maxBullets of int

    % Velocity of a bullet, 1..3 is normal bullet, homingBullet, bombBullet %
    var velocity : array 1 .. 3, 1 .. 2, 1 .. maxBullets of real
    var vCounter : array 1 .. 3, 1 .. 2, 1 .. maxBullets of real

    % Where the bullet is %
    var bulletPositions : array 1 .. 3, 1 .. 2, 1 .. maxBullets of real

    % Which bullets are drawn %
    var bulletBoolean : array 1 .. 3, 1 .. maxBullets of boolean
    for i : 1 .. 3
	for j : 1 .. maxBullets
	    bulletBoolean (i, j) := false
	end for
    end for

    % How many bullets are there %
    var bulletCounter : array 1 .. 3 of int := init (0, 0, 0)

    % Which array position the drawn enemies are %
    var bulletArrayCounter : array 1 .. 3 of int := init (0, 0, 0)
    var bulletArrayPos : array 1 .. 3, 1 .. maxBullets of int
    for i : 1 .. 3
	for j : 1 .. maxBullets
	    bulletArrayPos (i, j) := 0
	end for
    end for

    var FPSMultiplier : real := 1
    proc setFPSMultiplier (value : real)
	FPSMultiplier := value
    end setFPSMultiplier

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
	leftWall := left - 30
	rightWall := right + 30
	topWall := up + 30
	bottomWall := down - 30
    end setWalls

    proc setBulletDamage (damage, arrayPos : int)
	BulletDamage (arrayPos) := damage
    end setBulletDamage

    fcn getArrayPosition (bulletType : int) : int
	for i : 1 .. maxBullets
	    if bulletBoolean (bulletType, i) = false then
		result i
	    end if
	end for
    end getArrayPosition

    fcn getBulletArrayCounter (bulletType : int) : int
	result bulletArrayCounter (bulletType)
    end getBulletArrayCounter

    fcn getBulletArrayPos (bulletType, arrayPos : int) : int
	result bulletArrayPos (bulletType, arrayPos)
    end getBulletArrayPos

    % Gets the center of the bullet %
    fcn getBulletX (arrayPos, bulletType : int) : int
	result round (bulletPositions (bulletType, 1, arrayPos) + vCounter (bulletType, 1, arrayPos) + BulletTypeCenterX (bulletType))
    end getBulletX

    fcn getBulletY (arrayPos, bulletType : int) : int
	result round (bulletPositions (bulletType, 2, arrayPos) + vCounter (bulletType, 2, arrayPos) + BulletTypeCenterX (bulletType))
    end getBulletY

    % Gets the type of bullet %
    fcn getBullets (arrayPos, BulletType : int) : int
	result Bullets (BulletType, arrayPos)
    end getBullets

    % To set the velocity, the vCounter will be reset for the velocity to work %
    proc setVelocity (speedX, speedY : real, arrayPos, bulletType : int)
	velocity (bulletType, 1, arrayPos) := speedX * FPSMultiplier
	velocity (bulletType, 2, arrayPos) := speedY * FPSMultiplier
	vCounter (bulletType, 1, arrayPos) := 0
	vCounter (bulletType, 2, arrayPos) := 0
    end setVelocity

    % Stop the bullet from drawing %
    proc bulletErase (arrayPos, bulletType : int)
	bulletBoolean (bulletType, arrayPos) := false
	bulletCounter (bulletType) -= 1
    end bulletErase

    % To initialize a bullet to be ready for drawing %
    proc initializeBullet (speedX, speedY : real, setPositionX, setPositionY, bulletType : int)
	if bulletCounter (bulletType) < maxBullets then
	    var arrayPos : int := getArrayPosition (bulletType)
	    setVelocity (speedX, speedY, arrayPos, bulletType)
	    bulletPositions (bulletType, 1, arrayPos) := setPositionX
	    bulletPositions (bulletType, 2, arrayPos) := setPositionY
	    Bullets (bulletType, arrayPos) := bulletType
	    bulletCounter (bulletType) += 1
	    bulletBoolean (bulletType, arrayPos) := true
	end if
	%elsif bulletCounter (3) < maxBullets then
	%   var arrayPos : int := getArrayPosition (3)
	%  setVelocity (speedX, speedY, arrayPos, 3)
	% bulletPositions (3, 1, arrayPos) := setPositionX
	%bulletPositions (3, 2, arrayPos) := setPositionY
	%Bullets (3, arrayPos) := bulletType
	%bulletCounter (3) += 1
	%bulletBoolean (3, arrayPos) := true


    end initializeBullet

    % Where the bullet goes to, where it begins to be drawn, and its type %
    proc sameAngleBullet (endX, endY, speed : real, startX, startY, bulletType : int)
	setAngleX (endX - (startX + BulletTypeCenterX (bulletType)))
	setAngleY (endY - (startY + BulletTypeCenterY (bulletType)))
	angleNormalize
	initializeBullet (getAngleX * speed, getAngleY * speed, startX, startY, bulletType)
    end sameAngleBullet

    % Draws bullets, updates them, and analyzes them %
    proc drawBullets
	%   if getIsCharDead = false then
	% Variable used for an attempt to speed up processing %
	var netPosition : array 1 .. 2 of int

	% Precalculations to make the bullet kill %
	%var charPositionX : real := charPosX + charCenterX
	%var charPositionY : real := charPosY + charCenterY
	var centerBulletPositionX : real
	var centerBulletPositionY : real

	for i : 1 .. 3
	    bulletArrayCounter (i) := 0
	    for j : 1 .. maxBullets
		if bulletBoolean (i, j) = true then
		    % To stop when you get to the end of the bullet boolean %

		    netPosition (1) := round (bulletPositions (i, 1, j) + vCounter (i, 1, j))
		    netPosition (2) := round (bulletPositions (i, 2, j) + vCounter (i, 2, j))

		    % To calculate the center of bullets and the character %
		    centerBulletPositionX := netPosition (1) + BulletTypeCenterX (Bullets (i, j))
		    centerBulletPositionY := netPosition (2) + BulletTypeCenterY (Bullets (i, j))

		    % BulletTypes(Bullets(i)) contain which bullet type it is, Bullets(i) show the type of bullet in the array %
		    Pic.Draw (BulletTypes (Bullets (i, j)), netPosition (1), netPosition (2), picMerge)
		    vCounter (i, 1, j) += velocity (i, 1, j)
		    vCounter (i, 2, j) += velocity (i, 2, j)

		    % If the bullet goes off screen %
		    if netPosition (1) < leftWall or netPosition (1) > rightWall then
			bulletErase (j, i)
		    elsif netPosition (2) < bottomWall or netPosition (2) > topWall then
			bulletErase (j, i)
		    end if

		    bulletArrayCounter (i) += 1
		    bulletArrayPos (i, bulletArrayCounter (i)) := j

		end if
	    end for
	end for

	% To be used with a bomb, which was never finished...%
	%for i : 1 .. 100
	%   if bulletBoolean (3, i) = true then
	%      % To stop when you get to the end of the bullet boolean %

	%                netPosition (1) := round (bulletPositions (3, 1, i) + vCounter (3, 1, i))
	%               netPosition (2) := round (bulletPositions (3, 2, i) + vCounter (3, 2, i))

	%              % To calculate the center of bullets and the character %
	%             centerBulletPositionX := netPosition (1) + BulletTypeCenterX (Bullets (3, i))
	%            centerBulletPositionY := netPosition (2) + BulletTypeCenterY (Bullets (3, i))

	% BulletTypes(Bullets(i)) contain which bullet type it is, Bullets(i) show the type of bullet in the array %
	%           Pic.Draw (BulletTypes (Bullets (3, i)), netPosition (1), netPosition (2), picMerge)
	%          vCounter (3, 1, i) += velocity (3, 1, i)
	%         vCounter (3, 2, i) += velocity (3, 2, i)

	% If the bullet goes off screen %
	%        if netPosition (1) < leftWall or netPosition (1) > rightWall then
	%           bulletErase (i, 3)
	%      elsif netPosition (2) < bottomWall or netPosition (2) > topWall then
	%         bulletErase (i, 3)
	%    end if

	%   bulletArrayCounter (3) += 1
	%  bulletArrayPos (3, bulletCounter (3)) := i

	%end if
	%end for

    end drawBullets

end CharacterBulletUnit
