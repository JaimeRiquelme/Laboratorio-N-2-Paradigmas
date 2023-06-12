:- module(tda_drive_20964708_RiquelmeOlguin, [drive/4, addDriveToDrives/3, setNombreDrive/3]).

% Descripcion: Predicado que define un drive. 
% Dominio: Letra X Nombre X Capacidad X Drive
% Metas Primarias: drive
drive(Letra, Nombre, Capacidad, [Letra, Nombre, Capacidad]).

% Descripcion: Predicado que agrega un nuevo drive a la lista de drives existente y devuelve la lista actualizada de drives.
% Dominio: NewDrive X Drives X UpdateDrives
% Metas Primarias: addDriveToDrives
% Metas Secundarias: append
addDriveToDrives(NewDrive, Drives, UpdateDrives) :-
    append(Drives, [NewDrive], UpdateDrives).




%SELECTORES
% Descripcion: Predicado que obtiene la letra del drive dado.
% Dominio: Drive X Letra
% Metas Primarias: getLetraDrive
% Metas Secundarias: drive
getLetraDrive(Drive, Letra) :-
    drive(Letra, _, _, Drive).

% Descripcion: Predicado que obtiene el nombre del drive dado.
% Dominio: Drive X Nombre
% Metas Primarias: getNombreDrive
% Metas Secundarias: drive
getNombreDrive(Drive, Nombre) :-
    drive(_, Nombre, _, Drive).

% Descripcion: Predicado que obtiene la capacidad del drive dado.
% Dominio: Drive X Capacidad
% Metas Primarias: getCapacidadDrive
% Metas Secundarias: drive
getCapacidadDrive(Drive, Capacidad) :-
    drive(_, _, Capacidad, Drive).

%MODIFICADORES
% Descripcion: Predicado que actualiza la letra del drive y devuelve el nuevo drive.
% Dominio: Drive X UpdateLetra X NewDrive
% Metas Primarias: setLetraDrive
% Metas Secundarias: drive
setLetraDrive(Drive, UpdateLetra, NewDrive) :-
    drive(_, Nombre, Capacidad, Drive),
    drive(UpdateLetra, Nombre, Capacidad, NewDrive).

% Descripcion: Predicado que actualiza el nombre del drive y devuelve el nuevo drive.
% Dominio: Drive X UpdateNombre X NewDrive
% Metas Primarias: setNombreDrive
% Metas Secundarias: drive
setNombreDrive(Drive, UpdateNombre, NewDrive) :-
    drive(Letra, _, Capacidad, Drive),
    drive(Letra, UpdateNombre, Capacidad, NewDrive).

% Descripcion: Predicado que actualiza la capacidad del drive y devuelve el nuevo drive.
% Dominio: Drive X UpdateCapacidad X NewDrive
% Metas Primarias: setCapacidadDrive
% Metas Secundarias: drive
setCapacidadDrive(Drive, UpdateCapacidad, NewDrive) :-
    drive(Letra, Nombre, _, Drive),
    drive(Letra, Nombre, UpdateCapacidad, NewDrive).

