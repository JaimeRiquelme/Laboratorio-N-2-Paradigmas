:- module(tda_file_20964708_RiquelmeOlguin, [file/3 , addFileToContenido/3, getNombreFile/2, getContenidoFile/2 , setNombreFile/3]).

%------------- Constructor ----------------
% Descripcion: Predicado que define la estructura de un archivo con su nombre y contenido.
% Dominio: Nombre X Contenido X Archivo
% Metas Primarias: string
file(Nombre, Contenido, [Nombre, Contenido]) :-
    string(Nombre).

% SELECTORES

% Descripcion: Predicado que obtiene el nombre de un archivo.
% Dominio: Archivo X Nombre
% Metas Primarias: file
getNombreFile(File, Nombre) :-
    file(Nombre, _, File).

% Descripcion: Predicado que obtiene el contenido de un archivo.
% Dominio: Archivo X Contenido
% Metas Primarias: file
getContenidoFile(File, Contenido) :-
    file(_, Contenido, File).


% MODIFICADORES

% Descripcion: Predicado que actualiza el nombre de un archivo.
% Dominio: Archivo X NuevoNombre X NuevoArchivo
% Metas Primarias: file
% Metas Secundarias: setNombreFile
setNombreFile(File, UpdateNombre, NewFile) :-
    file(_, Contenido, File),
    file(UpdateNombre, Contenido, NewFile).

% Descripcion: Predicado que actualiza el contenido de un archivo.
% Dominio: Archivo X NuevoContenido X NuevoArchivo
% Metas Primarias: file
% Metas Secundarias: setContenidoFile
setContenidoFile(File, UpdateContenido, NewFile) :-
    file(Nombre, _, File),
    file(Nombre, UpdateContenido, NewFile).





% Descripcion: Predicado que agrega un archivo a una lista de contenido.
% Dominio: Archivo X ListaContenido X NuevaListaContenido
% Metas Primarias: addFileToContenido
% Metas Secundarias: string
addFileToContenido(File, [], [File]).

% Descripcion: Predicado que reemplaza un archivo existente por uno nuevo en una lista de contenido.
% Dominio: Archivo X ListaContenido X NuevaListaContenido
% Metas Primarias: addFileToContenido
% Metas Secundarias: string
addFileToContenido([Nombre | RestoNuevo], [[Nombre | _] | Resto], [[Nombre | RestoNuevo] | Resto]).

% Descripcion: Predicado que agrega un archivo al final de una lista de contenido.
% Dominio: Archivo X ListaContenido X NuevaListaContenido
% Metas Primarias: addFileToContenido
% Metas Secundarias: string
addFileToContenido(File, [Cabeza | Cola], [Cabeza | NuevoContenido]) :-
    File \= Cabeza,
    addFileToContenido(File, Cola, NuevoContenido).



