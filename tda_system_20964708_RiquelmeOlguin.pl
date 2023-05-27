:- module(tda_system_20964708_RiquelmeOlguin, [filesystem/4, system/2, systemAddDrive/5, systemRegister/3, getDrives/2, setDrives/3, getUsuarios/2, setUser/3]).

:- use_module(tda_drive_20964708_RiquelmeOlguin, [drive/4, addDriveToDrives/3]).
:- use_module(tda_user_20964708_RiquelmeOlguin, [user/2, addUserToUsers/3]).

filesystem(Nombre, Drives, Usuarios, [Nombre, Drives, Usuarios]).

system(Nombre, Sistema) :-
    filesystem(Nombre, [], [], Sistema).

systemAddDrive(Sistema, Letra, Nombre, Capacidad, Newsistema) :-
    drive(Letra, Nombre, Capacidad, NewDrive),
    getDrives(Sistema, Drives),
    addDriveToDrives(NewDrive, Drives, UpdateDrives),
    setDrives(Sistema, UpdateDrives, Newsistema).

systemRegister(Sistema, NombreUser, Newsistema) :-
    user(NombreUser, NewUser),
    getUsuarios(Sistema, Usuarios),
    \+ member(NewUser, Usuarios),
    addUserToUsers(NewUser, Usuarios, UpdateUsers),
    setUser(Sistema, UpdateUsers, Newsistema).

getDrives(Sistema, Drives) :-
    filesystem(_, Drives, _, Sistema).

setDrives(Sistema, UpdateDrives, Newsistema) :-
    filesystem(Nombre, _, Usuarios, Sistema),
    filesystem(Nombre, UpdateDrives, Usuarios, Newsistema).

getUsuarios(Sistema, Usuarios) :-
    filesystem(_, _, Usuarios, Sistema).

setUser(Sistema, UpdateUsers, Newsistema) :-
    filesystem(Nombre, Drives, _, Sistema),
    filesystem(Nombre, Drives, UpdateUsers, Newsistema).
