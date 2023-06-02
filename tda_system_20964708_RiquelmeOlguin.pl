:- module(tda_system_20964708_RiquelmeOlguin, [filesystem/10,
                                               system/2,
                                               systemAddDrive/5,
                                               systemRegister/3, getDrives/2, setDrives/3, getUsuarios/2, setUser/3, systemLogin/3,
                                               systemLogout/2,systemSwitchDrive/3 ,systemMkdir/3, systemCd/3,systemAddFile/3,
                                               systemDel/3]).

:- use_module(tda_drive_20964708_RiquelmeOlguin, [drive/4, addDriveToDrives/3]).
:- use_module(tda_user_20964708_RiquelmeOlguin, [user/2, addUserToUsers/3]).
:- use_module(tda_folder_20964708_RiquelmeOlguin, [folder/5 , addFolderToContenido/3]).
:- use_module(tda_file_20964708_RiquelmeOlguin, [file/3 , addFileToContenido/3, getNombreFile/2]).


filesystem(Nombre, Drives,Contenido,RutasSistema, Usuarios,UsuarioLogeado,DriveActual,RutaActual,Papelera, [Nombre, Drives, Contenido, RutasSistema, Usuarios,UsuarioLogeado,DriveActual,RutaActual,Papelera]).

system(NombreSistema, Sistema) :-
    string(NombreSistema),
    nombre_Sistema(NombreSistema,Nombre),
    filesystem(Nombre, [],[],[],[],[],[],[],[], Sistema).

systemAddDrive(Sistema, Letra, Nombre, Capacidad, Newsistema) :-
    drive(Letra, Nombre, Capacidad, NewDrive),
    getDrives(Sistema, Drives),
    \+ member([Letra, _, _], Drives), % Verifica que la letra no est� presente en Drives
    addDriveToDrives(NewDrive, Drives, UpdateDrives),
    setDrives(Sistema, UpdateDrives, Newsistema).

systemRegister(Sistema, NombreUser, Sistema) :-
    getUsuarios(Sistema, Usuarios),
    user(NombreUser,NewUser),
    member(NewUser, Usuarios), !.

systemRegister(Sistema, NombreUser, Newsistema) :-
    user(NombreUser, NewUser),
    string_a_lista(NewUser,UserList),
    getUsuarios(Sistema, Usuarios),
    \+ member(UserList, Usuarios), % Verifica que el usuario no está presente en Usuarios
    addUserToUsers(NewUser, Usuarios, UpdateUsers),
    setUser(Sistema, UpdateUsers, Newsistema).




systemLogin(Sistema, NombreUser, Newsistema) :-
    getUsuarioLogeado(Sistema, UsuarioLogeado),
    UsuarioLogeado = [], % Verifica si la lista est� vac�a
    user(NombreUser, NewUser),
    getUsuarios(Sistema, Usuarios),
    member(NewUser, Usuarios),
    setUsuarioLogeado(Sistema, NewUser, Newsistema).


systemLogout(Sistema,Newsistema):-
    getUsuarioLogeado(Sistema,UsuarioLogeado),
    \+ UsuarioLogeado = [],
    setUsuarioLogeado(Sistema,[],Newsistema).


systemSwitchDrive(Sistema,Letra,Newsistema):-
    getUsuarioLogeado(Sistema,UsuarioLogeado),
    list_to_string(UsuarioLogeado,User),
    \+ systemLogin(Sistema,User,Newsistema),
    getDrives(Sistema,Drives),
    member([Letra, _, _], Drives),
    setDriveActual(Sistema,Letra,NewsistemaDrive),
    string_concat(Letra,":/",RutaRaiz),
    setRutaActual(NewsistemaDrive,RutaRaiz,Newsistema).


systemMkdir(Sistema,Nombre,Newsistema):-
    getUsuarioLogeado(Sistema,UsuarioLogeado),
    get_time(Time),
    folder(Nombre,UsuarioLogeado,Time,Time,Newfile),
    getContenido(Sistema,Contenido),
    addFolderToContenido(Newfile,Contenido,NewContenido),
    setContenido(Sistema,NewContenido,NewSistemaContenido),
    getRutaActual(NewSistemaContenido,RutaActual),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaActual = RutaRaiz,
    string_concat(RutaActual, Nombre, RutaFolder),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    addRutaToRutas(RutaFolder,RutasSistema,NewRutasSistema),
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema),!.

