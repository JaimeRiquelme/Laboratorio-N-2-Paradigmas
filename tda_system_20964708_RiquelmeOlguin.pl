:- module(tda_system_20964708_RiquelmeOlguin, [filesystem/10,
                                               system/2,
                                               systemAddDrive/5,
                                               systemRegister/3, getDrives/2, setDrives/3, getUsuarios/2, setUser/3, systemLogin/3,
                                               systemLogout/2,systemSwitchDrive/3 ,systemMkdir/3, systemCd/3,systemAddFile/3,
                                               systemDel/3, getRutaActual/2,getContenidoFF/3]).

:- use_module(tda_drive_20964708_RiquelmeOlguin, [drive/4, addDriveToDrives/3]).
:- use_module(tda_user_20964708_RiquelmeOlguin, [user/2, addUserToUsers/3]).
:- use_module(tda_folder_20964708_RiquelmeOlguin, [folder/6 , addFolderToContenido/3,setRutaFolder/3, getRutaFolder/2, setNombreFolder/3 ,getNombreFolder/2,getFechaCreacionFolder/2,
                        getFechaModificacionFolder/2]).
:- use_module(tda_file_20964708_RiquelmeOlguin, [file/3 , addFileToContenido/3, getNombreFile/2 , getContenidoFile/2 , setNombreFile/3]).



% -----------------------Constructor Y Pertenencia---------------------------

filesystem(Nombre, Drives,Contenido,RutasSistema, Usuarios,UsuarioLogeado,DriveActual,RutaActual,Papelera, [Nombre, Drives, Contenido, RutasSistema, Usuarios,UsuarioLogeado,DriveActual,RutaActual,Papelera]).



% -----------------------Requerimientos Funcionales----------------------------
% Descripcion: Predicado que crea un sistema vacío con un nombre específico.
% Dominio: NombreSistema X Sistema
% Metas Primarias: system
% Metas Secundarias: string, nombre_Sistema, filesystem
system(NombreSistema, Sistema) :-
    string(NombreSistema),
    nombre_Sistema(NombreSistema, Nombre),
    filesystem(Nombre, [], [], [], [], [], [], [], [], Sistema),!.


% Descripcion: Predicado que agrega un nuevo drive a un sistema.
% Dominio: Sistema X Letra X Nombre X Capacidad X NewSistema
% Metas Primarias: systemAddDrive
% Metas Secundarias: string, string_length, drive, getDrives, member, addDriveToDrives, setDrives
systemAddDrive(Sistema, Letra, Nombre, Capacidad, Newsistema) :-
    string(Nombre),
    string_length(Letra, 1),  % Asegura que Letra tiene un solo carácter
    drive(Letra, Nombre, Capacidad, NewDrive),
    getDrives(Sistema, Drives),
    \+ member([Letra, _, _], Drives),  % Verifica que la letra no esté presente en Drives
    addDriveToDrives(NewDrive, Drives, UpdateDrives),
    setDrives(Sistema, UpdateDrives, Newsistema),!.



% Descripcion: Predicado que registra un usuario en un sistema existente.
% Dominio: Sistema X NombreUser X Sistema
% Metas Primarias: systemRegister
% Metas Secundarias: string, getUsuarios, user, member
systemRegister(Sistema, NombreUser, Sistema) :-
    string(NombreUser),
    getUsuarios(Sistema, Usuarios),
    user(NombreUser, NewUser),
    member(NewUser, Usuarios), !.

% Descripcion: Predicado que registra un nuevo usuario en un sistema.
% Dominio: Sistema X NombreUser X NewSistema
% Metas Primarias: systemRegister
% Metas Secundarias: string, user, string_a_lista, getUsuarios, member, addUserToUsers, setUser
systemRegister(Sistema, NombreUser, Newsistema) :-
    string(NombreUser),
    user(NombreUser, NewUser),
    string_a_lista(NewUser, UserList),
    getUsuarios(Sistema, Usuarios),
    \+ member(UserList, Usuarios), % Verifica que el usuario no está presente en Usuarios
    addUserToUsers(NewUser, Usuarios, UpdateUsers),
    setUser(Sistema, UpdateUsers, Newsistema).




systemLogin(Sistema, NombreUser, Newsistema) :-
    getUsuarioLogeado(Sistema, UsuarioLogeado),
    UsuarioLogeado = [],
    user(NombreUser, NewUser),
    getUsuarios(Sistema, Usuarios),
    member(NewUser, Usuarios),
    setUsuarioLogeado(Sistema, NewUser, Newsistema),!.

