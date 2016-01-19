%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer: Howard Zeng
%Date:    January 2010
%Course:  ICS3CU1
%Teacher:  M. Ianni
%Program Name:
%Descriptions:  Touhou Project, a bullet hell game
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MyGlobalVars.t
% All global variables are coded in this file.
% These will have FILE scope.
% These must be document thoroughly - Descriptive name,
%   where used and for what purpose

var isIntroWindowOpen : boolean % Flag for Introduction Window state open or closed
var isFontWindowOpen : boolean


proc setInitialGameValues

    isIntroWindowOpen := false
    isFontWindowOpen := false

end setInitialGameValues
