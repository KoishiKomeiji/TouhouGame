unit
class ClassManager
    import characterRei in "Characters/CharacterRei.tu", StandardBulletUnit in "Bullets/StandardBullets.tu",
	StandardEnemyUnit in "Enemies/StandardEnemies.tu", CharacterBulletUnit in "Character's Bullets/Character's Bullets.tu",
	StandardPowerUpsUnit in "PowerUp/Powerup Unit.tu"
    export SBU, CHREI, SEU, CHBU, SPUU, setFPS, screen, setWalls, setFPSMultiplier, score, initializeBackground,
	setHighScore, rewriteHighScore
    var CHREI : ^characterRei
    new CHREI
    var SBU : ^StandardBulletUnit
    new SBU
    var SEU : ^StandardEnemyUnit
    new SEU
    var CHBU : ^CharacterBulletUnit
    new CHBU
    var SPUU : ^StandardPowerUpsUnit
    new SPUU
    %var SPUU : ^StandardPowerUpsUnit
    %new SPUU
    % Button Handlers %
    var key, shootKey : array char of boolean
    var keyShift : boolean := false
    var normSens : int := 5
    var normCounter := 0
    var homeSens : int := 50
    var homeCounter : int := 0
    var ch : string (1)
    % Temp varaibles %
    var startX, startY : int
    var endX, endY : real
    var leftWall, rightWall, topWall, bottomWall : int
    % Storage varaible for which enemy is still alive %
    var temp : int
    var score : real := 0
    var highScore : int
    var rewriteHighScore : boolean := false
    proc setHighScore (value : int)
	highScore := value
    end setHighScore
    % Font %
    var numFont := Font.New ("serif:12")

    % Background Picture %
    var backgroundPic : int := Pic.FileNew ("Images/Backgrounds/screens/Back.bmp")
    % Draws background %
    proc initializeBackground
	Pic.Draw (backgroundPic, 0, 0, picCopy)
	View.Update
    end initializeBackground


    % To make the game run more easily on other computers %
    % Frames per second, interval calculated using 1000 milliseconds div FPS %
    var FPS : int := 60
    var FPSInterval : int := round (1000 / FPS)
    var FPSMultiplier : real := 1

    % To allow the game to be run on slower computers %
    proc setFPSMultiplier (value : real)
	FPSMultiplier := value
	SBU -> setFPSMultiplier (value)
	SEU -> setFPSMultiplier (value)
	SPUU -> setFPSMultiplier (value)
	CHREI -> setFPSMultiplier (value)
	CHBU -> setFPSMultiplier (value)
	normSens := round (normSens / value)
	homeSens := round (homeSens / value)
    end setFPSMultiplier

    proc setFPS (value : int)
	var realNumber : real := FPS
	FPS := value
	FPSInterval := round (1000 / FPS)
	CHREI -> setFPS (FPS)
	CHREI -> setFPSInterval (FPSInterval)
    end setFPS

    % Set the walls %
    proc setWalls (left, right, up, down : int)
	leftWall := left
	rightWall := right
	topWall := up
	bottomWall := down
	SBU -> setWalls (left, right, up, down)
	SEU -> setWalls (left, right, up, down)
	CHBU -> setWalls (left, right, up, down)
	SPUU -> setWalls (left, right, up, down)
    end setWalls

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Enemy, Collision, Attack Pattern Procedures %

    % Attack patterns that the enemy can call %
    proc attackPatterns (pattern, pattern2, arrayPos : int)
	case (pattern) of
	    label 1 :
		% Homes bullet on you %
		startX := SEU -> getEnemyX (arrayPos)
		startY := SEU -> getEnemyY (arrayPos)
		endX := CHREI -> getCharX + SBU -> charCenterX
		endY := CHREI -> getCharY + SBU -> charCenterY
		SBU -> sameAngleBullet (endX, endY, 5, startX, startY, 1)
	    label 2 :
		% Homes 10 bullets on you %
		startX := SEU -> getEnemyX (arrayPos)
		startY := SEU -> getEnemyY (arrayPos)
		endX := CHREI -> getCharX + SBU -> charCenterX
		endY := CHREI -> getCharY + SBU -> charCenterY
		for i : 1 .. 10
		    SBU -> sameAngleBullet (endX, endY, i, startX, startY, 1)
		end for
	    label 3 :
		% Shoots 24 bulletsin a circular shape %
		startX := SEU -> getEnemyX (arrayPos)
		startY := SEU -> getEnemyY (arrayPos)
		for i : 0 .. 24
		    SBU -> sameAngleBullet (sind (i * 15) * 100 + startX, cosd (i * 15) * 100 + startY, 5, startX, startY, 1)
		end for
	    label 4 :
		% Shoots 10 bullets in a circular shape %
		startX := SEU -> getEnemyX (arrayPos)
		startY := SEU -> getEnemyY (arrayPos)
		for i : 0 .. 10
		    SBU -> sameAngleBullet (sind (i * 36) * 100 + startX, cosd (i * 36) * 100 + startY, 1, startX, startY, 1)
		end for
	    label 5 :
		% Singular Revolving Bullets %
		startX := SEU -> getEnemyX (arrayPos)
		startY := SEU -> getEnemyY (arrayPos)
		SBU -> sameAngleBullet (sind (pattern2) * 100 + startX, cosd (pattern2) * 100 + startY, 4, startX, startY, 1)
		if SEU -> getAttackPattern (arrayPos) = 360 then
		    SEU -> setAttackPattern2 (arrayPos, 0)
		else
		    SEU -> setAttackPattern2 (arrayPos, SEU -> getAttackPattern2 (arrayPos) + 15)
		end if
	    label 6 :
		% Quadruple Revolving Bullets %
		startX := SEU -> getEnemyX (arrayPos)
		startY := SEU -> getEnemyY (arrayPos)
		SBU -> sameAngleBullet (sind (pattern2) * 100 + startX, cosd (pattern2) * 100 + startY, 3, startX, startY, 2)
		SBU -> sameAngleBullet (sind (pattern2 + 90) * 100 + startX, cosd (pattern2 + 90) * 100 + startY, 3, startX, startY, 2)
		SBU -> sameAngleBullet (sind (pattern2 + 180) * 100 + startX, cosd (pattern2 + 180) * 100 + startY, 3, startX, startY, 2)
		SBU -> sameAngleBullet (sind (pattern2 + 270) * 100 + startX, cosd (pattern2 + 270) * 100 + startY, 3, startX, startY, 2)
		if SEU -> getAttackPattern (arrayPos) = 360 then
		    SEU -> setAttackPattern2 (arrayPos, 0)
		else
		    SEU -> setAttackPattern2 (arrayPos, SEU -> getAttackPattern2 (arrayPos) + 15)
		end if
	    label 7 :
		% Spray bullets up %
		startX := SEU -> getEnemyX (arrayPos)
		startY := SEU -> getEnemyY (arrayPos)
		SBU -> initializeBullet (-Rand.Real * 2, 2 + Rand.Real * 2, startX, startY, Rand.Int (1, 2))
		SBU -> initializeBullet (Rand.Real * 2, 2 + Rand.Real * 2, startX, startY, Rand.Int (1, 2))
	    label 8 :
		% Spray bullets Down %
		startX := SEU -> getEnemyX (arrayPos)
		startY := SEU -> getEnemyY (arrayPos)
		SBU -> initializeBullet (Rand.Real * 2, -2 - Rand.Real * 2, startX, startY, Rand.Int (1, 2))
		SBU -> initializeBullet (-Rand.Real * 2, -2 - Rand.Real * 2, startX, startY, Rand.Int (1, 2))
	    label 9 :
		% Quadruple Large Revolving Bullets %
		startX := SEU -> getEnemyX (arrayPos)
		startY := SEU -> getEnemyY (arrayPos)
		SBU -> sameAngleBullet (sind (pattern2) * 100 + startX, cosd (pattern2) * 100 + startY, 3, startX, startY, 3)
		SBU -> sameAngleBullet (sind (pattern2 + 90) * 100 + startX, cosd (pattern2 + 90) * 100 + startY, 3, startX, startY, 3)
		SBU -> sameAngleBullet (sind (pattern2 + 180) * 100 + startX, cosd (pattern2 + 180) * 100 + startY, 3, startX, startY, 3)
		SBU -> sameAngleBullet (sind (pattern2 + 270) * 100 + startX, cosd (pattern2 + 270) * 100 + startY, 3, startX, startY, 3)
		if SEU -> getAttackPattern (arrayPos) = 360 then
		    SEU -> setAttackPattern2 (arrayPos, 0)
		else
		    SEU -> setAttackPattern2 (arrayPos, SEU -> getAttackPattern2 (arrayPos) + 15)
		end if
	    label :

	end case

    end attackPatterns

    % Control what kind of bullets the character fires %
    proc characterFire (pattern : int)
	normCounter += 1
	homeCounter += 1
	normCounter := normCounter mod normSens
	homeCounter := homeCounter mod homeSens
	% Will always shoot 2 charms %
	if normCounter = 0 then
	    CHBU -> initializeBullet (0, 12, CHREI -> getCharX - 3, CHREI -> getCharY + 52, 1)
	    CHBU -> initializeBullet (0, 12, CHREI -> getCharX + 20, CHREI -> getCharY + 52, 1)
	end if
	case (pattern) of
		% 3 orbs %
	    label 1 :
		if homeCounter = 0 then
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX - 47, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX + 46, CHREI -> getCharY + 13, 2)
		    normSens := 5
		    homeSens := 50
		end if
		% 5 orbs %
	    label 2 :
		if homeCounter = 0 then
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX - 47, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX + 46, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    normSens := 5
		    homeSens := 50
		end if
		% 7 orbs %
	    label 3 :
		if homeCounter = 0 then
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX - 47, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX + 46, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (-1, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (1, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    normSens := 5
		    homeSens := 50
		end if
		% 9 orbs %
	    label 4 :
		if homeCounter = 0 then
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX - 47, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX + 46, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (-1, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (1, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (-2, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (2, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    normSens := 5
		    homeSens := 50
		end if
		% Shoots faster %
	    label 5 :
		if homeCounter = 0 then
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX - 47, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX + 46, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (0, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (-1, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (1, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (-2, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    CHBU -> initializeBullet (2, 5, CHREI -> getCharX, CHREI -> getCharY + 13, 2)
		    normSens := 3
		    homeSens := 30
		end if
	    label 6 :
		var number : int := round ((rightWall - leftWall) / 5)
		CHREI -> setBombs (CHREI -> getBombs - 1)
		SBU -> stopAllBullets
		for i : 1 .. 27
		    for j : 1 .. 10
			CHBU -> initializeBullet (0, j + 5, i * 20, 0, 3)
		    end for
		end for
	end case
    end characterFire

    proc randomPowerUp (posX, posY : int)
	% Initialize a powerup %
	var randomInt := Rand.Int (1, 1000)
	% Life, PowerMAX, Bomb, BigPowerUp, MiniPowerUp  %
	% Life : 0.5 percent chance %
	% PowerMAX : 0.1 percent chance %
	% Bomb : 0.5 percent chance %
	% BigPowerUp : 10 percent chance %
	% MiniPowerUp : 30 percent chance %
	if randomInt >= 1 and randomInt <= 5 then
	    SPUU -> initializePowerUp (0, -5, posX, posY, 1)
	elsif randomInt = 10 then
	    SPUU -> initializePowerUp (0, -5, posX, posY, 4)
	elsif randomInt >= 11 and randomInt <= 15 then
	    SPUU -> initializePowerUp (0, -5, posX, posY, 3)
	elsif randomInt >= 100 and randomInt <= 200 then
	    SPUU -> initializePowerUp (0, -5, posX, posY, 2)
	elsif randomInt >= 300 and randomInt <= 600 then
	    SPUU -> initializePowerUp (0, -5, posX, posY, 5)
	end if
    end randomPowerUp

    % Did the bullet hit the enemy %
    proc didBulletHitEnemy
	% My collision algorithm for bullet to enemy %
	% If the bullet hits the character, kill it and delete the bullets %
	% EnemyX, EnemyY, EnemyRadius, BulletX, BulletY, BulletKillRadius, bulletArrayPos, enemiesAlivePos %
	var a, b, c, d, e, f : real
	var g, h : int
	for i : 1 .. 3
	    for j : 1 .. CHBU -> getBulletArrayCounter (i)
		g := CHBU -> getBulletArrayPos (i, j)
		d := CHBU -> getBulletX (g, i)
		e := CHBU -> getBulletY (g, i)
		f := CHBU -> BulletTypeKillRadius (CHBU -> getBullets (g, i))
		for k : 1 .. SEU -> getEnemiesAlive
		    h := SEU -> getEnemiesAlivePosition (k)
		    a := SEU -> getEnemyX (h)
		    b := SEU -> getEnemyY (h)
		    c := SEU -> EnemyTypeKillRadius (SEU -> getEnemies (h))
		    if sqrt (((a - d) ** 2) + ((b - e) ** 2)) <= f + c then
			CHBU -> bulletErase (g, i)
			% Score/Points, calculated from damage %
			score += CHBU -> BulletDamage (CHBU -> getBullets (g, i)) * 10
			SEU -> setEnemyHP (h, SEU -> getEnemyHP (h) - CHBU -> BulletDamage (CHBU -> getBullets (g, i)))

			% If you kill it, you may get a treat =) %
			if SEU -> getEnemyHP (h) <= 0 then
			    randomPowerUp (round (a), round (b))
			end if

			exit

		    end if
		end for
	    end for
	end for

    end didBulletHitEnemy

    % After everything has been calculated, procedure to draw to screen %
    proc screen
	%cls
	% Bullet Handlers %
	% Move %
	Input.KeyDown (key)
	% To allow user to control the character more slowly %
	% 26 and 44 is the center of the character %
	if key (KEY_SHIFT) then
	    CHREI -> setKeyShift (true)
	else
	    CHREI -> setKeyShift (false)
	end if

	% Move left %
	if key (KEY_LEFT_ARROW) and CHREI -> getCharX > leftWall then
	    CHREI -> reiLeft
	end if
	% Move right %
	if key (KEY_RIGHT_ARROW) and CHREI -> getCharX + 26 < rightWall then
	    CHREI -> reiRight
	end if
	% Move up %
	if key (KEY_UP_ARROW) and CHREI -> getCharY + 44 < topWall then
	    CHREI -> reiUp
	end if
	% Move down %
	if key (KEY_DOWN_ARROW) and CHREI -> getCharY > bottomWall then
	    CHREI -> reiDown
	end if

	% Shoot %
	if key ('z') or key ('Z') then
	    var power : int := CHREI -> getPower
	    if power >= 0 and power <= 20 then
		characterFire (1)
	    elsif power >= 21 and power <= 50 then
		characterFire (2)
	    elsif power >= 51 and power <= 75 then
		characterFire (3)
	    elsif power >= 76 and power <= 127 then
		characterFire (4)
	    else
		characterFire (5)
	    end if
	end if

	% Use bomb %
	if key ('x') or key ('X') then
	    if CHREI -> getBombs > 0 and CHBU -> bulletCounter (3) < 100 then
		characterFire (6)
	    end if
	end if

	% Updates the classes per frame %
	% ***NOTE: getCharX/Y does not get the center of the character %
	SBU -> setCharX (CHREI -> getCharX)
	SBU -> setCharY (CHREI -> getCharY)
	SEU -> setCharX (CHREI -> getCharX)
	SEU -> setCharY (CHREI -> getCharY)
	SPUU -> setCharX (CHREI -> getCharX)
	SPUU -> setCharY (CHREI -> getCharY)
	SBU -> setIsCharDead (CHREI -> getDead)
	SEU -> setIsCharDead (CHREI -> getDead)

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DRAWING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Background Pic %
	Pic.Draw (backgroundPic, 0, 0, picCopy)

	% Draws enemy/bullet/PowerUp and checks for collision %
	SBU -> drawBullets
	if SBU -> getIsCharDead = true then
	    CHREI -> charIsDead
	end if

	SEU -> drawEnemies
	if SEU -> getIsCharDead = true then
	    CHREI -> charIsDead
	end if

	SPUU -> drawPowerUps
	if SPUU -> powerBoolean = true then
	    CHREI -> setPower (CHREI -> getPower + SPUU -> PowerUp)
	    if CHREI -> getPower >= 128 then
		CHREI -> setPower (128)
	    end if

	    CHREI -> setBombs (CHREI -> getBombs + SPUU -> BombUp)
	    CHREI -> setLives (CHREI -> getLives + SPUU -> LifeUp)
	    SPUU -> setPowerUp (0)
	    SPUU -> setBombUp (0)
	    SPUU -> setLifeUp (0)
	    SPUU -> setPowerBoolean (false)
	end if

	% If the character is alive and the enemy wants to kill you, create bullets here %
	if CHREI -> getDead = false then
	    for i : 1 .. SEU -> getNumAttacks
		% A : Pattern1, B: Pattern2, C: arrayPosition %
		% i like to be neat %
		var a := SEU -> getAttackPattern (SEU -> getAttackingEnemies (i))
		var b := SEU -> getAttackPattern2 (SEU -> getAttackingEnemies (i))
		var c := SEU -> getAttackingEnemies (i)
		attackPatterns (a, b, c)
	    end for
	end if

	% Draws character/bullet and checks for collision %

	CHREI -> drawRei
	didBulletHitEnemy

	CHBU -> drawBullets

	% To calculate the score %
	score += 0.2 * FPSMultiplier
	% High Score %
	% If high score is greater than score, then write score instead of high score %
	if highScore > score then
	    Font.Draw (intstr (highScore), 640, 490, numFont, 0)
	else
	    Font.Draw (realstr (round (score), 0), 640, 490, numFont, 0)
	    rewriteHighScore := true
	end if
	% Score %

	Font.Draw (realstr (round (score), 0), 640, 455, numFont, 0)

	% Lives %
	Font.Draw (intstr (CHREI -> getLives), 620, 347, numFont, 0)

	% Power %
	if CHREI -> getPower >= 128 then
	    Font.Draw ("MAX", 620, 328, numFont, 0)
	else
	    Font.Draw (intstr (CHREI -> getPower), 620, 328, numFont, 0)
	end if

	% Bombs %
	Font.Draw (intstr (CHREI -> getBombs), 620, 311, numFont, 0)

	% The stage %
	View.UpdateArea (40, 19, 520, 580)
	% Scores %
	View.UpdateArea (638, 450, 800, 600)
	% Lives, Power, Bombs %
	View.UpdateArea (616, 280, 800, 400)
	Time.DelaySinceLast (FPSInterval)

    end screen


end ClassManager





