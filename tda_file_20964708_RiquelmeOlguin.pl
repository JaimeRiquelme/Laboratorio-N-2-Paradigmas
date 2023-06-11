:- module(tda_file_20964708_RiquelmeOlguin, [file/3 , addFileToContenido/3, getNombreFile/2, getContenidoFile/2]).

file(Nombre,Contenido,[Nombre,Contenido]):-
    string(Nombre).

% Si la lista está vacía, simplemente agrega el archivo.
addFileToContenido(File, [], [File]).

% Si el archivo ya existe en la lista (es decir, el nombre es el mismo),
% reemplázalo por el nuevo archivo.
addFileToContenido([Nombre|RestoNuevo], [[Nombre|_]|Resto], [[Nombre|RestoNuevo]|Resto]).


% Si el archivo no está en la cabeza de la lista, comprueba el resto de la lista.
addFileToContenido(File, [Cabeza|Cola], [Cabeza|NuevoContenido]) :-
    File \= Cabeza,
    addFileToContenido(File, Cola, NuevoContenido).


% SELECTORES

getNombreFile(File, Nombre) :-
    file(Nombre, _, File).

getContenidoFile(File, Contenido) :-
    file(_, Contenido, File).

% MODIFICADORES

setNombreFile(File, UpdateNombre, NewFile) :-
    file(_, Contenido, File),
    file(UpdateNombre, Contenido, NewFile).

setContenidoFile(File, UpdateContenido, NewFile) :-
    file(Nombre, _, File),
    file(Nombre, UpdateContenido, NewFile).


