%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer: Howard Zeng
%Date:    May 23, 2011
%Course:  ICS3CU1
%Teacher:  M. Ianni
%Program Name: Touhou Project
%Descriptions:  A Bullet Hell Game
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import %
import ClassManager in "Classes/ClassManager.tu"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graphics %
View.Set ("graphics:800;600;offscreenonly,nocursor,noButtonBar")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize the classes declared %
var Manager : ^ClassManager
new Manager
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  ********  M A I N   P R O G R A M   S T E P S ********  %
% *********************   Main Variable Declarations Here %
% Music %
process BadApple
    %Music.PlayFileStop
    %Music.PlayFileLoop ("Files/Music/Bad Apple!!.mp3")
end BadApple
process MysticMaple
    %Music.PlayFileLoop ("Files/Music/Mystic Maple ~ Eternal Dream.mp3")
end MysticMaple
process PhantasmDream
    %Music.PlayFileStop
    %Music.PlayFileLoop ("Files/Music/Phantasm Dream ~ Inanimate Dream.mp3")
end PhantasmDream
process RomanticChildren
    %Music.PlayFileStop
    %Music.PlayFileLoop ("Files/Music/Romantic Children.mp3")
end RomanticChildren
process Melancholy
    %Music.PlayFileStop
    %Music.PlayFileLoop ("Files/Music/Witch's Melancholy.mp3")
