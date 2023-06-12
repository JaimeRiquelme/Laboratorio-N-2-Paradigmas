:- module(tda_system_20964708_RiquelmeOlguin, [filesystem/10,
                                               system/2,
                                               systemAddDrive/5,
                                               systemRegister/3, getDrives/2, setDrives/3, getUsuarios/2, setUser/3, systemLogin/3,
                                               systemLogout/2,systemSwitchDrive/3 ,systemMkdir/3, systemCd/3,systemAddFile/3,
                                               systemDel/3, getRutaActual/2,getContenidoFF/3,systemCopy/4 , systemMove/4 ,
                                               systemRen/4, systemDir/3]).

:- use_module(tda_drive_20964708_RiquelmeOlguin, [drive/4, addDriveToDrives/3, setNombreDrive/3]).
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



% Descripcion: Predicado que realiza el inicio de sesión de un usuario en un sistema.
% Dominio: Sistema X NombreUser X NewSistema
% Metas Primarias: systemLogin
% Metas Secundarias: getUsuarioLogeado, user, getUsuarios, member, setUsuarioLogeado
systemLogin(Sistema, NombreUser, Newsistema) :-
    getUsuarioLogeado(Sistema, UsuarioLogeado),
    UsuarioLogeado = [], % Verifica que no haya un usuario logeado previamente
    user(NombreUser, NewUser),
    getUsuarios(Sistema, Usuarios),
    member(NewUser, Usuarios),
    setUsuarioLogeado(Sistema, NewUser, Newsistema),!.

% Descripcion: Predicado que verifica si el usuario que se intenta logear es el mismo que el actual.
% Dominio: Sistema X NombreUser X NewSistema
% Metas Primarias: systemLogin
% Metas Secundarias: getUsuarioLogeado, list_to_string, user, getUsuarios, member, setUsuarioLogeado
systemLogin(Sistema, NombreUser, Newsistema) :-
    getUsuarioLogeado(Sistema, UsuarioLogeado),
    list_to_string(UsuarioLogeado, UserLog),
    UserLog = NombreUser, % Verifica que el usuario logeado sea igual a NombreUser
    user(NombreUser, NewUser),
    getUsuarios(Sistema, Usuarios),
    member(NewUser, Usuarios),
    setUsuarioLogeado(Sistema, NewUser, Newsistema),!.


% Descripcion: Predicado que realiza el cierre de sesión en un sistema.
% Dominio: Sistema X NewSistema
% Metas Primarias: systemLogout
% Metas Secundarias: getUsuarioLogeado, setUsuarioLogeado
systemLogout(Sistema, Newsistema) :-
    getUsuarioLogeado(Sistema, UsuarioLogeado),
    \+ UsuarioLogeado = [], % Verifica que haya un usuario logeado previamente
    setUsuarioLogeado(Sistema, [], Newsistema).



% Descripcion: Predicado que cambia el drive actual en un sistema.
% Dominio: Sistema X Letra X NewSistema
% Metas Primarias: systemSwitchDrive
% Metas Secundarias: getUsuarioLogeado, list_to_string, systemLogin, getDrives, member, setDriveActual, string_concat, setRutaActual
systemSwitchDrive(Sistema, Letra, Newsistema) :-
    getUsuarioLogeado(Sistema, UsuarioLogeado),
    list_to_string(UsuarioLogeado, User),
    systemLogin(Sistema, User, LoggedInSistema),
    Sistema == LoggedInSistema, % Continuar solo si systemLogin devolvió el mismo sistema (usuario ya logeado)
    getDrives(Sistema, Drives),
    member([Letra, _, _], Drives),
    setDriveActual(Sistema, Letra, NewsistemaDrive),
    string_concat(Letra, ":/", RutaRaiz),
    setRutaActual(NewsistemaDrive, RutaRaiz, Newsistema).