systemLogin(Sistema, NombreUser, Newsistema) :-
    getUsuarioLogeado(Sistema, UsuarioLogeado),
    list_to_string(UsuarioLogeado,UserLog),
    UserLog = NombreUser,
    user(NombreUser, NewUser),
    getUsuarios(Sistema, Usuarios),
    member(NewUser, Usuarios),
    setUsuarioLogeado(Sistema, NewUser, Newsistema),!.



systemLogout(Sistema,Newsistema):-
    getUsuarioLogeado(Sistema,UsuarioLogeado),
    \+ UsuarioLogeado = [],
    setUsuarioLogeado(Sistema,[],Newsistema).




systemSwitchDrive(Sistema, Letra, Newsistema):-
    getUsuarioLogeado(Sistema, UsuarioLogeado),
    list_to_string(UsuarioLogeado, User),
    systemLogin(Sistema, User, LoggedInSistema),
    Sistema == LoggedInSistema, % Continuar solo si systemLogin devolvió el mismo sistema (usuario ya logeado)
    getDrives(Sistema, Drives),
    member([Letra, _, _], Drives),
    setDriveActual(Sistema, Letra, NewsistemaDrive),
    string_concat(Letra, ":/", RutaRaiz),
    setRutaActual(NewsistemaDrive, RutaRaiz, Newsistema).



systemMkdir(Sistema,Nombre,Newsistema):-
    getUsuarioLogeado(Sistema,UsuarioLogeado),
    UsuarioLogeado \= [],
    get_time(Time),
    getRutaActual(NewSistemaContenido,RutaActual),
    folder(Nombre,UsuarioLogeado,Time,Time,RutaActual,Newfile),
    getContenido(Sistema,Contenido),
    addFolderToContenido(Newfile,Contenido,NewContenido),
    setContenido(Sistema,NewContenido,NewSistemaContenido),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaActual = RutaRaiz,
    string_concat(RutaActual, Nombre, RutaFolder),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    \+member(RutaFolder,RutasSistema),
    addRutaToRutas(RutaFolder,RutasSistema,NewRutasSistema),
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema),!.

systemMkdir(Sistema,Nombre,Newsistema):-
    getUsuarioLogeado(Sistema,UsuarioLogeado),
    UsuarioLogeado \= [],
    get_time(Time),
    getRutaActual(NewSistemaContenido,RutaActual),
    folder(Nombre,UsuarioLogeado,Time,Time,RutaActual,Newfile),
    getContenido(Sistema,Contenido),
    addFolderToContenido(Newfile,Contenido,NewContenido),
    setContenido(Sistema,NewContenido,NewSistemaContenido),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaActual \= RutaRaiz,
    string_concat(RutaActual, "/", TempRuta),
    string_concat(TempRuta, Nombre, RutaFolder),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    \+member(RutaFolder,RutasSistema),
    addRutaToRutas(RutaFolder,RutasSistema,NewRutasSistema),
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema),!.



systemCd(Sistema,Nombre,Newsistema):-
    Nombre = "/",
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    setRutaActual(Sistema,RutaRaiz,Newsistema),!.


systemCd(Sistema,Nombre,Newsistema):-
    getRutaActual(Sistema,RutaActual),
    Nombre = "..",
    split_string(RutaActual,"/","",Split),
    reverse(Split,ReverseSplit),
    quitar_cabeza(ReverseSplit,ColaPath),
    reverse(ColaPath,Reverse2),
    atomic_list_concat(Reverse2,"/",Newpath),
    setRutaActual(Sistema,Newpath,Newsistema),!.

systemCd(Sistema, Nombre, Sistema):-
    sub_atom(Nombre, 0, 1, _, '.'), !. % Si el Nombre comienza con ".", el sistema permanece sin cambios

systemCd(Sistema, Nombre, Newsistema):-
    sub_atom(Nombre, 0, 1, _, '/'), % Rama para cuando Nombre comienza con "/"
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    getRutaActual(Sistema,RutaActual),
    RutaRaiz = RutaActual,
    sub_atom(Nombre, 1, _, 0, NombreAux), % Quitamos el "/" inicial del Nombre
    string_concat(RutaActual,NombreAux,Newruta),
    getRutasSistema(Sistema,RutasSistema),
    member(Newruta,RutasSistema),
    setRutaActual(Sistema,Newruta,Newsistema),!.