end Melancholy
% Keys %
var key : array char of boolean
% Quit %
var QUIT : boolean := false
% Mouse %
var mouseX, mouseY, button : int
% Settings %
var setLIVES, setBOMBS, setINVISTIME : int := 3
var setFPS := 60
% Time until next wave %
var timeLeft : int := 0
% Stop enemy scripts %
var ENDSCRIPT : boolean := false
% Stop time counter %
var stopTimeCounter : boolean := false
% Boss Attack Pattern %
var bossPatt : int := 2
% To show the good game over screen %
var good : boolean := true
% Menu %
var menu, config, instructions : boolean := false
var menuA, menuB, menuC, menuD : boolean := false
var configA, configB : boolean := false
var instructionsA, instructionsB : boolean := false
var gameStart := false
% Menu Pics %
var MenuNormal : int := Pic.FileNew ("Images/Backgrounds/screens/Menu/Normal.bmp")
var MenuStart : int := Pic.FileNew ("Images/Backgrounds/screens/Menu/Start.bmp")
var MenuConfig : int := Pic.FileNew ("Images/Backgrounds/screens/Menu/Config.bmp")
var MenuInstructions : int := Pic.FileNew ("Images/Backgrounds/screens/Menu/Instructions.bmp")
% Config Pics %
var ConfigNormal : int := Pic.FileNew ("Images/Backgrounds/screens/Config/Normal.bmp")
var ConfigBack : int := Pic.FileNew ("Images/Backgrounds/screens/Config/Back.bmp")
% Instructions Pics
var InstructionsNormal : int := Pic.FileNew ("Images/Backgrounds/screens/Instructions/Normal.bmp")
var InstructionsBack : int := Pic.FileNew ("Images/Backgrounds/screens/Instructions/Back.bmp")
% Game over pics %
var GameOverA := Pic.FileNew ("Images/Backgrounds/screens/GAME OVER.bmp")
var GameOverB : int := Pic.FileNew ("Images/Backgrounds/screens/CREDITS.bmp")
% ***************************************   Major Block A : Create the menu %
% To initialize the menus...AND MUSIC! %
menu := true
menuA := false
fork MysticMaple
loop
    Input.KeyDown (key)
    if key (KEY_ESC) then
	QUIT := true
	exit
    end if
    if key ('=') then
	setLIVES := 10
    end if
    if key ('-') then
	setBOMBS := 10
    end if
    if key ('0') then
	setINVISTIME := 10
    end if

    exit when gameStart = true
    Mouse.Where (mouseX, mouseY, button)

    % Main Menu %
    if menu = true then
	% Game Start Selection %
	if mouseX >= 363 and mouseX <= 524 and mouseY >= 166 and mouseY <= 200 then
	    if button = 1 then
		gameStart := true
		menu := false
	    end if
	    if menuB = false then
		menuA := false
		menuB := true
		menuC := false
		menuD := false
		Pic.Draw (MenuStart, 0, 0, picCopy)
	    end if
	    % Config Selection %
	elsif mouseX >= 363 and mouseX <= 463 and mouseY >= 109 and mouseY <= 141 then
	    if button = 1 then
		config := true
		menu := false
	    end if
	    if menuC = false then
		menuA := false
		menuB := false
		menuC := true
		menuD := false
		Pic.Draw (MenuConfig, 0, 0, picCopy)
	    end if
	    % Instructions Selection %
	elsif mouseX >= 363 and mouseX <= 552 and mouseY >= 44 and mouseY <= 77 then
	    if button = 1 then
		instructions := true
		menu := false
	    end if
	    if menuD = false then
		menuA := false
		menuB := false
		menuC := false
		menuD := true
		Pic.Draw (MenuInstructions, 0, 0, picCopy)
	    end if
	    % No Selection %
	elsif menuA = false then
	    menuA := true
	    menuB := false
	    menuC := false
	    menuD := false
	    Pic.Draw (MenuNormal, 0, 0, picCopy)
	end if
	% Config Screen %
    elsif config = true then
	% Setting the speed of the computer %
	if mouseY >= 515 and mouseY <= 532 then
	    if button = 1 and mouseX >= 217 and mouseX <= 253 then
		setFPS := 60
	    elsif button = 1 and mouseX >= 254 and mouseX <= 342 then
		setFPS := 40
	    elsif button = 1 and mouseX >= 343 and mouseX <= 496 then
		setFPS := 30
	    elsif button = 1 and mouseX >= 497 and mouseX <= 535 then
		setFPS := 20
	    end if
	    % Setting Lives %
	elsif mouseY >= 494 and mouseY <= 511 then
	    if button = 1 and mouseX >= 56 and mouseX <= 80 then
		setLIVES := 1
	    elsif button = 1 and mouseX >= 81 and mouseX <= 111 then
		setLIVES := 2
	    elsif button = 1 and mouseX >= 112 and mouseX <= 140 then
		setLIVES := 3
	    elsif button = 1 and mouseX >= 141 and mouseX <= 168 then
		setLIVES := 4
	    elsif button = 1 and mouseX >= 169 and mouseX <= 197 then
		setLIVES := 5
	    end if
	    % Setting Bombs %
	elsif mouseY >= 476 and mouseY <= 493 then
	    if button = 1 and mouseX >= 72 and mouseX <= 92 then
		setBOMBS := 1
	    elsif button = 1 and mouseX >= 93 and mouseX <= 122 then
		setBOMBS := 2
	    elsif button = 1 and mouseX >= 123 and mouseX <= 153 then
		setBOMBS := 3
	    elsif button = 1 and mouseX >= 154 and mouseX <= 182 then
		setBOMBS := 4
	    elsif button = 1 and mouseX >= 183 and mouseX <= 206 then
		setBOMBS := 5
	    end if
	end if

	% If the player hovers over the back button %
	if mouseX >= 60 and mouseX <= 139 and mouseY >= 400 and mouseY <= 437 then
	    if configB = false then
		configA := false
		configB := true
		Pic.Draw (ConfigBack, 0, 0, picCopy)
	    end if
	    if button = 1 then
		config := false
		menu := true
	    end if
	elsif configA = false then
	    configA := true
	    configB := false
	    Pic.Draw (ConfigNormal, 0, 0, picCopy)
	end if

	% Instructions Screen %
    elsif instructions = true then
	if mouseX >= 406 and mouseX <= 482 and mouseY >= 295 and mouseY <= 329 then
	    if button = 1 then
		instructions := false
		menu := true
	    end if
	    instructionsA := false
	    instructionsB := true
	    Pic.Draw (InstructionsBack, 0, 0, picCopy)
	elsif instructionsA = false then
	    instructionsA := true
	    instructionsB := false
	    Pic.Draw (InstructionsNormal, 0, 0, picCopy)
	end if

    end if

    View.Update
end loop
% ***************************************   Major Block B : Set the game settings %
% Frames per second, interval calculated using 1000 milliseconds div FPS %
var FPS : real := setFPS
var FPSInterval : int := round (1000 / FPS)
Manager -> setFPS (round (FPS))
Manager -> setFPSMultiplier (60 / FPS)
Manager -> CHREI -> setCharX (200)
Manager -> CHREI -> setCharY (30)
Manager -> CHREI -> setInvisTime (setINVISTIME)
Manager -> CHREI -> setLives (setLIVES)
Manager -> CHREI -> setBombs (setBOMBS)
Manager -> CHREI -> setInitialBombs (setBOMBS)
% Left, Right, Top, Bottom %
Manager -> setWalls (40, 520, 580, 19)
% The character's parameters are stored in the SBU for convenience %
% Center co-ordinates x and y, character hit box radius %
Manager -> SBU -> setCharacterParam (12.5, 26.5, 4)
Manager -> SEU -> setCharacterParam (12.5, 26.5, 4)
Manager -> SPUU -> setCharacterParam (12.5, 26.5, 4)
% ***************************************   Major Block C : Make the stage(s) %
% ... and check the scores %
var stream : int
var sWord : string
var highScore : int
var sethighScore : boolean := false
open : stream, "Files/Text/score.txt", get
get : stream, sWord
highScore := strint (sWord, 36)
close : stream
Manager -> setHighScore (highScore)
% To calculate and set how much time left until next wave
proc waitTime (timeValue : int)
    timeLeft := (timeValue * FPS) div (60 / FPS)
