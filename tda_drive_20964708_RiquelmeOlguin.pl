:- module(tda_drive_20964708_RiquelmeOlguin, [drive/4, addDriveToDrives/3]).

drive(Letra, Nombre, Capacidad, [Letra, Nombre, Capacidad]).

addDriveToDrives(NewDrive, Drives, UpdateDrives) :-
    append(Drives, [NewDrive], UpdateDrives).