systemCd(Sistema, Nombre, Newsistema):-
    \+ sub_atom(Nombre, 0, 1, _, '/'), % Rama para cuando Nombre no comienza con "/"
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    getRutaActual(Sistema,RutaActual),
    RutaRaiz = RutaActual,
    string_concat(RutaActual,Nombre,Newruta),
    getRutasSistema(Sistema,RutasSistema),
    member(Newruta,RutasSistema),
    setRutaActual(Sistema,Newruta,Newsistema),!.


systemCd(Sistema,Nombre,Newsistema):-
    \+ Nombre = "..",
    \+ Nombre = "/",
    sub_atom(Nombre, 0, 1, _, '/'), % Rama para cuando Nombre comienza con "/"
    getRutaActual(Sistema,RutaActual),
    string_concat(RutaActual,Nombre,Newruta),
    setRutaActual(Sistema,Newruta,Newsistema),!.

systemCd(Sistema,Nombre,Newsistema):-
    \+ Nombre = "..",
    \+ Nombre = "/",
    \+ sub_atom(Nombre, 0, 1, _, '/'), % Rama para cuando Nombre no comienza con "/"
    getRutaActual(Sistema,RutaActual),
    string_concat(RutaActual,"/",Ruta1),
    string_concat(Ruta1,Nombre,Newruta),
    getRutasSistema(Sistema,RutasSistema),
    member(Newruta,RutasSistema),
    setRutaActual(Sistema,Newruta,Newsistema),!.


systemAddFile(Sistema, File, Newsistema):-
    getContenido(Sistema,Contenido),
    addFileToContenido(File,Contenido,NewContenido),
    setContenido(Sistema,NewContenido,NewSistemaContenido),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual, ":/",RutaRaiz),
    getRutaActual(NewSistemaContenido,RutaActual),
    getNombreFile(File,Nombre),
    RutaActual = RutaRaiz,
    string_concat(RutaActual, Nombre, RutaFile),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    \+member(RutaFile,RutasSistema),
    addRutaToRutas(RutaFile,RutasSistema,NewRutasSistema),
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema),!.

systemAddFile(Sistema, File, Newsistema):-
    getContenido(Sistema,Contenido),
    addFileToContenido(File,Contenido,NewContenido),
    setContenido(Sistema,NewContenido,NewSistemaContenido),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual, ":/",RutaRaiz),
    getRutaActual(NewSistemaContenido,RutaActual),
    getNombreFile(File,Nombre),
    RutaActual \= RutaRaiz,
    string_concat(RutaActual, "/", TempRuta),
    string_concat(TempRuta, Nombre, RutaFile),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    \+member(RutaFile,RutasSistema),
    addRutaToRutas(RutaFile,RutasSistema,NewRutasSistema),
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema).


systemDel(Sistema,NombreEliminar,Newsistema):-
    getRutaActual(Sistema,RutaActual),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaActual = RutaRaiz,
    string_concat(RutaActual,NombreEliminar,RutaEliminar),
    getRutasSistema(Sistema,RutasSistema),
    member(RutaEliminar,RutasSistema),
    getContenido(Sistema,Contenido),
    getContenidoFF(NombreEliminar,Contenido,ContenidoFolder),
    setPapelera(Sistema,ContenidoFolder,NewsistemaPapelera),
    getRutaFolder(ContenidoFolder,RutaFolder),
    eliminar_carpeta(NombreEliminar,RutaFolder,Contenido,NewContenido),
    setContenido(NewsistemaPapelera,NewContenido,Newsistema).

systemDel(Sistema,NombreEliminar,Newsistema):-
    getRutaActual(Sistema,RutaActual),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaActual \= RutaRaiz,
    string_concat(RutaActual,"/",RutaAux),
    string_concat(RutaAux,NombreEliminar,RutaEliminar),
    getRutasSistema(Sistema,RutasSistema),
    member(RutaEliminar,RutasSistema),
    getContenido(Sistema,Contenido),
    getContenidoFF(NombreEliminar,Contenido,ContenidoFolder),
    setPapelera(Sistema,ContenidoFolder,NewsistemaPapelera),
    getRutaFolder(ContenidoFolder,RutaFolder),
    eliminar_carpeta(NombreEliminar,RutaFolder,Contenido,NewContenido),
    setContenido(NewsistemaPapelera,NewContenido,Newsistema).