end waitTime

% The scipt for the stage, after it's over, you just keep playing till you're dead %
% (How many)(Direction)(Where), (How many)(Direction)(Where), ... %
proc wave (waveNumber : int)
    case (waveNumber) of
	    % 5 down on top right %
	label 1 :
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (0, -0.2 * i, 500, 590, 1, 1, 1, 120)
	    end for
	    waitTime (5)
	    % 5 down on top left %
	label 2 :
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (0, -0.2 * i, 60, 590, 2, 1, 1, 120)
	    end for
	    waitTime (5)
	    % 5 up on bottom right %
	label 3 :
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (0, 0.5 * i, 500, 9, 3, 1, 1, 120)
	    end for
	    waitTime (5)
	    % 5 up on bottom left %
	label 4 :
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (0, 0.5 * i, 60, 9, 1, 1, 1, 120)
	    end for
	    waitTime (5)
	    % 5 right on middle left %
	label 5 :
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (0.2 * i, 0, 30, 450, 2, 1, 1, 120)
	    end for
	    waitTime (5)
	    % 5 left on middle right %
	label 6 :
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (-0.2 * i, 0, 530, 450, 3, 1, 1, 120)
	    end for
	    waitTime (5)
	    % 5 down on top right %
	label 7 :
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (0, -0.2 * i, 500, 590, 1, 1, 1, 120)
	    end for
	    waitTime (3)
	    % 5 down on top left %
	label 8 :
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (0, -0.2 * i, 60, 590, 2, 1, 1, 120)
	    end for
	    waitTime (3)
	    % 5 up on bottom right %
	label 9 :
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (0, 0.5 * i, 500, 9, 3, 1, 1, 120)
	    end for
	    waitTime (3)
	    % 5 up on bottom left %
	label 10 :
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (0, 0.5 * i, 60, 9, 1, 1, 1, 120)
	    end for
	    waitTime (3)
	    % 5 right on middle left %
	label 11 :
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (0.2 * i, 0, 30, 450, 2, 1, 1, 120)
	    end for
	    waitTime (3)
	    % 5 left on middle right %
	label 12 :
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (-0.2 * i, 0, 530, 450, 3, 1, 1, 120)
	    end for
	    waitTime (3)
	    % 10 left on middle right %
	label 13 :
	    for i : 1 .. 10
		Manager -> SEU -> initializeEnemy (-0.2 * i, 0, 530, 450, 1, 1, 1, 120)
	    end for
	    waitTime (3)
	    % 10 right on middle left %
	label 14 :
	    for i : 1 .. 10
		Manager -> SEU -> initializeEnemy (0.2 * i, 0, 30, 450, 2, 1, 1, 120)
	    end for
	    waitTime (5)
	    % 1 down on top middle %
	label 15 :
	    Manager -> SEU -> initializeEnemy (0, -1, 280, 590, 3, 100, 3, 20)
	    waitTime (5)
	    % 1 down top left, 1 down top right %
	label 16 :
	    Manager -> SEU -> initializeEnemy (0, -1, 60, 590, 1, 50, 2, 60)
	    Manager -> SEU -> initializeEnemy (0, -1, 500, 590, 2, 50, 2, 60)
	    waitTime (5)
	    % 1 right middle left, 1 left middle right %
	label 17 :
	    Manager -> SEU -> initializeEnemy (1, 0, 30, 450, 1, 50, 2, 60)
	    Manager -> SEU -> initializeEnemy (-1, 0, 530, 450, 2, 50, 2, 60)
	    waitTime (5)
	    % 1 right middle left, 1 left middle right, 1 down on top middle %
	label 18 :
	    Manager -> SEU -> initializeEnemy (1, 0, 30, 450, 1, 50, 2, 30)
	    Manager -> SEU -> initializeEnemy (-1, 0, 530, 450, 2, 50, 2, 60)
	    Manager -> SEU -> initializeEnemy (0, -1, 280, 590, 3, 50, 3, 60)
	    waitTime (5)
	    % 10 left on middle right %
	label 19 :
	    for i : 1 .. 10
		Manager -> SEU -> initializeEnemy (-0.2 * i, 0, 530, 450, Rand.Int (1, 3), 30, 1, 60)
	    end for
	    % 10 right on middle left %
	    for i : 1 .. 10
		Manager -> SEU -> initializeEnemy (0.2 * i, 0, 30, 450, Rand.Int (1, 3), 30, 1, 60)
	    end for
	    waitTime (5)
	label 20 :
	    % 14 down from top %
	    for i : 1 .. 14
		Manager -> SEU -> initializeEnemy (0, -1, (i * 30) + 60, 590, Rand.Int (1, 3), 30, 2, 60)
	    end for
	    waitTime (7)
	label 21 :
	    % 1 up bottom left, 1 up bottom right
	    Manager -> SEU -> initializeEnemy (0, 1, 60, 9, 1, 50, 2, 60)
	    Manager -> SEU -> initializeEnemy (0, 1, 500, 9, 2, 50, 2, 60)
	    waitTime (5)
	label 22 :
	    % All corners going to middle %
	    Manager -> SEU -> initializeEnemy (1, 1, 30, 9, 1, 50, 2, 60)
	    Manager -> SEU -> initializeEnemy (-1, 1, 530, 9, 2, 50, 2, 60)
	    Manager -> SEU -> initializeEnemy (1, -1, 30, 590, 1, 50, 2, 60)
	    Manager -> SEU -> initializeEnemy (-1, -1, 530, 590, 2, 50, 2, 60)
	    waitTime (5)
	label 23 :
	    % 1 in middle %
	    Manager -> SEU -> initializeEnemy (0, 0, 280, 350, 3, 350, 5, 2)
	    waitTime (5)
	label 24 :
	    % 1 in middle %
	    Manager -> SEU -> initializeEnemy (0, 0, 280, 350, 3, 350, 9, 2)
	    waitTime (5)
	label 25 :
	    % 3 down from top %
	    Manager -> SEU -> initializeEnemy (0, -0.5, 60, 590, Rand.Int (1, 3), 50, 3, 60)
	    Manager -> SEU -> initializeEnemy (0, -0.5, 280, 590, Rand.Int (1, 3), 50, 3, 60)
	    Manager -> SEU -> initializeEnemy (0, -0.5, 500, 590, Rand.Int (1, 3), 50, 3, 60)
	    waitTime (5)
	label 26 :
	    % 3 down from top %
	    Manager -> SEU -> initializeEnemy (0, -0.5, 60, 590, Rand.Int (1, 3), 50, 4, 60)
	    Manager -> SEU -> initializeEnemy (0, -0.5, 280, 590, Rand.Int (1, 3), 50, 4, 60)
	    Manager -> SEU -> initializeEnemy (0, -0.5, 500, 590, Rand.Int (1, 3), 50, 4, 60)
	    waitTime (6)
	label 27 :
	    % 3 down from top %
	    Manager -> SEU -> initializeEnemy (0, -0.5, 60, 590, Rand.Int (1, 3), 50, 5, 10)
	    Manager -> SEU -> initializeEnemy (0, -0.5, 280, 590, Rand.Int (1, 3), 50, 5, 10)
	    Manager -> SEU -> initializeEnemy (0, -0.5, 500, 590, Rand.Int (1, 3), 50, 5, 10)
	    waitTime (10)
	label 28 :
	    % 3 down from top %
	    Manager -> SEU -> initializeEnemy (0, -0.5, 60, 590, Rand.Int (1, 3), 100, 6, 10)
	    Manager -> SEU -> initializeEnemy (0, -0.5, 280, 590, Rand.Int (1, 3), 100, 6, 10)
	    Manager -> SEU -> initializeEnemy (0, -0.5, 500, 590, Rand.Int (1, 3), 100, 6, 10)
	    waitTime (15)
	label 29 :
	    % 3 down from top %
	    Manager -> SEU -> initializeEnemy (0, -1, 60, 590, Rand.Int (1, 3), 200, 7, 10)
	    Manager -> SEU -> initializeEnemy (0, -1, 280, 590, Rand.Int (1, 3), 200, 7, 10)
	    Manager -> SEU -> initializeEnemy (0, -1, 500, 590, Rand.Int (1, 3), 200, 7, 10)
	    waitTime (5)
	label 30 :
	    % 3 up from bottom %
	    Manager -> SEU -> initializeEnemy (0, 0.5, 60, 9, Rand.Int (1, 3), 200, 8, 10)
	    Manager -> SEU -> initializeEnemy (0, 0.5, 280, 9, Rand.Int (1, 3), 200, 8, 10)
	    Manager -> SEU -> initializeEnemy (0, 0.5, 500, 9, Rand.Int (1, 3), 200, 8, 10)
	    waitTime (5)
	label 31 :
	    % 3 down from top %
	    Manager -> SEU -> initializeEnemy (0, -1, 60, 590, Rand.Int (1, 3), 200, 8, 5)
	    Manager -> SEU -> initializeEnemy (0, -1, 280, 590, Rand.Int (1, 3), 200, 8, 5)
	    Manager -> SEU -> initializeEnemy (0, -1, 500, 590, Rand.Int (1, 3), 200, 8, 5)
	    waitTime (5)
	label 32 :
	    % 3 up from bottom %
	    Manager -> SEU -> initializeEnemy (0, 0.5, 60, 9, Rand.Int (1, 3), 200, 7, 5)
	    Manager -> SEU -> initializeEnemy (0, 0.5, 280, 9, Rand.Int (1, 3), 200, 7, 5)
	    Manager -> SEU -> initializeEnemy (0, 0.5, 500, 9, Rand.Int (1, 3), 200, 7, 5)
	    waitTime (5)
	label 33 :
	    % Label 31 and 32 %
	    Manager -> SEU -> initializeEnemy (0, -1, 60, 590, Rand.Int (1, 3), 200, 8, 5)
	    Manager -> SEU -> initializeEnemy (0, -1, 280, 590, Rand.Int (1, 3), 200, 8, 5)
	    Manager -> SEU -> initializeEnemy (0, -1, 500, 590, Rand.Int (1, 3), 200, 8, 5)
	    Manager -> SEU -> initializeEnemy (0, 0.5, 60, 9, Rand.Int (1, 3), 200, 7, 5)
	    Manager -> SEU -> initializeEnemy (0, 0.5, 280, 9, Rand.Int (1, 3), 200, 7, 5)
	    Manager -> SEU -> initializeEnemy (0, 0.5, 500, 9, Rand.Int (1, 3), 200, 7, 5)
	    waitTime (10)
	label 34 :
	    % 28 Top and bottom %
	    for i : 1 .. 14
		Manager -> SEU -> initializeEnemy (0, -1, (i * 30) + 60, 590, Rand.Int (1, 3), 30, 1, 60)
		Manager -> SEU -> initializeEnemy (0, 1, (i * 30) + 60, 9, Rand.Int (1, 3), 30, 1, 60)
	    end for
	label 35 :
	    % 10 from the sides %
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (0.2 * i, 0, 30, 450, 2, 50, 1, 5)
	    end for
	    for i : 1 .. 5
		Manager -> SEU -> initializeEnemy (-0.2 * i, 0, 530, 450, 3, 50, 1, 5)
	    end for
	    waitTime (10)
	label 36 :
	    % Boss %
	    Manager -> SEU -> initializeBoss (0, -1, 280, 590, 4, 10000, 100, 10, 1000)
	    stopTimeCounter := true
	    fork PhantasmDream
	label :
    end case