% Descripcion: Predicado que crea un nuevo directorio en el sistema actual.
% Dominio: Sistema X Nombre X NewSistema
% Metas Primarias: systemMkdir
% Metas Secundarias: getUsuarioLogeado, get_time, getRutaActual, folder, getContenido, addFolderToContenido, setContenido, getDriveActual, string_concat, getRutasSistema, member, addRutaToRutas, setRutasSistema
systemMkdir(Sistema, Nombre, Newsistema) :-
    getUsuarioLogeado(Sistema, UsuarioLogeado),
    UsuarioLogeado \= [],
    get_time(Time),
    getRutaActual(NewSistemaContenido, RutaActual),
    folder(Nombre, UsuarioLogeado, Time, Time, RutaActual, Newfile),
    getContenido(Sistema, Contenido),
    addFolderToContenido(Newfile, Contenido, NewContenido),
    setContenido(Sistema, NewContenido, NewSistemaContenido),
    getDriveActual(Sistema, DriveActual),
    string_concat(DriveActual, ":/", RutaRaiz),
    RutaActual = RutaRaiz,
    string_concat(RutaActual, Nombre, RutaFolder),
    getRutasSistema(NewSistemaContenido, RutasSistema),
    \+ member(RutaFolder, RutasSistema),
    addRutaToRutas(RutaFolder, RutasSistema, NewRutasSistema),
    setRutasSistema(NewSistemaContenido, NewRutasSistema, Newsistema),!.

% Descripcion: Predicado que crea un nuevo directorio en una subruta del sistema actual.
% Dominio: Sistema X Nombre X NewSistema
% Metas Primarias: systemMkdir
% Metas Secundarias: getUsuarioLogeado, get_time, getRutaActual, folder, getContenido, addFolderToContenido, setContenido, getDriveActual, string_concat, getRutasSistema, member, addRutaToRutas, setRutasSistema
systemMkdir(Sistema, Nombre, Newsistema) :-
    getUsuarioLogeado(Sistema, UsuarioLogeado),
    UsuarioLogeado \= [],
    get_time(Time),
    getRutaActual(NewSistemaContenido, RutaActual),
    folder(Nombre, UsuarioLogeado, Time, Time, RutaActual, Newfile),
    getContenido(Sistema, Contenido),
    addFolderToContenido(Newfile, Contenido, NewContenido),
    setContenido(Sistema, NewContenido, NewSistemaContenido),
    getDriveActual(Sistema, DriveActual),
    string_concat(DriveActual, ":/", RutaRaiz),
    RutaActual \= RutaRaiz,
    string_concat(RutaActual, "/", TempRuta),
    string_concat(TempRuta, Nombre, RutaFolder),
    getRutasSistema(NewSistemaContenido, RutasSistema),
    \+ member(RutaFolder, RutasSistema),
    addRutaToRutas(RutaFolder, RutasSistema, NewRutasSistema),
    setRutasSistema(NewSistemaContenido, NewRutasSistema, Newsistema),!.




% Descripcion: Predicado que cambia el directorio actual del sistema a la raíz.
% Dominio: Sistema X Nombre X NewSistema
% Metas Primarias: systemCd
% Metas Secundarias: =, getDriveActual, string_concat, setRutaActual
systemCd(Sistema, Nombre, Newsistema):-
    Nombre = "/",
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    setRutaActual(Sistema,RutaRaiz,Newsistema),!.

% Descripcion: Predicado que cambia el directorio actual del sistema al directorio padre.
% Dominio: Sistema X Nombre X NewSistema
% Metas Primarias: systemCd
% Metas Secundarias: getRutaActual, split_string, reverse, quitar_cabeza, atomic_list_concat, setRutaActual
systemCd(Sistema, Nombre, Newsistema):-
    getRutaActual(Sistema,RutaActual),
    Nombre = "..",
    split_string(RutaActual,"/","",Split),
    reverse(Split,ReverseSplit),
    quitar_cabeza(ReverseSplit,ColaPath),
    reverse(ColaPath,Reverse2),
    atomic_list_concat(Reverse2,"/",Newpath),
    setRutaActual(Sistema,Newpath,Newsistema),!.

% Descripcion: Predicado que cambia el directorio actual del sistema.
% Dominio: Sistema X Nombre X Sistema
% Metas Primarias: systemCd
% Metas Secundarias: sub_atom
systemCd(Sistema, Nombre, Sistema):-
    sub_atom(Nombre, 0, 1, _, '.'), !. % Si el Nombre comienza con ".", el sistema permanece sin cambios

% Descripcion: Predicado que cambia el directorio actual del sistema a una ruta absoluta.
% Dominio: Sistema X Nombre X NewSistema
% Metas Primarias: systemCd
% Metas Secundarias: sub_atom, getDriveActual, string_concat, getRutaActual, getRutasSistema, member, setRutaActual
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