systemDel(Sistema,NombreEliminar,Newsistema):-
    getRutaActual(Sistema,RutaActual),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaActual \= RutaRaiz,
    string_concat(RutaActual,"/",RutaAux),
    string_concat(RutaAux,NombreEliminar,RutaEliminar),
    getRutasSistema(Sistema,RutasSistema),
    member(RutaEliminar,RutasSistema),
    getContenido(Sistema,Contenido),
    getContenidoFF(NombreEliminar,Contenido,ContenidoFolder),
    setPapelera(Sistema,ContenidoFolder,NewsistemaPapelera),
    eliminar_file(NombreEliminar,Contenido,NewContenido),
    setContenido(NewsistemaPapelera,NewContenido,Newsistema).



systemCopy(Sistema,NombreCopiar,RutaDestino,Newsistema):-
    split_string(NombreCopiar,".","",Split),
    length(Split,LargoLista),
    LargoLista = 1,
    getContenido(Sistema,Contenido),
    getContenidoFF(NombreCopiar,Contenido,FolderCopy),
    setRutaFolder(FolderCopy,RutaDestino,NewFolderCopy),
    addFolderToContenido(NewFolderCopy,Contenido,NewContenido),
    setContenido(Sistema,NewContenido,NewSistemaContenido),
    string_concat(RutaDestino, NombreCopiar, RutaFolder),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    \+member(RutaFolder,RutasSistema),
    addRutaToRutas(RutaFolder,RutasSistema,NewRutasSistema),
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema),!.

systemCopy(Sistema,NombreCopiar,RutaDestino,Newsistema):-
    split_string(NombreCopiar,".","",Split),
    length(Split,LargoLista),
    LargoLista = 2,
    getContenido(Sistema,Contenido),
    getContenidoFF(NombreCopiar,Contenido,FileCopy),
    addFolderToContenido(FileCopy,Contenido,NewContenido),
    setContenido(Sistema,NewContenido,NewSistemaContenido),
    string_concat(RutaDestino, NombreCopiar, RutaFolder),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    \+member(RutaFolder,RutasSistema),
    addRutaToRutas(RutaFolder,RutasSistema,NewRutasSistema),
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema),!.

systemMove(Sistema,NombreMover,RutaDestino,Newsistema):-
    string(NombreMover),
    string(RutaDestino),
    getContenido(Sistema,Contenido),
    getContenidoFF(NombreMover,Contenido,ContenidoFolder),
    systemCopy(Sistema,NombreMover,RutaDestino,SistemaAux),
    systemDelDos(SistemaAux,NombreMover,NewsistemaAux),
    getRutaFolder(ContenidoFolder,RutaFolderAux),
    string_concat(RutaFolderAux,"/",RutaAux),
    string_concat(RutaAux,NombreMover,RutaFolder),
    getRutasSistema(NewsistemaAux,RutasSistema),
    select(RutaFolder,RutasSistema,NewRutasSistema),
    setRutasSistema(NewsistemaAux,NewRutasSistema,Newsistema).


systemRen(Sistema,Nombre,NuevoNombre,Newsistema):-
    split_string(Nombre,".","",Split),
    length(Split,LargoLista),
    LargoLista = 1,
    getContenido(Sistema,Contenido),
    getContenidoFF(Nombre,Contenido,ContenidoFolder),
    setNombreFolder(ContenidoFolder,NuevoNombre,NewFolder),
    systemDelDos(Sistema,Nombre,NewsistemaAux),
    getContenido(NewsistemaAux,ContenidoAux),
    addFolderToContenido(NewFolder,ContenidoAux,NewContenidoAux),
    setContenido(NewsistemaAux,NewContenidoAux,NewSistemaContenido),
    getRutaFolder(NewFolder,RutaFolder),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaFolder \= RutaRaiz,
    string_concat(RutaFolder,"/",RutaAux),
    string_concat(RutaAux,NuevoNombre,RutaNewFolder),
    string_concat(RutaFolder,"/",RutaEliminarAux),
    string_concat(RutaEliminarAux,Nombre,RutaEliminar),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    select(RutaEliminar,RutasSistema,NewRutasSistemaAux),
    addRutaToRutas(RutaNewFolder,NewRutasSistemaAux,NewRutasSistema),
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema),!.

