% This is the font window file


% opens a new window and displays the graphics messages to this window
proc displayFontWindow

    % Open the window
    var winID : int
    winID := Window.Open ("position:top;center,graphics:600;400,title:Font Window")

    isFontWindowOpen := true
    var quitButton := GUI.CreateButton (maxx - 100, 25, 0, "Close", QuitFontWindowPressed)

    delay (100)
    %declare font pointers
    var font1, font2, font3, font4 : int
    font1 := Font.New ("serif:12")
    assert font1 > 0
    font2 := Font.New ("sans serif:18:bold")
    assert font2 > 0
    font3 := Font.New ("mono:9")
    assert font3 > 0
    font4 := Font.New ("Palatino:24:bold,italic")
    assert font4 > 0

    %draw the graphic (not character/text) messages to the screen
    Font.Draw ("This is in a serif font", 50, 30, font1, red)
    Font.Draw ("This is in a sans serif font", 50, 80, font2, brightblue)
    Font.Draw ("This is in a mono font", 50, 130, font3, colorfg)
    Font.Draw ("This is in Palatino (if available)", 50, 180, font4, green)

    %release font pointers
    Font.Free (font1)
    Font.Free (font2)
    Font.Free (font3)
    Font.Free (font4)

    % create a button


    % Window will continue until quit button is pressed
    loop
	exit when GUI.ProcessEvent or isFontWindowOpen = false
    end loop
    %close/release the window
    Window.Close (winID)
    % release the button
    GUI.Dispose (quitButton)



end displayFontWindow
