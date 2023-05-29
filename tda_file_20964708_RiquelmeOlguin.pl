:- module(tda_file_20964708_RiquelmeOlguin, [file/6 , addFileToContenido/3]).

file(Nombre,Creador,Fecha_creacion,Fecha_modificacion,Atributos_seguridad,[Nombre,Creador,Fecha_creacion,Fecha_modificacion,Atributos_seguridad]).

addFileToContenido(Newfile,Contenido,UpdateContenido):-
    append(Contenido,[Newfile],UpdateContenido).