end wave

proc boss

    % EnemyPosX, Y, HP %
    var a : int := Manager -> SEU -> getEnemyX (1000)
    var b : int := Manager -> SEU -> getEnemyY (1000)
    var c : int := Manager -> SEU -> getEnemyHP (1000)
    % Begin loop %
    if Manager -> SEU -> getEnemyX (1000) >= 420 and Manager -> SEU -> getEnemyY (1000) >= 420 and bossPatt = 2 then
	% Left %
	bossPatt += 1
	% Spray down %
	Manager -> SEU -> initializeBoss (-2, 0, a, b, 4, c, 8, 10, 1000)
	Manager -> SEU -> setAttackPattern2 (1000, 0)
    elsif Manager -> SEU -> getEnemyX (1000) <= 100 and bossPatt = 3 then
	% Down %
	bossPatt += 1
	% Random %
	Manager -> SEU -> initializeBoss (0, -2, a, b, 4, c, Rand.Int (5, 6), 5, 1000)
	Manager -> SEU -> setAttackPattern2 (1000, 0)
    elsif Manager -> SEU -> getEnemyY (1000) <= 30 and bossPatt = 4 then
	% Right %
	bossPatt += 1
	% Spray up %
	Manager -> SEU -> initializeBoss (2, 0, a, b, 4, c, 7, 10, 1000)
	Manager -> SEU -> setAttackPattern2 (1000, 0)
    elsif Manager -> SEU -> getEnemyX (1000) >= 420 and bossPatt = 5 then
	% Up %
	bossPatt := 2
	% Random %
	Manager -> SEU -> initializeBoss (0, 2, a, b, 4, c, Rand.Int (1, 2), 10, 1000)
	Manager -> SEU -> setAttackPattern2 (1000, 0)
    end if
