:- module(tda_folder_20964708_RiquelmeOlguin, [folder/5 , addFolderToContenido/3]).

folder(Nombre,Creador,Fecha_creacion,Fecha_modificacion,[Nombre,Creador,Fecha_creacion,Fecha_modificacion]).

addFolderToContenido(Newfolder,Contenido,UpdateContenido):-
    append(Contenido,[Newfolder],UpdateContenido).