% Descripcion: Predicado que cambia el directorio actual del sistema a una ruta relativa.
% Dominio: Sistema X Nombre X NewSistema
% Metas Primarias: systemCd
% Metas Secundarias: sub_atom, getDriveActual, string_concat, getRutaActual, getRutasSistema, member, setRutaActual
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

% Descripcion: Predicado que cambia el directorio actual del sistema a un directorio hijo.
% Dominio: Sistema X Nombre X NewSistema
% Metas Primarias: systemCd
% Metas Secundarias: sub_atom, getRutaActual, string_concat, setRutaActual
systemCd(Sistema,Nombre,Newsistema):-
    \+ Nombre = "..",
    \+ Nombre = "/",
    sub_atom(Nombre, 0, 1, _, '/'), % Rama para cuando Nombre comienza con "/"
    getRutaActual(Sistema,RutaActual),
    string_concat(RutaActual,Nombre,Newruta),
    setRutaActual(Sistema,Newruta,Newsistema),!.

% Descripcion: Predicado que cambia el directorio actual del sistema a un directorio hijo.
% Dominio: Sistema X Nombre X NewSistema
% Metas Primarias: systemCd
% Metas Secundarias: \+, getRutaActual, string_concat, setRutaActual
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



% Descripcion: Predicado que agrega un archivo al sistema.
% Dominio: Sistema X File X NewSistema
% Metas Primarias: systemAddFile
% Metas Secundarias: getContenido, addFileToContenido, setContenido, getDriveActual, string_concat, getRutaActual, getNombreFile, getRutasSistema, member, addRutaToRutas, setRutasSistema
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

% Descripcion: Predicado que agrega un archivo al sistema en una subruta.
% Dominio: Sistema X File X NewSistema
% Metas Primarias: systemAddFile
% Metas Secundarias: getContenido, addFileToContenido, setContenido, getDriveActual, string_concat, getRutaActual, getNombreFile, getRutasSistema, member, addRutaToRutas, setRutasSistema
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
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema),!.



% Descripcion: Predicado que elimina un archivo o carpeta del sistema.
% Dominio: Sistema X NombreEliminar X NewSistema
% Metas Primarias: systemDel
% Metas Secundarias: getRutaActual, getDriveActual, string_concat, =, getRutasSistema, member, getContenido, getContenidoFF, setPapelera, getRutaFolder, eliminar_carpeta, setContenido
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
    setContenido(NewsistemaPapelera,NewContenido,Newsistema),!.

% Descripcion: Predicado que elimina un archivo o carpeta del sistema en una subruta.
% Dominio: Sistema X NombreEliminar X NewSistema
% Metas Primarias: systemDel
% Metas Secundarias: getRutaActual, getDriveActual, string_concat, \=, string_concat, member, getContenido, getContenidoFF, setPapelera, getRutaFolder, eliminar_carpeta, setContenido
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
    setContenido(NewsistemaPapelera,NewContenido,Newsistema),!.

% Descripcion: Predicado que elimina un archivo del sistema.
% Dominio: Sistema X NombreEliminar X NewSistema
% Metas Primarias: systemDel
% Metas Secundarias: getRutaActual, getDriveActual, string_concat, \=, string_concat, member, getContenido, getContenidoFF, setPapelera, eliminar_file, setContenido
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
    setContenido(NewsistemaPapelera,NewContenido,Newsistema),!.




% Descripcion: Predicado que realiza la copia de un archivo o carpeta en el sistema.
% Dominio: Sistema X NombreCopiar X RutaDestino X NewSistema
% Metas Primarias: systemCopy
% Metas Secundarias: split_string, length, getContenido, getContenidoFF, setRutaFolder, addFolderToContenido, setContenido, string_concat, getRutasSistema, \+member, addRutaToRutas, setRutasSistema
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

% Descripcion: Predicado que realiza la copia de un archivo en el sistema.
% Dominio: Sistema X NombreCopiar X RutaDestino X NewSistema
% Metas Primarias: systemCopy
% Metas Secundarias: split_string, length, getContenido, getContenidoFF, addFolderToContenido, setContenido, string_concat, getRutasSistema, \+member, addRutaToRutas, setRutasSistema
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