systemMkdir(Sistema,Nombre,Newsistema):-
    getUsuarioLogeado(Sistema,UsuarioLogeado),
    get_time(Time),
    folder(Nombre,UsuarioLogeado,Time,Time,Newfile),
    getContenido(Sistema,Contenido),
    addFolderToContenido(Newfile,Contenido,NewContenido),
    setContenido(Sistema,NewContenido,NewSistemaContenido),
    getRutaActual(NewSistemaContenido,RutaActual),
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    RutaActual \= RutaRaiz,
    string_concat(RutaActual, "/", TempRuta),
    string_concat(TempRuta, Nombre, RutaFolder),
    getRutasSistema(NewSistemaContenido,RutasSistema),
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

systemCd(Sistema, Nombre, Newsistema):-
    getDriveActual(Sistema,DriveActual),
    string_concat(DriveActual,":/",RutaRaiz),
    getRutaActual(Sistema,RutaActual),
    RutaRaiz = RutaActual,
    string_concat(RutaActual,Nombre,Newruta),
    setRutaActual(Sistema,Newruta,Newsistema),!.


systemCd(Sistema,Nombre,Newsistema):-
    \+ Nombre = "..",
    \+ Nombre = "/",
    sub_atom(Nombre, 0, 1, _, '/'),
    getRutaActual(Sistema,RutaActual),
    string_concat(RutaActual,Nombre,Newruta),
    setRutaActual(Sistema,Newruta,Newsistema),!.

systemCd(Sistema,Nombre,Newsistema):-
    \+ Nombre = "..",
    \+ Nombre = "/",
    \+ sub_atom(Nombre, 0, 1, _, '/'),
    getRutaActual(Sistema,RutaActual),
    string_concat(RutaActual,"/",Ruta1),
    string_concat(Ruta1,Nombre,Newruta),
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
    string_concat(RutaActual, Nombre, RutaFolder),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    addRutaToRutas(RutaFolder,RutasSistema,NewRutasSistema),
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
    string_concat(TempRuta, Nombre, RutaFolder),
    getRutasSistema(NewSistemaContenido,RutasSistema),
    addRutaToRutas(RutaFolder,RutasSistema,NewRutasSistema),
    setRutasSistema(NewSistemaContenido,NewRutasSistema,Newsistema).


systemDel(Sistema,NombreEliminar,Newsistema):-
    getRutaActual(Sistema,RutaActual),
    string_concat(RutaActual,"/",RutaAux),
    string_concat(RutaAux,NombreEliminar,RutaEliminar),
    getRutasSistema(Sistema,RutasSistema),
    member(RutaEliminar,RutasSistema),
    getContenido(Sistema,Contenido),
    getContenidoFolder(NombreEliminar,Contenido,ContenidoFolder),
    setPapelera(Sistema,ContenidoFolder,NewsistemaPapelera),
    eliminar_carpeta(NombreEliminar,Contenido,NewContenido),
    setContenido(NewsistemaPapelera,NewContenido,Newsistema).


























%SELECTORES Y MODIFICADORES

getDrives(Sistema, Drives) :-
    filesystem(_, Drives, _,_,_,_,_,_,_, Sistema).

setDrives(Sistema, UpdateDrives, Newsistema) :-
    filesystem(Nombre, _,Contenido,RutasSistema, Usuarios,UsuarioLogeado,DriveActual,RutaActual,Papelera, Sistema),
    filesystem(Nombre, UpdateDrives,Contenido,RutasSistema, Usuarios,UsuarioLogeado,DriveActual,RutaActual,Papelera, Newsistema).

getUsuarios(Sistema, Usuarios) :-
    filesystem(_, _,_,_, Usuarios,_,_,_,_, Sistema).

setUser(Sistema, UpdateUsers, Newsistema) :-
    filesystem(Nombre, Drives,Contenido,RutasSistema, _,UsuarioLogeado,DriveActual,RutaActual,Papelera, Sistema),
    filesystem(Nombre, Drives,Contenido,RutasSistema, UpdateUsers,UsuarioLogeado,DriveActual,RutaActual,Papelera, Newsistema).

getUsuarioLogeado(Sistema, UsuarioLogeado) :-
    filesystem(_, _, _,_,_, UsuarioLogeado, _,_,_, Sistema).

setUsuarioLogeado(Sistema, UpdateUsuarioLogeado, Newsistema) :-
    filesystem(Nombre, Drives,Contenido,RutasSistema, Usuarios, _,DriveActual, RutaActual,Papelera, Sistema),
    filesystem(Nombre, Drives,Contenido,RutasSistema, Usuarios, UpdateUsuarioLogeado,DriveActual,RutaActual, Papelera, Newsistema).