systemRen(Sistema,Nombre,NuevoNombre,Newsistema):-
    split_string(Nombre,".","",Split),
    length(Split,LargoLista),
    LargoLista = 1,
    getContenido(Sistema,Contenido),
    getContenidoFF(Nombre,Contenido,ContenidoFolder),
    setNombreFolder(ContenidoFolder,NuevoNombre,NewFolder),
    systemDelDos(Sistema,Nombre,NewsistemaAux),
    getContenido(NewsistemaAux,ContenidoAux),
    addFolderToContenido(NewFolder,ContenidoAux,NewContenidoAux),
    setContenido(NewsistemaAux,NewContenidoAux,NewSistemaContenido),
    getRutaFolder(NewFolder,RutaFolder),
    string_concat(RutaFolder,Nombre,RutaFolderEliminar),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaFolder = RutaRaiz,
    string_concat(RutaFolder,NuevoNombre,RutaNewFolder),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    select(RutaFolderEliminar,RutasSistema,NewRutasSistemaAux),
    \+member(RutaNewFolder,RutasSistema),
    addRutaToRutas(RutaNewFolder,NewRutasSistemaAux,NewRutasSistema),
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema),!.


systemRen(Sistema,Nombre,NuevoNombre,Newsistema):-
    split_string(Nombre,".","",Split),
    length(Split,LargoLista),
    LargoLista = 2,
    getContenido(Sistema,Contenido),
    getContenidoFF(Nombre,Contenido,ContenidoFile),
    setNombreFile(ContenidoFile,NuevoNombre,NewFile),
    systemDelDos(Sistema,Nombre,NewsistemaAux),
    getContenido(NewsistemaAux,ContenidoAux),
    addFileToContenido(NewFile,ContenidoAux,NewContenidoAux),
    setContenido(NewsistemaAux,NewContenidoAux,NewSistemaContenido),
    getRutaActual(NewSistemaContenido,RutaActual),
    string_concat(RutaActual,Nombre,RutaEliminar),
    string_concat(RutaActual,NuevoNombre,Newruta),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    select(RutaEliminar,RutasSistema,NewRutasSistemaAux),
    addRutaToRutas(Newruta,NewRutasSistemaAux,NewRutasSistema),
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema),!.

/*systemRen(Sistema,Nombre,NuevoNombre,Newsistema):-
    split_string(Nombre,".","",Split),
    length(Split,LargoLista),
    LargoLista = 2,
    getContenido(Sistema,Contenido),
    getContenidoFF(Nombre,Contenido,ContenidoFolder),
    setNombreFolder(ContenidoFolder,NuevoNombre,NewFolder),
    systemDelDos(Sistema,Nombre,NewsistemaAux),
    getContenido(NewsistemaAux,ContenidoAux),
    addFolderToContenido(NewFolder,ContenidoAux,NewContenidoAux),
    setContenido(NewsistemaAux,NewContenidoAux,NewSistemaContenido),
    getRutaFolder(NewFolder,RutaFolder),
    string_concat(RutaFolder,Nombre,RutaFolderEliminar),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaFolder = RutaRaiz,
    string_concat(RutaFolder,NuevoNombre,RutaNewFolder),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    select(RutaFolderEliminar,RutasSistema,NewRutasSistemaAux),
    \+member(RutaNewFolder,RutasSistema),
    addRutaToRutas(RutaNewFolder,NewRutasSistemaAux,NewRutasSistema),
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema),!.*/





































%MODIFICADORES

% Descripcion: Predicado que actualiza los drives de un sistema
% Dominio: Sistema X UpdateDrives X NewSistema
% Metas Primarias: setDrives
% Metas Secundarias: filesystem
setDrives(Sistema, UpdateDrives, Newsistema) :-
    filesystem(Nombre, _, Contenido, RutasSistema, Usuarios, UsuarioLogeado, DriveActual, RutaActual, Papelera, Sistema),
    filesystem(Nombre, UpdateDrives, Contenido, RutasSistema, Usuarios, UsuarioLogeado, DriveActual, RutaActual, Papelera, Newsistema).

% Descripcion: Predicado que actualiza los usuarios de un sistema
% Dominio: Sistema X UpdateUsers X NewSistema
% Metas Primarias: setUser
% Metas Secundarias: filesystem
setUser(Sistema, UpdateUsers, Newsistema) :-
    filesystem(Nombre, Drives, Contenido, RutasSistema, _, UsuarioLogeado, DriveActual, RutaActual, Papelera, Sistema),
    filesystem(Nombre, Drives, Contenido, RutasSistema, UpdateUsers, UsuarioLogeado, DriveActual, RutaActual, Papelera, Newsistema).