% Descripcion: Predicado que mueve un archivo o carpeta a una nueva ruta en el sistema.
% Dominio: Sistema X NombreMover X RutaDestino X NewSistema
% Metas Primarias: systemMove
% Metas Secundarias: string, getContenido, getContenidoFF, systemCopy, systemDelDos, getRutaFolder, string_concat, getRutasSistema, select, setRutasSistema
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



% Descripcion: Predicado que realiza la renombración de un archivo o carpeta en el sistema.
% Dominio: Sistema X Nombre X NuevoNombre X NewSistema
% Metas Primarias: systemRen
% Metas Secundarias: split_string, length, getContenido, getContenidoFF, setNombreFolder, systemDelDos, getContenido, addFolderToContenido, setContenido, getRutaFolder, getDriveActual, string_concat, getRutasSistema, select, addRutaToRutas, setRutasSistema
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

% Descripcion: Predicado que realiza la renombración de un archivo en el sistema.
% Dominio: Sistema X Nombre X NuevoNombre X NewSistema
% Metas Primarias: systemRen
% Metas Secundarias: split_string, length, getContenido, getContenidoFF, setNombreFolder, systemDelDos, getContenido, addFolderToContenido, setContenido, getRutaFolder, string_concat, getRutasSistema, select, \+member, addRutaToRutas, setRutasSistema
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

% Descripcion: Predicado que realiza la renombración de un archivo en el sistema.
% Dominio: Sistema X Nombre X NuevoNombre X NewSistema
% Metas Primarias: systemRen
% Metas Secundarias: split_string, length, getContenido, getContenidoFF, setNombreFile, systemDelDos, getContenido, addFileToContenido, setContenido, getRutaActual, string_concat, getRutasSistema, select, addRutaToRutas, setRutasSistema
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



% Descripcion: Predicado que obtiene el contenido de un directorio en formato de lista de cadenas.
% Dominio: Sistema X Lista X Cadena
% Metas Primarias: systemDir
% Metas Secundarias: getContenido, getRutaActual, systemDir_aux

systemDir(Sistema, [], Str) :-
    getContenido(Sistema, Contenido),
    getRutaActual(Sistema, RutaActual),
    systemDir_aux(Contenido, RutaActual, "", Str),!.



% Descripcion: Predicado que formatea una unidad en el sistema.
% Dominio: Sistema X Letra X Nombre X Sistema
% Metas Primarias: systemFormat
% Metas Secundarias: getDrives,getContenidoDrive,setNombreDrive,eliminar_drive,addDriveToDrives,setDrives,getContenido,eliminarFoldersPorRuta
%                   setContenido,getRutasSistema,eliminarPath,setRutasSistema.

systemFormat(Sistema, Letra, NuevoNombre, Newsistema) :-
    string(NuevoNombre),
    getDrives(Sistema, ContenidoDrives), % obtener todos los drives del sistema
    getContenidoDrive(Letra, ContenidoDrives, ContenidoD), % obtener el contenido de un drive específico
    setNombreDrive(ContenidoD, NuevoNombre, NewDrive), % cambiar el nombre del drive
    eliminar_drive(Letra, ContenidoDrives, NewContenido), % eliminar el drive antiguo del sistema
    addDriveToDrives(NewDrive, NewContenido, NewDrivesContenido), % agregar el nuevo drive al sistema
    setDrives(Sistema, NewDrivesContenido, NewsistemaAux),
    getContenido(NewsistemaAux,ContenidoAux),
    eliminarFoldersPorRuta(Letra,ContenidoAux,ContenidoNew),
    setContenido(NewsistemaAux,ContenidoNew,SistemaAux),
    getRutasSistema(SistemaAux,RutasSistema),
    eliminarPath(Letra,RutasSistema,NewRutasSistema),
    setRutasSistema(SistemaAux,NewRutasSistema,Newsistema),!.



















% -------------------------------- MODIFICADORES Y SELECTORES------------------------------------------



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










% ---------------------------------------OTRAS FUNCIONES -------------------------------------------------

% Descripcion: Predicado que registra el nombre de un sistema junto con el tiempo actual.
% Dominio: Nombre X Time X [Nombre, Time]
% Metas Primarias: nombre_Sistema
% Metas Secundarias: get_time
nombre_Sistema(Nombre,[Nombre,Time]):-
    get_time(Time).

