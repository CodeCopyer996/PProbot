% The purpose of this script is to setup the call to the next stage of
% the presentation

% setup CONTINUE... and INFO buttons
% the CONTINUE... button is used to call the next file using the 'callback'
% property

% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.9 $

set(info_btn(1),'enable','on');
if last==0,  % setup Info button for template explanation
 set(info_btn(2),'enable','on','callback',...
                 'web([''file:///'',which(''tmplhelp.htm'')]);');
 set(info_btn(3),'enable','on',...
    'callback',['set(gco,''enable'',''off'');set(findobj(allchild(0),''tag'',''QuitButton''),''enable'',''off'');eval(''',next_stage,''',''qfterror(2)'');set(findobj(allchild(0),''tag'',''QuitButton''),''enable'',''on'')']);
%    'callback',['set(gco,''enable'',''off'');',next_stage]);

elseif last==1, % setup Info button for bound explanation
 callbk = [next_stage];
 set(info_btn(2),'enable','on','callback',...
                 'web([''file:///'',which(''bndshelp.htm'')]);');
 set(info_btn(3),'enable','on',...
    'callback',['set(gco,''enable'',''off'');set(findobj(allchild(0),''tag'',''QuitButton''),''enable'',''off'');eval(''',next_stage,''',''qfterror(2)'');set(findobj(allchild(0),''tag'',''QuitButton''),''enable'',''on'')']);
%    'callback',['set(gco,''enable'',''off'');',callbk]);

elseif last==2, % no info to be displayed
 set(info_btn(2),'enable','off');
 set(info_btn(3),'enable','on',...
    'callback',['set(gco,''enable'',''off'');set(findobj(allchild(0),''tag'',''QuitButton''),''enable'',''off'');eval(''',next_stage,''',''qfterror(2)'');set(findobj(allchild(0),''tag'',''QuitButton''),''enable'',''on'')']);
%    'callback',['set(gco,''enable'',''off'');',next_stage]);

elseif last==3, % setup Done button to finish specific demo
 set(info_btn(2:3),'enable','off');
 set(info_btn(1),'string','Done');
end
figure(info_win);
