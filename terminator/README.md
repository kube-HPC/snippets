#!/usr/bin/env bash

1) copy config file to /home/<USER>/.config/terminator/config

2) sudo gedit /usr/share/applications/terminator.desktop

3) replace with this content:

[Desktop Entry]
Name=Terminator
Comment=Multiple terminals in one window
TryExec=terminator
Exec=terminator
Icon=terminator
Type=Application
Categories=GNOME;GTK;Utility;TerminalEmulator;System;
StartupNotify=true
X-Ubuntu-Gettext-Domain=terminator
X-Ayatana-Desktop-Shortcuts=NewWindow;HKube;Drivers;AlgQueue;StubWorkers;StubEvalWorkers;RealWorkers;RealEvalWorkers;Dockers
Keywords=terminal;shell;prompt;command;commandline;
[HKube Shortcut Group]
Name=HKube Services
Exec=terminator -l hkube
TargetEnvironment=Unity
[Drivers Shortcut Group]
Name=HKube Pipeline Drivers
Exec=terminator -l drivers
TargetEnvironment=Unity
[AlgQueue Shortcut Group]
Name=HKube Algorithm Queue
Exec=terminator -l algQueue
TargetEnvironment=Unity
[StubWorkers Shortcut Group]
Name=HKube Stub Workers
Exec=terminator -l stubWorkers
TargetEnvironment=Unity
[StubEvalWorkers Shortcut Group]
Name=HKube Stub Eval Workers
Exec=terminator -l evalWorkers
TargetEnvironment=Unity
[RealWorkers Shortcut Group]
Name=HKube Real Workers
Exec=terminator -l realWorkers
TargetEnvironment=Unity
[RealEvalWorkers Shortcut Group]
Name=HKube Real Eval Workers
Exec=terminator -l realEvalWorkers
TargetEnvironment=Unity
[Dockers Shortcut Group]
Name=HKube Dockers
Exec=terminator -l docker
TargetEnvironment=Unity
