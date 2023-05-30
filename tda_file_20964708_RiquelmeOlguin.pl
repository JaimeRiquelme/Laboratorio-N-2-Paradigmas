:- module(tda_file_20964708_RiquelmeOlguin, [file/3 , addFileToContenido/3, getNombreFile/2]).

file(Nombre,Contenido,[Nombre,Contenido]).

addFileToContenido(Newfile,Contenido,UpdateContenido):-
    append(Contenido,[Newfile],UpdateContenido).


getNombreFile(File, Nombre) :-
    file(Nombre,_,File).


