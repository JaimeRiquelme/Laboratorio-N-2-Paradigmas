:- module(tda_file_20964708_RiquelmeOlguin, [file/3 , addFileToContenido/3, getNombreFile/2]).

file(Nombre,Contenido,[Nombre,Contenido]).

% Si la lista está vacía, simplemente agrega el archivo.
addFileToContenido(File, [], [File]).

% Si el archivo ya existe en la lista (es decir, el nombre es el mismo),
% reemplázalo por el nuevo archivo.
addFileToContenido([Nombre|RestoNuevo], [[Nombre|_]|Resto], [[Nombre|RestoNuevo]|Resto]).


% Si el archivo no está en la cabeza de la lista, comprueba el resto de la lista.
addFileToContenido(File, [Cabeza|Cola], [Cabeza|NuevoContenido]) :-
    File \= Cabeza,
    addFileToContenido(File, Cola, NuevoContenido).



getNombreFile(File, Nombre) :-
    file(Nombre,_,File).