getPapelera(Sistema, Papelera) :-
    filesystem(_, _, _, _,_,_, Papelera, Sistema).

setPapelera(Sistema, UpdatePapelera, Newsistema) :-
    filesystem(Nombre, Drives,Contenido,RutasSistema, Usuarios, UsuarioLogeado,DriveActual,RutaActual, _, Sistema),
    filesystem(Nombre, Drives,Contenido,RutasSistema, Usuarios, UsuarioLogeado,DriveActual,RutaActual, UpdatePapelera, Newsistema).

setDriveActual(Sistema,DriveActual,Newsistema):-
    filesystem(Nombre, Drives,Contenido,RutasSistema, Usuarios, UsuarioLogeado,_,RutaActual,Papelera, Sistema),
    filesystem(Nombre, Drives,Contenido,RutasSistema, Usuarios, UsuarioLogeado,DriveActual,RutaActual, Papelera, Newsistema).

getNombre(Sistema, Nombre) :-
    filesystem(Nombre, _, _,_,_,_,_,_,_, Sistema).

setNombre(Sistema, UpdateNombre, Newsistema) :-
    filesystem(_, Drives,Contenido,RutasSistema, Usuarios,UsuarioLogeado,DriveActual,RutaActual,Papelera, Sistema),
    filesystem(UpdateNombre, Drives,Contenido,RutasSistema, Usuarios,UsuarioLogeado,DriveActual,RutaActual,Papelera, Newsistema).

getContenido(Sistema, Contenido) :-
    filesystem(_, _, Contenido,_,_,_,_,_,_, Sistema).

setContenido(Sistema, UpdateContenido, Newsistema) :-
    filesystem(Nombre, Drives,_,RutasSistema, Usuarios,UsuarioLogeado,DriveActual,RutaActual,Papelera, Sistema),
    filesystem(Nombre, Drives,UpdateContenido,RutasSistema, Usuarios,UsuarioLogeado,DriveActual,RutaActual,Papelera, Newsistema).

getRutasSistema(Sistema, RutasSistema) :-
    filesystem(_, _, _, RutasSistema,_,_,_,_,_, Sistema).

setRutasSistema(Sistema, UpdateRutasSistema, Newsistema) :-
    filesystem(Nombre, Drives,Contenido,_, Usuarios,UsuarioLogeado,DriveActual,RutaActual,Papelera, Sistema),
    filesystem(Nombre, Drives,Contenido,UpdateRutasSistema, Usuarios,UsuarioLogeado,DriveActual,RutaActual,Papelera, Newsistema).

getDriveActual(Sistema, DriveActual) :-
    filesystem(_, _, _,_,_,_, DriveActual, _,_, Sistema).

getRutaActual(Sistema, RutaActual) :-
    filesystem(_, _, _,_,_,_,_, RutaActual,_, Sistema).

setRutaActual(Sistema, UpdateRutaActual, Newsistema) :-
    filesystem(Nombre, Drives,Contenido,RutasSistema, Usuarios,UsuarioLogeado,DriveActual,_,Papelera, Sistema),
    filesystem(Nombre, Drives,Contenido,RutasSistema, Usuarios,UsuarioLogeado,DriveActual,UpdateRutaActual,Papelera, Newsistema).








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






eliminar_carpeta(Nombre, ListaEntrada, ListaSalida) :-
    eliminar_carpeta_aux(Nombre, ListaEntrada, [], ListaSalida).

eliminar_carpeta_aux(_, [], Acumulador, Acumulador).
eliminar_carpeta_aux(Nombre, [[Nombre|_]|Cola], Acumulador, ListaSalida) :-
    eliminar_carpeta_aux(Nombre, Cola, Acumulador, ListaSalida).
eliminar_carpeta_aux(Nombre, [Cabeza|Cola], Acumulador, ListaSalida) :-
    Cabeza \= [Nombre|_],
    append(Acumulador, [Cabeza], NuevoAcumulador),
    eliminar_carpeta_aux(Nombre, Cola, NuevoAcumulador, ListaSalida).




getContenidoFolder(Nombre, ListaFolders, FileEncontrado) :-
    getContenidoFolder_aux(Nombre, ListaFolders, FileEncontrado).

getContenidoFolder_aux(_, [], []).
getContenidoFolder_aux(Nombre, [[Nombre|Resto]|_], [Nombre|Resto]).
getContenidoFolder_aux(Nombre, [Cabeza|Cola], FileEncontrado) :-
    Cabeza \= [Nombre|_],
    getContenidoFolder_aux(Nombre, Cola, FileEncontrado).