end boss

% ***************************************   Major Block D : Declare the procedures / processes %
% Writes an encrypted high score into text file %
proc writeHighScore (value : int)
    open : stream, "Files/Text/score.txt", put
    put : stream, intstr (value, 0, 36)
    close : stream
end writeHighScore


proc endGame
    % If the player beat the high score, update it %
    if Manager -> rewriteHighScore = true then
	writeHighScore (floor (Manager -> score))
    end if

    % Press ESC to stop game %
    if QUIT = true then
	Music.PlayFileStop
	Error.Halt ("\nWhy did you terminate me for? =(\nDo you not want to play with me anymore?")
    end if
    var dummy : string (1)

    delay (1000)
    % If the score is over 200000 and the boss was killed then award a different game over screen %
    if Manager -> score >= 200000 and good = true then
	Pic.Draw (GameOverB, 0, 0, picCopy)
	fork Melancholy
    else
	Pic.Draw (GameOverA, 0, 0, picCopy)
    end if
    View.Update
    delay (5000)
    getch (dummy)
    Music.PlayFileStop
    Error.Halt ("\nEND")

end endGame

% To randomly generate enemies when the game ends %
process minigame
    loop
	Manager -> SEU -> initializeEnemy (0, -1, Rand.Int (40, 500), 620, Rand.Int (1, 3), Rand.Int (1, 50), Rand.Int (1, 6), Rand.Int (10, 180))
	delay (500)
    end loop
