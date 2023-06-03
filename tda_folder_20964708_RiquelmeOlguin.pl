:- module(tda_folder_20964708_RiquelmeOlguin, [folder/6 , addFolderToContenido/3, setRutaFolder/3,getRutaFolder/2]).

folder(Nombre,Creador,Fecha_creacion,Fecha_modificacion,Ruta,[Nombre,Creador,Fecha_creacion,Fecha_modificacion,Ruta]).

addFolderToContenido(Newfolder,Contenido,UpdateContenido):-
    append(Contenido,[Newfolder],UpdateContenido).

%SELECTORES

getNombre(Folder, Nombre) :-
    folder(Nombre, _, _, _, _, Folder).

getCreador(Folder, Creador) :-
    folder(_, Creador, _, _, _, Folder).

getFechaCreacion(Folder, Fecha_creacion) :-
    folder(_, _, Fecha_creacion, _, _, Folder).

getFechaModificacion(Folder, Fecha_modificacion) :-
    folder(_, _, _, Fecha_modificacion, _, Folder).

getRutaFolder(Folder, Ruta) :-
    folder(_, _, _, _, Ruta, Folder).

%MODIFICADORES

setNombre(Folder, UpdateNombre, NewFolder) :-
    folder(_, Creador, Fecha_creacion, Fecha_modificacion, Ruta, Folder),
    folder(UpdateNombre, Creador, Fecha_creacion, Fecha_modificacion, Ruta, NewFolder).

setCreador(Folder, UpdateCreador, NewFolder) :-
    folder(Nombre, _, Fecha_creacion, Fecha_modificacion, Ruta, Folder),
    folder(Nombre, UpdateCreador, Fecha_creacion, Fecha_modificacion, Ruta, NewFolder).

setFechaCreacion(Folder, UpdateFechaCreacion, NewFolder) :-
    folder(Nombre, Creador, _, Fecha_modificacion, Ruta, Folder),
    folder(Nombre, Creador, UpdateFechaCreacion, Fecha_modificacion, Ruta, NewFolder).

setFechaModificacion(Folder, UpdateFechaModificacion, NewFolder) :-
    folder(Nombre, Creador, Fecha_creacion, _, Ruta, Folder),
    folder(Nombre, Creador, Fecha_creacion, UpdateFechaModificacion, Ruta, NewFolder).

setRutaFolder(Folder, UpdateRuta, NewFolder) :-
    folder(Nombre, Creador, Fecha_creacion, Fecha_modificacion, _, Folder),
    folder(Nombre, Creador, Fecha_creacion, Fecha_modificacion, UpdateRuta, NewFolder).