% Descripcion: Predicado que convierte una lista en un string, donde el string es un miembro de la lista.
% Dominio: Lista X String
% Metas Primarias: list_to_string
% Metas Secundarias: member
list_to_string(List, String):-
    member(String, List).

% Descripcion: Predicado que convierte un string en una lista que contiene ese string.
% Dominio: String X [String]
% Metas Primarias: string_a_lista
% Metas Secundarias: N/A
string_a_lista(String,[String]).

% Descripcion: Predicado que quita la cabeza (el primer elemento) de una lista.
% Dominio: [Cabeza|Cola] X [Cola]
% Metas Primarias: quitar_cabeza
% Metas Secundarias: N/A
quitar_cabeza([], []).
quitar_cabeza([_|Cola], Cola).



% Descripcion: Predicado que agrega una nueva ruta al final de una lista de rutas existentes.
% Dominio: Ruta X Rutas X NewRutas
% Metas Primarias: addRutaToRutas
% Metas Secundarias: append
addRutaToRutas(Ruta,Rutas,NewRutas):-
    append(Rutas,[Ruta],NewRutas).


% Descripcion: Predicado que verifica si una ruta específica pertenece a una lista de rutas.
% Dominio: Ruta X Rutas
% Metas Primarias: pertenece
% Metas Secundarias: atom_string, member, atomic_list_concat
pertenece(Ruta, Rutas) :-
    atom_string(AtomRuta, Ruta),     
    member(RutaLista, Rutas),        
    atomic_list_concat(RutaLista, '/', AtomRutaLista), 
    AtomRutaLista = AtomRuta.       



% Descripcion: Predicado que elimina una carpeta específica de una lista de carpetas.
% Dominio: Nombre X Ruta X ListaEntrada X ListaSalida
% Metas Primarias: eliminar_carpeta
% Metas Secundarias: eliminar_carpeta_aux
eliminar_carpeta(Nombre, Ruta, ListaEntrada, ListaSalida) :-
    eliminar_carpeta_aux(Nombre, Ruta, ListaEntrada, [], ListaSalida).

% Descripcion: Predicado auxiliar que ayuda a eliminar una carpeta específica de una lista de carpetas.
% Dominio: Nombre X Ruta X [[NombreCarpeta,_,_,_,RutaCarpeta]|Cola] X Acumulador X ListaSalida
% Metas Primarias: eliminar_carpeta_aux
% Metas Secundarias: sub_atom, append
eliminar_carpeta_aux(_, _, [], Acumulador, Acumulador).
eliminar_carpeta_aux(Nombre, Ruta, [[NombreCarpeta,_,_,_,RutaCarpeta]|Cola], Acumulador, ListaSalida) :-
    NombreCarpeta = Nombre,
    sub_atom(RutaCarpeta, _, _, _, Ruta),
    eliminar_carpeta_aux(Nombre, Ruta, Cola, Acumulador, ListaSalida).
eliminar_carpeta_aux(Nombre, Ruta, [Cabeza|Cola], Acumulador, ListaSalida) :-
    Cabeza = [NombreCarpeta,_,_,_,RutaCarpeta],
    (NombreCarpeta \= Nombre ; \+ sub_atom(RutaCarpeta, _, _, _, Ruta)),
    append(Acumulador, [Cabeza], NuevoAcumulador),
    eliminar_carpeta_aux(Nombre, Ruta, Cola, NuevoAcumulador, ListaSalida).



% Descripcion: Predicado que elimina un archivo específico de una lista de archivos.
% Dominio: Nombre X ListaEntrada X ListaSalida
% Metas Primarias: eliminar_file
% Metas Secundarias: eliminar_file_aux
eliminar_file(Nombre, ListaEntrada, ListaSalida) :-
    eliminar_file_aux(Nombre, ListaEntrada, [], ListaSalida).


    

% Descripcion: Predicado auxiliar que ayuda a eliminar un archivo específico de una lista de archivos.
% Dominio: Nombre X [Cabeza|Cola] X Acumulador X ListaSalida
% Metas Primarias: eliminar_file_aux
% Metas Secundarias: append
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






% Descripcion: Predicado que obtiene el contenido de un archivo o carpeta específica de una lista de carpetas y archivos.
% Dominio: Nombre X ListaFolders X FileEncontrado
% Metas Primarias: getContenidoFF
% Metas Secundarias: getContenidoFF_aux
getContenidoFF(Nombre, ListaFolders, FileEncontrado) :-
    getContenidoFF_aux(Nombre, ListaFolders, FileEncontrado).

