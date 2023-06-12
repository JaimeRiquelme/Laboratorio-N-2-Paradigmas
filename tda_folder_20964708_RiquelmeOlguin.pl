:- module(tda_folder_20964708_RiquelmeOlguin, [folder/6 , addFolderToContenido/3, setRutaFolder/3,getRutaFolder/2, setNombreFolder/3 ,getNombreFolder/2,getFechaCreacionFolder/2,
                        getFechaModificacionFolder/2]).



% ---------------------- Constructor ------------------
% Descripcion: Predicado que representa una carpeta.
% Dominio: Nombre X Creador X Fecha_creacion X Fecha_modificacion X Ruta X Carpeta
% Metas Primarias: string
% Metas Secundarias: folder
folder(Nombre, Creador, Fecha_creacion, Fecha_modificacion, Ruta, [Nombre, Creador, Fecha_creacion, Fecha_modificacion, Ruta]) :-
    string(Nombre).




%SELECTORES

% Descripcion: Predicado que obtiene el nombre de una carpeta.
% Dominio: Carpeta X Nombre
% Metas Primarias: folder
% Metas Secundarias: getNombreFolder
getNombreFolder(Folder, Nombre) :-
    folder(Nombre, _, _, _, _, Folder).

% Descripcion: Predicado que obtiene el creador de una carpeta.
% Dominio: Carpeta X Creador
% Metas Primarias: folder
% Metas Secundarias: getCreadorFolder
getCreadorFolder(Folder, Creador) :-
    folder(_, Creador, _, _, _, Folder).

% Descripcion: Predicado que obtiene la fecha de creación de una carpeta.
% Dominio: Carpeta X Fecha_creacion
% Metas Primarias: folder
% Metas Secundarias: getFechaCreacionFolder
getFechaCreacionFolder(Folder, Fecha_creacion) :-
    folder(_, _, Fecha_creacion, _, _, Folder).

% Descripcion: Predicado que obtiene la fecha de modificación de una carpeta.
% Dominio: Carpeta X Fecha_modificacion
% Metas Primarias: folder
% Metas Secundarias: getFechaModificacionFolder
getFechaModificacionFolder(Folder, Fecha_modificacion) :-
    folder(_, _, _, Fecha_modificacion, _, Folder).

% Descripcion: Predicado que obtiene la ruta de una carpeta.
% Dominio: Carpeta X Ruta
% Metas Primarias: folder
% Metas Secundarias: getRutaFolder
getRutaFolder(Folder, Ruta) :-
    folder(_, _, _, _, Ruta, Folder).


%MODIFICADORES

% Descripcion: Predicado que establece el nombre de una carpeta.
% Dominio: Carpeta X Nombre X NuevaCarpeta
% Metas Primarias: folder
% Metas Secundarias: setNombreFolder
setNombreFolder(Folder, UpdateNombre, NewFolder) :-
    folder(_, Creador, Fecha_creacion, Fecha_modificacion, Ruta, Folder),
    folder(UpdateNombre, Creador, Fecha_creacion, Fecha_modificacion, Ruta, NewFolder).

% Descripcion: Predicado que establece el creador de una carpeta.
% Dominio: Carpeta X Creador X NuevaCarpeta
% Metas Primarias: folder
% Metas Secundarias: setCreadorFolder
setCreadorFolder(Folder, UpdateCreador, NewFolder) :-
    folder(Nombre, _, Fecha_creacion, Fecha_modificacion, Ruta, Folder),
    folder(Nombre, UpdateCreador, Fecha_creacion, Fecha_modificacion, Ruta, NewFolder).

% Descripcion: Predicado que establece la fecha de creación de una carpeta.
% Dominio: Carpeta X Fecha_creacion X NuevaCarpeta
% Metas Primarias: folder
% Metas Secundarias: setFechaCreacionFolder
setFechaCreacionFolder(Folder, UpdateFechaCreacion, NewFolder) :-
    folder(Nombre, Creador, _, Fecha_modificacion, Ruta, Folder),
    folder(Nombre, Creador, UpdateFechaCreacion, Fecha_modificacion, Ruta, NewFolder).

% Descripcion: Predicado que establece la fecha de modificación de una carpeta.
% Dominio: Carpeta X Fecha_modificacion X NuevaCarpeta
% Metas Primarias: folder
% Metas Secundarias: setFechaModificacionFolder
setFechaModificacionFolder(Folder, UpdateFechaModificacion, NewFolder) :-
    folder(Nombre, Creador, Fecha_creacion, _, Ruta, Folder),
    folder(Nombre, Creador, Fecha_creacion, UpdateFechaModificacion, Ruta, NewFolder).

% Descripcion: Predicado que establece la ruta de una carpeta.
% Dominio: Carpeta X Ruta X NuevaCarpeta
% Metas Primarias: folder
% Metas Secundarias: setRutaFolder
setRutaFolder(Folder, UpdateRuta, NewFolder) :-
    folder(Nombre, Creador, Fecha_creacion, Fecha_modificacion, _, Folder),
    folder(Nombre, Creador, Fecha_creacion, Fecha_modificacion, UpdateRuta, NewFolder).



% Otras funciones


% Descripcion: Predicado que agrega una carpeta al contenido.
% Dominio: Carpeta X Contenido X Contenido
% Metas Primarias: append
% Metas Secundarias: -
addFolderToContenido(Newfolder, Contenido, UpdateContenido) :-
    append(Contenido, [Newfolder], UpdateContenido).