% Descripcion: Predicado que actualiza el usuario logeado en un sistema
% Dominio: Sistema X UpdateUsuarioLogeado X NewSistema
% Metas Primarias: setUsuarioLogeado
% Metas Secundarias: filesystem
setUsuarioLogeado(Sistema, UpdateUsuarioLogeado, Newsistema) :-
    filesystem(Nombre, Drives, Contenido, RutasSistema, Usuarios, _, DriveActual, RutaActual, Papelera, Sistema),
    filesystem(Nombre, Drives, Contenido, RutasSistema, Usuarios, UpdateUsuarioLogeado, DriveActual, RutaActual, Papelera, Newsistema).

% Descripcion: Predicado que actualiza la papelera de un sistema
% Dominio: Sistema X UpdatePapelera X NewSistema
% Metas Primarias: setPapelera
% Metas Secundarias: filesystem
setPapelera(Sistema, UpdatePapelera, Newsistema) :-
    filesystem(Nombre, Drives, Contenido, RutasSistema, Usuarios, UsuarioLogeado, DriveActual, RutaActual, _, Sistema),
    filesystem(Nombre, Drives, Contenido, RutasSistema, Usuarios, UsuarioLogeado, DriveActual, RutaActual, UpdatePapelera, Newsistema).

% Descripcion: Predicado que actualiza el drive actual de un sistema
% Dominio: Sistema X UpdateDriveActual X NewSistema
% Metas Primarias: setDriveActual
% Metas Secundarias: filesystem
setDriveActual(Sistema, DriveActual, Newsistema) :-
    filesystem(Nombre, Drives, Contenido, RutasSistema, Usuarios, UsuarioLogeado, _, RutaActual, Papelera, Sistema),
    filesystem(Nombre, Drives, Contenido, RutasSistema, Usuarios, UsuarioLogeado, DriveActual, RutaActual, Papelera, Newsistema).

% Descripcion: Predicado que actualiza el nombre de un sistema
% Dominio: Sistema X UpdateNombre X NewSistema
% Metas Primarias: setNombre
% Metas Secundarias: filesystem
setNombre(Sistema, UpdateNombre, Newsistema) :-
    filesystem(_, Drives, Contenido, RutasSistema, Usuarios, UsuarioLogeado, DriveActual, RutaActual, Papelera, Sistema),
    filesystem(UpdateNombre, Drives, Contenido, RutasSistema, Usuarios, UsuarioLogeado, DriveActual, RutaActual, Papelera, Newsistema).

% Descripcion: Predicado que actualiza las rutas del sistema
% Dominio: Sistema X UpdateRutasSistema X NewSistema
% Metas Primarias: setRutasSistema
% Metas Secundarias: filesystem
setRutasSistema(Sistema, UpdateRutasSistema, Newsistema) :-
    filesystem(Nombre, Drives, Contenido, _, Usuarios, UsuarioLogeado, DriveActual, RutaActual, Papelera, Sistema),
    filesystem(Nombre, Drives, Contenido, UpdateRutasSistema, Usuarios, UsuarioLogeado, DriveActual, RutaActual, Papelera, Newsistema).

% Descripcion: Predicado que actualiza el contenido de un sistema
% Dominio: Sistema X UpdateContenido X NewSistema
% Metas Primarias: setContenido
% Metas Secundarias: filesystem
setContenido(Sistema, UpdateContenido, Newsistema) :-
    filesystem(Nombre, Drives, _, RutasSistema, Usuarios, UsuarioLogeado, DriveActual, RutaActual, Papelera, Sistema),
    filesystem(Nombre, Drives, UpdateContenido, RutasSistema, Usuarios, UsuarioLogeado, DriveActual, RutaActual, Papelera, Newsistema).

% Descripcion: Predicado que actualiza la ruta actual de un sistema
% Dominio: Sistema X UpdateRutaActual X NewSistema
% Metas Primarias: setRutaActual
% Metas Secundarias: filesystem
setRutaActual(Sistema, UpdateRutaActual, Newsistema) :-
    filesystem(Nombre, Drives, Contenido, RutasSistema, Usuarios, UsuarioLogeado, DriveActual, _, Papelera, Sistema),
    filesystem(Nombre, Drives, Contenido, RutasSistema, Usuarios, UsuarioLogeado, DriveActual, UpdateRutaActual, Papelera, Newsistema).



%SELECTORES


% Descripcion: Predicado que obtiene los drives de un sistema
% Dominio: Sistema X Drives
% Metas Primarias: getDrives
% Metas Secundarias : filesystem
getDrives(Sistema, Drives) :-
    filesystem(_, Drives, _,_,_,_,_,_,_, Sistema).