% Descripcion: Predicado auxiliar que ayuda a obtener el contenido de un archivo o carpeta específica de una lista de carpetas y archivos.
% Dominio: Nombre X [[Nombre|Resto]|_] X [Nombre|Resto]
% Metas Primarias: getContenidoFF_aux
% Metas Secundarias: N/A
getContenidoFF_aux(_, [], []).
getContenidoFF_aux(Nombre, [[Nombre|Resto]|_], [Nombre|Resto]).
getContenidoFF_aux(Nombre, [Cabeza|Cola], FileEncontrado) :-
    Cabeza \= [Nombre|_],
    getContenidoFF_aux(Nombre, Cola, FileEncontrado).


% Descripcion: Predicado que convierte un átomo en una cadena de caracteres.
% Dominio: Atom X String
% Metas Primarias: atom_to_string
% Metas Secundarias: atom_chars, string_chars
atom_to_string(Atom, String) :-
    atom_chars(Atom, CharList),
    string_chars(String, CharList).



% Descripcion: Predicado que elimina una carpeta o archivo del sistema. 
%              Esta versión se encarga de la eliminación cuando la carpeta está en la ruta raíz.
% Dominio: Sistema X NombreEliminar X Newsistema
% Metas Primarias: systemDelDos
% Metas Secundarias: getRutaActual, getDriveActual, string_concat, getRutasSistema, member, getContenido,
%                    getContenidoFF, getRutaFolder, eliminar_carpeta, setContenido
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



% Descripcion: Predicado que elimina una carpeta del sistema.
%              Esta versión se encarga de la eliminación cuando la carpeta no está en la ruta raíz.
% Dominio: Sistema X NombreEliminar X Newsistema
% Metas Primarias: systemDelDos
% Metas Secundarias: getRutaActual, getDriveActual, string_concat, getRutasSistema, member, getContenido,
%                    getContenidoFF, getRutaFolder, eliminar_carpeta, setContenido
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




% Descripcion: Predicado que elimina un archivo del sistema.
%              Esta versión se encarga de la eliminación cuando el archivo está en la ruta raíz.
% Dominio: Sistema X NombreEliminar X Newsistema
% Metas Primarias: systemDelDos
% Metas Secundarias: getRutaActual, getDriveActual, string_concat, getRutasSistema, member, getContenido,
%                    eliminar_file, setContenido
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




% Descripcion: Predicado auxiliar que genera una lista de los nombres de archivos y carpetas en la ruta actual.
% Dominio: Lista X RutaActual X StrAcc X Str
% Metas Primarias: systemDir_aux
% Metas Secundarias: atom_concat
% Caso base: la lista está vacía.
systemDir_aux([], _, StrAcc, StrAcc).

% Caso cuando la última entrada de la lista coincide con la ruta actual.
systemDir_aux([[Nombre,_,_,_,Ruta]|Resto], RutaActual, StrAcc, Str) :-
    Ruta = RutaActual, !,
    atom_concat(StrAcc, Nombre, StrAccNew),
    atom_concat(StrAccNew, "\n", StrAccUpdated),
    systemDir_aux(Resto, RutaActual, StrAccUpdated, Str).

% Caso cuando la última entrada de la lista no coincide con la ruta actual.
systemDir_aux([_|Resto], RutaActual, StrAcc, Str) :-
    systemDir_aux(Resto, RutaActual, StrAcc, Str).




% Descripcion: Predicado principal que obtiene el contenido de un drive específico.
% Dominio: Letra X ListaDrives X DriveEncontrado
% Metas Primarias: getContenidoDrive
% Metas Secundarias: getContenidoDrive_aux
getContenidoDrive(Letra, ListaDrives, DriveEncontrado) :-
    getContenidoDrive_aux(Letra, ListaDrives, DriveEncontrado).

% Descripcion: Predicado auxiliar que busca un drive en la lista de drives.
% Dominio: Letra X ListaDrives X DriveEncontrado
% Metas Primarias: getContenidoDrive_aux
getContenidoDrive_aux(_, [], []).
getContenidoDrive_aux(Letra, [[Letra|Resto]|_], [Letra|Resto]).
getContenidoDrive_aux(Letra, [Cabeza|Cola], DriveEncontrado) :-
    Cabeza \= [Letra|_],
    getContenidoDrive_aux(Letra, Cola, DriveEncontrado).





