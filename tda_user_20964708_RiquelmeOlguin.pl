:- module(tda_user_20964708_RiquelmeOlguin, [user/2, addUserToUsers/3]).


%-------------Constructor------------

% Descripcion: Predicado que representa a un usuario.
% Dominio: Nombre X Usuario
% Metas Primarias: User
% Metas Secundarias: -
user(Nombre, [Nombre]).





%SELECTORES
% Descripcion: Predicado que obtiene el nombre de un usuario.
% Dominio: Usuario X Nombre
% Metas Primarias: getNombreUser
% Metas Secundarias: user

getNombreUser(User, Nombre) :-
    user(Nombre, User).


%MODIFICADORES
% Descripcion: Predicado que actualiza el nombre de un usuario.
% Dominio: Usuario X NuevoNombre X NuevoUsuario
% Metas Primarias: setNombreUser
% Metas Secundarias: user

setNombreUser(User, UpdateNombre, NewUser) :-
    user(_, User),
    user(UpdateNombre, NewUser).




% --------------Otras funciones------------------

% Descripcion: Predicado que agrega un usuario a una lista de usuarios.
% Dominio: Usuario X ListaUsuarios X ListaUsuarios
% Metas Primarias: addUserToUsers
% Metas Secundarias: -

addUserToUsers(NewUser, Usuarios, UpdateUsers) :-
    append(Usuarios, [NewUser], UpdateUsers).

