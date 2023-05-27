:- module(tda_user_20964708_RiquelmeOlguin, [user/2, addUserToUsers/3]).

user(Nombre, [Nombre]).

addUserToUsers(NewUser, Usuarios, UpdateUsers) :-
    append(Usuarios, [NewUser], UpdateUsers).