end minigame

process screen
    var amountTime : int := 0
    var waveNumber : int := 0
    var atkPatt : int := 0
    var atkCounter : int := 0
    var stopAtkCounter : boolean := false
    loop
	Input.KeyDown (key)
	if key (KEY_ESC) then
	    QUIT := true
	    exit
	end if
	exit when Manager -> CHREI -> getLives <= 0
	exit when QUIT = true
	Manager -> screen

	% To call the enemy waves %
	if ENDSCRIPT = false then
	    if stopTimeCounter = false then
		amountTime += 1
		% If there are no enemies left, send out more %
		if amountTime = timeLeft then
		    waveNumber += 1
		    wave (waveNumber)
		    amountTime := 0
		end if
	    else
		% Boss %
		% EnemyPosX, Y, HP %
		var a : int := Manager -> SEU -> getEnemyX (1000)
		var b : int := Manager -> SEU -> getEnemyY (1000)
		var c : int := Manager -> SEU -> getEnemyHP (1000)
		% Stop %
		if Manager -> SEU -> getEnemyY (1000) <= 450 and atkPatt = 0 and stopAtkCounter = false then
		    atkCounter += 1
		    Manager -> SEU -> initializeBoss (0, 0, a, b, 4, c, 1, 10, 1000)
		    Manager -> SEU -> setAttackPattern (1000, 9)
		    atkPatt += 1
		    % Right %
		elsif Manager -> SEU -> getEnemyY (1000) <= 450 and atkPatt = 1 and stopAtkCounter = false then
		    atkPatt += 1
		    Manager -> SEU -> initializeBoss (3, 0, a, b, 4, c, 1, 10, 1000)
		    stopAtkCounter := true
		end if

		% To go into a loop for the boss %
		if stopAtkCounter = true then
		    if Manager -> SEU -> getEnemyHP (1000) >= 100 then
			boss
		    else
			% To make a neverending minigame %
			fork minigame
			ENDSCRIPT := true
			% To show a good game over for killing the boss %
			good := true
			fork BadApple
		    end if
		end if
	    end if
	end if


    end loop
    endGame
end screen
% ***************************************   Major Block E : Use the processes %
% To initialize the game %
waitTime (1)
fork RomanticChildren
Manager -> initializeBackground
fork screen


% ***************************************   Major Block F

% *********** E N D     O F    P R O G R A M  ************





