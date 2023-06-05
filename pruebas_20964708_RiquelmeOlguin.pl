:- use_module(tda_system_20964708_RiquelmeOlguin, [filesystem/10,
                                               system/2,
                                               systemAddDrive/5,
                                               systemRegister/3, getDrives/2, setDrives/3, getUsuarios/2, setUser/3, systemLogin/3,
                                               systemLogout/2,systemSwitchDrive/3 ,systemMkdir/3, systemCd/3,systemAddFile/3,
                                               systemDel/3,getRutaActual/2,getContenidoFF/3]).

:- use_module(tda_drive_20964708_RiquelmeOlguin, [drive/4, addDriveToDrives/3]).
:- use_module(tda_user_20964708_RiquelmeOlguin, [user/2, addUserToUsers/3]).
:- use_module(tda_folder_20964708_RiquelmeOlguin, [folder/6 , addFolderToContenido/3,setRutaFolder/3,getRutaFolder/2, setNombreFolder/3 ,getNombreFolder/2,getFechaCreacionFolder/2,
                        getFechaModificacionFolder/2]).
:- use_module(tda_file_20964708_RiquelmeOlguin, [file/3 , addFileToContenido/3, getNombreFile/2 , getContenidoFile/2]).





% Caso que debe retornar true:
% Creando un sistema, con el disco C, dos usuarios: �user1� y �user2�,
% se hace login con �user1�, se utiliza el disco �C�, se crea la carpeta �folder1�,
% �folder2�, se cambia al directorio actual �folder1�,
% se crea la carpeta �folder11� dentro de �folder1�,
% se hace logout del usuario �user1�, se hace login con �user2�,
% se crea el archivo �foo.txt� dentro de �folder1�, se acceder a la carpeta c:/folder2,
% se crea el archivo �ejemplo.txt� dentro de c:/folder2

/*system("newSystem", S1),
    systemAddDrive(S1, "C", "OS", 10000000000, S2),
    systemRegister(S2, "user1", S3),
    systemRegister(S3, "user2", S4),
    systemLogin(S4, "user1", S5),
    systemSwitchDrive(S5, "C", S6),
    systemMkdir(S6, "folder1", S7),
    systemMkdir(S7, "folder2", S8),
    systemCd(S8, "folder1", S9),
    systemMkdir(S9, "folder11", S10),
    systemLogout(S10, S11),
    systemLogin(S11, "user2", S12),
    file( �foo.txt�, �hello world�, F1),
    systemAddFile(S12, F1, S13),
    systemCd(S13, "/folder2�, S14),
    file( "ejemplo.txt", "otro archivo", F2),
    systemAddFile(S14, F2, S15).

*/


% Casos que deben retornar false:
% si se intenta a�adir una unidad con una letra que ya existe
%system("newSystem", S1), systemRegister(S1, "user1", S2), systemRegister(S2, "user1", S3).

% si se intenta hacer login con otra sesi�n ya iniciada por este usuario u otro
%system("newSystem", S1), systemRegister(S1, "user1", S2), systemRegister(S2, "user2", S3), systemLogin(S3, "user1", S4), systemLogin(S4, "user2", S5).

% si se intenta usar una unidad inexistente
% system ("newSystem", S1), systemRegister(S1, "user1", S2),
% systemLogin(S2, "user1", S3), systemSwitchDrive(S3, "K", S4).