% Descripcion: Predicado principal que elimina un drive específico de una lista de drives.
% Dominio: Letra X ListaEntrada X ListaSalida
% Metas Primarias: eliminar_drive
% Metas Secundarias: eliminar_drive_aux
eliminar_drive(Letra, ListaEntrada, ListaSalida) :-
    eliminar_drive_aux(Letra, ListaEntrada, [], ListaSalida).

% Descripcion: Predicado auxiliar que elimina el drive especificado de la lista de drives.
% Dominio: Letra X Lista X Acumulador X ListaSalida
% Metas Primarias: eliminar_drive_aux
% Metas Secundarias: append
eliminar_drive_aux(_, [], Acumulador, Acumulador).
eliminar_drive_aux(Letra, [[LetraDrive|_]|Cola], Acumulador, ListaSalida) :-
    LetraDrive = Letra,
    eliminar_drive_aux(Letra, Cola, Acumulador, ListaSalida).
eliminar_drive_aux(Letra, [Cabeza|Cola], Acumulador, ListaSalida) :-
    Cabeza \= [Letra|_],
    append(Acumulador, [Cabeza], NuevoAcumulador),
    eliminar_drive_aux(Letra, Cola, NuevoAcumulador, ListaSalida).



% Descripcion: Predicado principal que elimina todas las rutas que comienzan con una letra específica de una lista de rutas.
% Dominio: Letra X ListaEntrada X ListaSalida
% Metas Primarias: eliminarPath
% Metas Secundarias: eliminarPath_aux
eliminarPath(Letra, ListaEntrada, ListaSalida) :-
    eliminarPath_aux(Letra, ListaEntrada, [], ListaSalida).

% Descripcion: Predicado auxiliar que elimina las rutas que comienzan con la letra especificada de la lista de rutas.
% Dominio: Letra X Lista X Acumulador X ListaSalida
% Metas Primarias: eliminarPath_aux
% Metas Secundarias: append, sub_string
eliminarPath_aux(_, [], Acumulador, Acumulador).
eliminarPath_aux(Letra, [Cabeza|Cola], Acumulador, ListaSalida) :-
    sub_string(Cabeza, 0, 1, _, LetraInicial),
    LetraInicial \= Letra,
    append(Acumulador, [Cabeza], NuevoAcumulador),
    eliminarPath_aux(Letra, Cola, NuevoAcumulador, ListaSalida).
eliminarPath_aux(Letra, [_|Cola], Acumulador, ListaSalida) :-
    eliminarPath_aux(Letra, Cola, Acumulador, ListaSalida).




% Descripcion: Predicado principal que elimina todos los folders cuya ruta comienza con una letra específica de una lista de folders.
% Dominio: Letra X ListaEntrada X ListaSalida
% Metas Primarias: eliminarFoldersPorRuta
% Metas Secundarias: eliminarFoldersPorRuta_aux
eliminarFoldersPorRuta(Letra, ListaEntrada, ListaSalida) :-
    eliminarFoldersPorRuta_aux(Letra, ListaEntrada, [], ListaSalida).

% Descripcion: Predicado auxiliar que elimina los folders cuya ruta comienza con la letra especificada de la lista de folders.
% Dominio: Letra X Lista X Acumulador X ListaSalida
% Metas Primarias: eliminarFoldersPorRuta_aux
% Metas Secundarias: append, sub_string, last
eliminarFoldersPorRuta_aux(_, [], Acumulador, Acumulador).
eliminarFoldersPorRuta_aux(Letra, [Cabeza|Cola], Acumulador, ListaSalida) :-
    last(Cabeza, Ruta),
    sub_string(Ruta, 0, 1, _, LetraInicial),
    LetraInicial \= Letra,
    append(Acumulador, [Cabeza], NuevoAcumulador),
    eliminarFoldersPorRuta_aux(Letra, Cola, NuevoAcumulador, ListaSalida).
eliminarFoldersPorRuta_aux(Letra, [_|Cola], Acumulador, ListaSalida) :-
    eliminarFoldersPorRuta_aux(Letra, Cola, Acumulador, ListaSalida).