% Descripcion: Predicado que obtiene los usuarios de un sistema
% Dominio: Sistema X Usuarios
% Metas Primarias: getUsuarios
% Metas Secundarias: filesystem
getUsuarios(Sistema, Usuarios) :-
    filesystem(_, _, _, _, Usuarios, _, _, _, _, Sistema).

% Descripcion: Predicado que obtiene el usuario logeado en un sistema
% Dominio: Sistema X UsuarioLogeado
% Metas Primarias: getUsuarioLogeado
% Metas Secundarias: filesystem
getUsuarioLogeado(Sistema, UsuarioLogeado) :-
    filesystem(_, _, _, _, _, UsuarioLogeado, _, _, _, Sistema).

% Descripcion: Predicado que obtiene la papelera de un sistema
% Dominio: Sistema X Papelera
% Metas Primarias: getPapelera
% Metas Secundarias: filesystem
getPapelera(Sistema, Papelera) :-
    filesystem(_, _, _, _, _, _, Papelera, Sistema).

% Descripcion: Predicado que obtiene el nombre de un sistema
% Dominio: Sistema X Nombre
% Metas Primarias: getNombre
% Metas Secundarias: filesystem
getNombre(Sistema, Nombre) :-
    filesystem(Nombre, _, _, _, _, _, _, _, _, Sistema).

% Descripcion: Predicado que obtiene el contenido de un sistema
% Dominio: Sistema X Contenido
% Metas Primarias: getContenido
% Metas Secundarias: filesystem
getContenido(Sistema, Contenido) :-
    filesystem(_, _, Contenido, _, _, _, _, _, _, Sistema).

% Descripcion: Predicado que obtiene las rutas del sistema
% Dominio: Sistema X RutasSistema
% Metas Primarias: getRutasSistema
% Metas Secundarias: filesystem
getRutasSistema(Sistema, RutasSistema) :-
    filesystem(_, _, _, RutasSistema, _, _, _, _, _, Sistema).

% Descripcion: Predicado que obtiene el drive actual de un sistema
% Dominio: Sistema X DriveActual
% Metas Primarias: getDriveActual
% Metas Secundarias: filesystem
getDriveActual(Sistema, DriveActual) :-
    filesystem(_, _, _, _, _, _, DriveActual, _, _, Sistema).

% Descripcion: Predicado que obtiene la ruta actual de un sistema
% Dominio: Sistema X RutaActual
% Metas Primarias: getRutaActual
% Metas Secundarias: filesystem
getRutaActual(Sistema, RutaActual) :-
    filesystem(_, _, _, _, _, _, _, RutaActual, _, Sistema).










%otras funciones

nombre_Sistema(Nombre,[Nombre,Time]):-
    get_time(Time).

list_to_string(List, String):-
    member(String, List).

string_a_lista(String,[String]).


quitar_cabeza([], []).
quitar_cabeza([_|Cola], Cola).

% si es mayúscula la convierte a minúscula
to_minuscula(Caracter, CaracterMinuscula) :-
    char_code(Caracter, Codigo),
    Codigo >= 65, Codigo =< 90,
    CodigoMinuscula is Codigo + 32,
    char_code(CaracterMinuscula, CodigoMinuscula).

% si no es mayúscula, responde con el mismo caracter
to_minuscula(Caracter, Caracter) :-
    char_code(Caracter, Codigo),
    (Codigo < 65 ; Codigo > 90).

% convierte todos los caracteres de un string a minúsculas y responde el string resultante
string_downcase(Palabra, PalabraMinuscula) :-
    atom_chars(Palabra, ListaCaracteres),
    maplist(to_minuscula, ListaCaracteres, ListaMinuscula),
    atom_chars(PalabraMinuscula, ListaMinuscula).

addRutaToRutas(Ruta,Rutas,NewRutas):-
    append(Rutas,[Ruta],NewRutas).


pertenece(Ruta, Rutas) :-
    atom_string(AtomRuta, Ruta),     % Convertir la ruta dada a un átomo
    member(RutaLista, Rutas),        % Para cada sublista en la lista de rutas...
    atomic_list_concat(RutaLista, '/', AtomRutaLista), % ... combinar sus elementos en un átomo
    AtomRutaLista = AtomRuta.        % ... y comprobar si ese átomo coincide con el dado






eliminar_carpeta(Nombre, Ruta, ListaEntrada, ListaSalida) :-
    eliminar_carpeta_aux(Nombre, Ruta, ListaEntrada, [], ListaSalida).

