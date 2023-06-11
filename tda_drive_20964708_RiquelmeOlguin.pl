:- module(tda_drive_20964708_RiquelmeOlguin, [drive/4, addDriveToDrives/3]).

drive(Letra, Nombre, Capacidad, [Letra, Nombre, Capacidad]).

addDriveToDrives(NewDrive, Drives, UpdateDrives) :-
    append(Drives, [NewDrive], UpdateDrives).



%SELECTORES
getLetraDrive(Drive, Letra) :-
    drive(Letra, _, _, Drive).

getNombreDrive(Drive, Nombre) :-
    drive(_, Nombre, _, Drive).

getCapacidadDrive(Drive, Capacidad) :-
    drive(_, _, Capacidad, Drive).

%MODIFICADORES
setLetraDrive(Drive, UpdateLetra, NewDrive) :-
    drive(_, Nombre, Capacidad, Drive),
    drive(UpdateLetra, Nombre, Capacidad, NewDrive).

setNombreDrive(Drive, UpdateNombre, NewDrive) :-
    drive(Letra, _, Capacidad, Drive),
    drive(Letra, UpdateNombre, Capacidad, NewDrive).

setCapacidadDrive(Drive, UpdateCapacidad, NewDrive) :-
    drive(Letra, Nombre, _, Drive),
    drive(Letra, Nombre, UpdateCapacidad, NewDrive).

