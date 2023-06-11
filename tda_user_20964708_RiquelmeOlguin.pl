:- module(tda_user_20964708_RiquelmeOlguin, [user/2, addUserToUsers/3]).

user(Nombre, [Nombre]).

addUserToUsers(NewUser, Usuarios, UpdateUsers) :-
    append(Usuarios, [NewUser], UpdateUsers).


%SELECTORES
getNombreUser(User, Nombre) :-
    user(Nombre, User).

%MODIFICADORES
setNombreUser(User, UpdateNombre, NewUser) :-
    user(_, User),
    user(UpdateNombre, NewUser).