eliminar_carpeta_aux(_, _, [], Acumulador, Acumulador).
eliminar_carpeta_aux(Nombre, Ruta, [Cabeza|Cola], Acumulador, ListaSalida) :-
    Cabeza = [NombreCarpeta|_],
    last(Cabeza, RutaCarpeta),
    NombreCarpeta = Nombre,
    sub_atom(RutaCarpeta, _, _, _, Ruta),
    eliminar_carpeta_aux(Nombre, Ruta, Cola, Acumulador, ListaSalida).
eliminar_carpeta_aux(Nombre, Ruta, [Cabeza|Cola], Acumulador, ListaSalida) :-
    Cabeza = [NombreCarpeta|_],
    last(Cabeza, RutaCarpeta),
    (NombreCarpeta \= Nombre ; not(sub_atom(RutaCarpeta, _, _, _, Ruta))),
    append(Acumulador, [Cabeza], NuevoAcumulador),
    eliminar_carpeta_aux(Nombre, Ruta, Cola, NuevoAcumulador, ListaSalida).


eliminar_file(Nombre, ListaEntrada, ListaSalida) :-
    eliminar_file_aux(Nombre, ListaEntrada, [], ListaSalida).

eliminar_file_aux(_, [], Acumulador, Acumulador).
eliminar_file_aux(Nombre, [Cabeza|Cola], Acumulador, ListaSalida) :-
    Cabeza = [NombreCarpeta|_],
    NombreCarpeta = Nombre,
    eliminar_file_aux(Nombre, Cola, Acumulador, ListaSalida).
eliminar_file_aux(Nombre, [Cabeza|Cola], Acumulador, ListaSalida) :-
    Cabeza = [NombreCarpeta|_],
    NombreCarpeta \= Nombre,
    append(Acumulador, [Cabeza], NuevoAcumulador),
    eliminar_file_aux(Nombre, Cola, NuevoAcumulador, ListaSalida).







getContenidoFF(Nombre, ListaFolders, FileEncontrado) :-
    getContenidoFF_aux(Nombre, ListaFolders, FileEncontrado).

getContenidoFF_aux(_, [], []).
getContenidoFF_aux(Nombre, [[Nombre|Resto]|_], [Nombre|Resto]).
getContenidoFF_aux(Nombre, [Cabeza|Cola], FileEncontrado) :-
    Cabeza \= [Nombre|_],
    getContenidoFF_aux(Nombre, Cola, FileEncontrado).


% Predicado para convertir un átomo a una cadena de caracteres
atom_to_string(Atom, String) :-
    atom_chars(Atom, CharList),
    string_chars(String, CharList).


systemDelDos(Sistema,NombreEliminar,Newsistema):-
    getRutaActual(Sistema,RutaActual),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaActual = RutaRaiz,
    string_concat(RutaActual,NombreEliminar,RutaEliminar),
    getRutasSistema(Sistema,RutasSistema),
    member(RutaEliminar,RutasSistema),
    getContenido(Sistema,Contenido),
    getContenidoFF(NombreEliminar,Contenido,ContenidoFolder),
    getRutaFolder(ContenidoFolder,RutaFolder),
    eliminar_carpeta(NombreEliminar,RutaFolder,Contenido,NewContenido),
    setContenido(Sistema,NewContenido,Newsistema).

systemDelDos(Sistema,NombreEliminar,Newsistema):-
    getRutaActual(Sistema,RutaActual),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaActual \= RutaRaiz,
    string_concat(RutaActual,"/",RutaAux),
    string_concat(RutaAux,NombreEliminar,RutaEliminar),
    getRutasSistema(Sistema,RutasSistema),
    member(RutaEliminar,RutasSistema),
    getContenido(Sistema,Contenido),
    getContenidoFF(NombreEliminar,Contenido,ContenidoFolder),
    getRutaFolder(ContenidoFolder,RutaFolder),
    eliminar_carpeta(NombreEliminar,RutaFolder,Contenido,NewContenido),
    setContenido(Sistema,NewContenido,Newsistema).


systemDelDos(Sistema,NombreEliminar,Newsistema):-
    getRutaActual(Sistema,RutaActual),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaActual = RutaRaiz,
    string_concat(RutaActual,NombreEliminar,RutaEliminar),
    getRutasSistema(Sistema,RutasSistema),
    member(RutaEliminar,RutasSistema),
    getContenido(Sistema,Contenido),
    eliminar_file(NombreEliminar,Contenido,NewContenido),
    setContenido(Sistema,NewContenido,Newsistema).
