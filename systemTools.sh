#!/bin/bash
 

alta()
{
    clear
    read -p "Ingresar Nombre de Usuario: " nomX
    nom=$(echo $nomX | tr -d ' ')
    found=$(grep "$nom"":" /etc/shadow | awk -F ':' '{print $1}')

    if [ "$nom" = "" ]
    then
        clear
        echo " ! - El nombre de usuario no puede estar en blanco. |"
        echo "____________________________________________________|"
        echo
        return
    fi

    if [ "$nom" = "$found" ]
    then
        clear
        echo "   ! - El nombre de usuario ingresado ya existe.   |"
        echo "___________________________________________________|"
        echo
        return
    fi

    read -sp "Ingresar Contraseña: " pas
    clear

    while [ 1 ]
    do
        echo "Seleccione un grupo por defecto: "
        echo "1- Administrador"
        echo "2- Médico"
        echo

        read -p "Opción: " op

        case $op in
            1)
                gr="administrador"
                di="/home/usuarios/administrador/$nom"
                break
                ;;
            2)
                gr="medico"
                di="/home/usuarios/medico/$nom"
                break
                ;;
            *)
                clear
                echo "               ! - Opción no existente.             |"
                echo "____________________________________________________|"
                echo
                ;;
        esac
    done


    mkdir "$di"
    useradd -NM $nom
    echo -e "$pas\n$pas" | passwd $nom >/dev/null 2>&1
    usermod -g $gr $nom
    usermod -d $di $nom

    clear
    echo "Usuario ingresado con éxito."
    read -p "Presionar cualquier tecla para continuar..." -n1 -s
    clear
}

baja()
{
    clear
    read -p "Ingresar Nombre de Usuario a Eliminar: " nomX
    nom=$(echo $nomX | tr -d ' ')
    found=$(grep "$nom"":" /etc/shadow | awk -F ':' '{print $1}')

    if [ "$nom" = "" ]
    then
        clear
        echo " ! - El nombre de usuario no puede estar en blanco. |"
        echo "____________________________________________________|"
        echo
        return
    fi

    if [ "$nom" != "$found" ]
    then
        clear
        echo "   ! - El nombre de usuario ingresado no existe.   |"
        echo "___________________________________________________|"
        echo
        return
    fi

    clear
    while [ 1 ]
    do
        echo "¿Desea eliminar al usuario $nom permanentemente?"
        echo
        echo "1 - Sí"
        echo "2 - No"
        echo

        read -p "Opción: " op
        clear

        if [ "$op" = "1" ]
        then
            userdel $nom
            clear
            echo "Usuario eliminado con éxito."
            read -p "Presionar cualquier tecla para continuar..." -n1 -s
            clear
            return
        else
            if [ "$op" = "2" ]
            then
                return
            fi

            clear
            echo "               ! - Opción no existente.             |"
            echo "____________________________________________________|"
            echo

        fi
    done
    }

mod()
{
    clear
    while [ 1 ]
    do
        echo ABM De Usuarios y Grupos
        echo 
        echo Qué desea modificar?
        echo 1- Nombre del Usuario
        echo 2- Contraseña del Usuario
        echo 3- Asignar Grupo a Usuario
        echo 4- Cambiar Directorio de Usuario
        echo 0- Salir
        echo

        read -p "Opción: " op
        case $op in

        1)
            clear
            read -p "Ingresar Nombre de Usuario a Modificar: " nomX
            nom=$(echo $nomX | tr -d ' ')
            found=$(grep "$nom"":" /etc/shadow | awk -F ':' '{print $1}')

            if [ "$nom" = "" ]
            then
                clear
                echo " ! - El nombre de usuario no puede estar en blanco. |"
                echo "____________________________________________________|"
                echo
                return
            fi

            if [ "$found" = "" ]
            then
                clear
                echo "         ! - El usuario buscado no existe.          |"
                echo "____________________________________________________|"
                echo
                return
            fi

            read -p "Ingresar Nuevo Nombre de Usuario: " newNomX
            newNom=$(echo $newNomX | tr -d ' ')
            found=$(grep "$newNom"":" /etc/shadow | awk -F ':' '{print $1}')

            if [ "$newNom" = "" ]
            then
                clear
                echo " ! - El nombre de usuario no puede estar en blanco. |"
                echo "____________________________________________________|"
                echo
                return
            fi

            if [ "$found" != "" ]
            then
                clear
                echo "         ! - El nombre ingresado ya existe.         |"
                echo "____________________________________________________|"
                echo
                return
            fi

            usermod -l $newNom $nom
            clear
            echo "Usuario renombrado con éxito."
            read -p "Presionar cualquier tecla para continuar..." -n1 -s
            clear
            return
            ;;

        2)
            clear
            read -p "Ingresar Nombre de Usuario a Modificar: " nomX
            nom=$(echo $nomX | tr -d ' ')
            found=$(grep "$nom"":" /etc/shadow | awk -F ':' '{print $1}')

            if [ "$nom" = "" ]
            then
                clear
                echo " ! - El nombre de usuario no puede estar en blanco. |"
                echo "____________________________________________________|"
                echo
                return
            fi

            if [ "$found" = "" ]
            then
                clear
                echo "         ! - El usuario buscado no existe.          |"
                echo "____________________________________________________|"
                echo
                return
            fi

            read -sp "Ingresar Nueva Contraseña: " pas
            echo -e "$pas\n$pas" | passwd $nom
            clear
            echo "Contraseña cambiada con éxito."
            read -p "Presionar cualquier tecla para continuar..." -n1 -s
            clear
            return
            ;;

        3)
            clear
            read -p "Ingresar Nombre de Usuario a Asignar: " nomX
            nom=$(echo $nomX | tr -d ' ')
            found=$(grep "$nom"":" /etc/shadow | awk -F ':' '{print $1}')

            if [ "$nom" = "" ]
            then
                clear
                echo " ! - El nombre de usuario no puede estar en blanco. |"
                echo "____________________________________________________|"
                echo
                return
            fi

            if [ "$found" = "" ]
            then
                clear
                echo "         ! - El usuario buscado no existe.          |"
                echo "____________________________________________________|"
                echo
                return
            fi

            read -p "Ingresar Nombre de Grupo: " grX
            gr=$(echo $grX | tr -d ' ')
            found=$(grep "$gr"":" /etc/group | awk -F ':' '{print $1}')

            if [ "$found" = "" ]
            then
                clear
                echo "     ! - El nombre de grupo ingresado no existe.    |"
                echo "____________________________________________________|"
            return
            fi
            if [ "$gr" = "" ]
            then
                clear
                echo "  ! - El nombre de grupo no puede estar en blanco.  |"
                echo "____________________________________________________|"
                return
            fi

            while [ 1 ]
                do

                    echo "  Asignar grupo como: "
                    echo 
                    echo "  1- Primario"
                    echo "  2- Secundario"
                    echo "  0- Cancelar"
                    echo 

                    read -p "Opcion: " tipoGrupo

                    case $tipoGrupo in
                        0)
                            clear
                            mod
                        ;;

                        1)
                            usermod -g $gr $nom
                            usermod -md /home/usuarios/$gr/$nom $nom
                            clear
                            echo "Grupo primario cambiado con éxito."
                            read -p "Presionar cualquier tecla para continuar..." -n1 -s
                            clear
                            return
                        ;;

                        2)
                            usermod -G $gr $nom
                            clear
                            echo "Grupo secundario asignado con éxito"
                            pause
                            clear
                            return
                        ;;
                    esac
                done
            ;;

        4)
            clear
            read -p "Ingresar Nombre de Usuario a Asignar: " nomX
            nom=$(echo $nomX | tr -d ' ')
            found=$(grep "$nom"":" /etc/shadow | awk -F ':' '{print $1}')

            if [ "$nom" = "" ]
            then
                clear
                echo " ! - El nombre de usuario no puede estar en blanco. |"
                echo "____________________________________________________|"
                echo
                return
            fi

            if [ "$found" = "" ]
            then
                clear
                echo "         ! - El usuario buscado no existe.          |"
                echo "____________________________________________________|"
                echo
                return
            fi

            read -p "Ingresar Ruta del Directorio Nuevo: " di

            if [ "$di" = "" ]
            then
                clear
                echo " ! - El nombre de directorio no puede estar en blanco. |"
                echo "_______________________________________________________|"
                echo
                return
            fi

            usermod -md $di $nom
            clear
            echo "Directorio cambiado con éxito."
            read -p "Presionar cualquier tecla para continuar..." -n1 -s
            clear
            return
            ;;

        0)
            clear
            return
        ;;

        *)
            clear
            echo "               ! - Opción no existente.             |"
            echo "____________________________________________________|"
            echo
            return
            ;;

        esac
    done
    }

altgr()
{
    clear
    read -p "Ingresar Nombre de Grupo: " grX
    gr=$(echo $grX | tr -d ' ')
    found=$(grep "$gr"":" /etc/group | awk -F ':' '{print $1}')
    if [ "$gr" = "" ]
    then
        clear
        echo "  ! - El nombre de grupo no puede estar en blanco.  |"
        echo "____________________________________________________|"
        return
    fi
    if [ "$found" != "" ]
    then
        clear
        echo "    ! - El nombre de grupo ingresado ya existe.    |"
        echo "___________________________________________________|"
        echo
        return
    fi
    groupadd $gr
    mkdir "/home/usuarios/$gr"
    clear
    echo "Grupo creado con éxito."
    read -p "Presionar cualquier tecla para continuar..." -n1 -s
    clear
}

modgr()
{
    clear
    read -p "Ingresar Nombre de Grupo a Modificar: " grX
    gr=$(echo $grX | tr -d ' ')
    found=$(grep "$gr"":" /etc/group | awk -F ':' '{print $1}')
    if [ "$gr" = "" ]
    then
        clear
        echo "  ! - El nombre de grupo no puede estar en blanco.  |"
        echo "____________________________________________________|"
        return
    fi
    if [ "$found" = "" ]
    then
        clear
        echo "    ! - El nombre de grupo ingresado no existe.    |"
        echo "___________________________________________________|"
        echo
        return
    fi
    read -p "Ingresar Nuevo Nombre de Grupo: " newGrX
    newGr=$(echo $newGrX | tr -d ' ')
    found=$(grep "$newGr"":" /etc/group | awk -F ':' '{print $1}')
    if [ "$newGr" = "" ]
    then
        clear
        echo "  ! - El nombre de grupo no puede estar en blanco.  |"
        echo "____________________________________________________|"
        return
    fi
    if [ "$newGr" = "$found" ]
    then
        clear
        echo "    ! - El nombre de grupo ingresado ya existe.    |"
        echo "___________________________________________________|"
        echo
        return
    fi

    groupmod -n $newGr $gr

    echo "Grupo modificado con éxito."
    read -p "Presionar cualquier tecla para continuar..." -n1 -s
    clear
}

bajgr()
{
    clear
    read -p "Ingresar Nombre de Grupo a Eliminar: " grX
    gr=$(echo $grX | tr -d ' ')
    found=$(grep "$gr"":" /etc/group | awk -F ':' '{print $1}')

    if [ "$gr" = "" ]
    then
        clear
        echo "  ! - El nombre de grupo no puede estar en blanco.  |"
        echo "____________________________________________________|"
        return
    fi

    if [ "$gr" == "administrador" ] || [ "$gr" == "medico" ]
    then
        clear
        echo "  ! - Eliminar grupos por defecto está prohibido.   |"
        echo "____________________________________________________|"
        return
    fi

    if [ "$found" = "" ]
    then
    clear
        echo "    ! - El nombre de grupo ingresado no existe.    |"
        echo "___________________________________________________|"
        echo
        return
    fi

    clear
    while [ 1 ]
    do
    echo "Desea eliminar al grupo $gr permanentemente?"
    echo
    echo "1 - Sí"
    echo "2 - No"
    echo
    read -p "Opción: " op
    clear

    if [ "$op" = "1" ]
    then
        groupdel -f $gr
        clear
        echo "Grupo eliminado con éxito."
        read -p "Presionar cualquier tecla para continuar..." -n1 -s
        clear
        return
    else

        if [ "$op" = "2" ]
        then
            return
        fi
        clear
        echo "               ! - Opción no existente.             |"
        echo "____________________________________________________|"
        echo
    fi
    done
}

menuABM()
{
    clear
    while [ 1 ]
    do
        echo ABM De Usuarios y Grupos
        echo 
        echo Qué desea hacer?
        echo 1- Crear Usuario
        echo 2- Modificar Usuario
        echo 3- Eliminar Usuario
        echo 4- Crear Grupo
        echo 5- Modificar Grupo
        echo 6- Eliminar Grupo
        echo 0- Salir
        echo
        read -p "Opción: " op
        case $op in
            0)
                clear
                return
                ;;
            1)
                alta
                ;;
            2)
                mod
                ;;
            3)
                baja
                ;;
            4)
                altgr
                ;;
            5)
                modgr
                ;;
            6)
                bajgr
                ;;
            *)
                clear
                echo
                echo "               ! - Opción no existente.             |"
                echo "____________________________________________________|"
                echo
                ;;
            esac
        done
    clear
    exit
}

menuServicios(){
    clear
    while [ 1 ]
    do
    echo _______________________________________________________________________________________________
    echo
    echo Qué desea hacer?
    echo
    echo "1- SSH"
    echo "2- Respaldos"
    echo "0- Salir"
    echo

    read -p "Opción: " op
    case $op in
    0)
    clear
    break
    ;;
    1)
    menuSSH
    clear
    ;;
    2)
    menuRespaldos
    ;;
    *)
    echo "                                                 |"
    echo "              ! - Opción no existente            |"
    echo "_________________________________________________|"
    ;;
    esac
    done 
}

menuRespaldos(){
    clear
    while [ 1 ]
    do

        echo "|============================|"
        echo "!         Respaldos          |"
        echo "|     ¿Qué desea hacer?      |"
        echo "|                            |"   
        echo "|     1- Activar             |"
        echo "|     2- Desactivar          |"
        echo "|     3- Respaldar ahora     |"
        echo "|     0- Salir               |"
        echo "|                            |"
        echo "|============================|"

        read -p "Opcion: " op

        case $op in
            0)
                clear
                return
                ;;
            1)
                echo "0 2 * * * root /root/Server-Management/backup.sh" >> /etc/crontab

                clear
                echo
                echo "             ! -  Respaldos Activados               |"
                echo "____________________________________________________|"
                echo
                ;;
            2)
                cat /etc/crontab | grep -v "backup.sh" > /etc/tempCron
                cat /etc/tempCron > /etc/crontab
                rm -f /etc/tempCron

                clear
                echo
                echo "          ! -  Respaldos Desactivados               |"
                echo "____________________________________________________|"
                echo
                ;;
            3)
                ./backup.sh
                clear
                echo
                echo "             ! -  Información Respaldada            |"
                echo "____________________________________________________|"
                
                ;; 
            *)
                echo "                                                 |"
                echo "              ! - Opción no existente            |"
                echo "_________________________________________________|"
                ;;
        esac
    done
}

Logs(){
    clear
    while [ 1 ]
        do
            echo "|============================|"
            echo "!            Logs            |"
            echo "|     ¿Qué logs desea ver?   |"
            echo "|                            |"   
            echo "|     1- Logins exitosos     |"
            echo "|     2- Logins sin éxito    |"
            echo "|     3- Todos               |"
            echo "|     0- Salir               |"
            echo "|                            |"
            echo "|============================|"

            read -p "Opción: " op

            case $op in
                0)
                    clear
                    break
                    ;;
                1)
                    clear
                    grep -i 'opened' /var/log/secure
                    echo
                    read -p "Presionar cualquier tecla para continuar..." -n1 -s
                    clear
                    ;;
                2)
                    clear
                    grep -Ei 'failed|failure' /var/log/secure
                    echo
                    read -p "Presionar cualquier tecla para continuar..." -n1 -s
                    clear
                    ;;
                3)
                    clear
                    cat /var/log/secure
                    echo
                    read -p "Presionar cualquier tecla para continuar..." -n1 -s
                    clear
                    ;;
                *)
                    clear
                    echo "                                                    |"
                    echo "               ! - Opción no existente.             |"
                    echo "____________________________________________________|"
                    echo
                    ;;
            esac
    done
}


menuSSH(){
    clear
    while [ 1 ]
    do
        echo "|============================|"
        echo "!                            |"
        echo "|     ¿Qué desea hacer?      |"
        echo "|                            |"   
        echo "|     1- Activar             |"
        echo "|     2- Desactivar          |"
        echo "|     3- Estado              |"
        echo "|     0- Salir               |"
        echo "|                            |"
        echo "|============================|"

        read -p "Opción: " op
        case $op in
            0)
                clear
                break
                ;;
            1)
                systemctl enable sshd.service;
                systemctl start sshd.service;
                clear

                echo "                                                    |"
                echo "               ! - SSH Activado                     |"
                echo "____________________________________________________|"
                echo

                ;;
            2)
                systemctl stop sshd.service;
                clear

                echo "                                                    |"
                echo "              ! - SSH Desactivado                   |"
                echo "____________________________________________________|"
                echo

                ;;
            3)
                clear
                systemctl status sshd.service | grep -w "Active:"
                ;;
        esac
    done
}


clear
defaultConfiguration(){

    if [ ! -d "/home/usuarios/administrador" ] || [ ! -d "/home/usuarios/medico" ] 
    then
        mkdir /home/usuarios
        mkdir /home/usuarios/medico
        mkdir /home/usuarios/administrador
        dirTest=1
    fi

    testAdmin=$(grep "administrador"":" /etc/group | awk -F ':' '{print $1}')
    testMed=$(grep "medico"":" /etc/group | awk -F ':' '{print $1}')

    if [[ "$testAdmin" != "administrador" ]] || [[ "$testMed" != "medico" ]]
    then
        groupadd administrador
        groupadd medico
        gruTest=1
    fi

    if [ $dirTest ] && [ $gruTest ]
    then
        clear
        echo "   ! - Directorios y grupos creados exitosamente.   |"
        echo "____________________________________________________|"
        echo
    else
        if [ $dirTest ]
        then
            clear
            echo "  ! - Directorios de usuarios creados exitosamente. |"
            echo "____________________________________________________|"
            echo
        else
            if [ $gruTest ]
                then
                clear
                echo "    ! - Grupos por defecto creados exitosamente.    |"
                echo "____________________________________________________|"
                echo
            fi
        fi
    fi
}

defaultConfiguration
while [ 1 ]
do
    echo Herramientas del sistema
    echo 
    echo Qué desea hacer?
    echo "1- ABMs"
    echo "2- Servicios"
    echo "3- Ver logs"
    echo "0- Salir"
    echo
    read -p "Opción: " op
    case $op in
        0)
            clear
            exit
            ;;
        1)
            menuABM
            ;;
        2)
            menuServicios
            ;;
        3)
            Logs
            ;;
        *)
            clear
            echo "               ! - Opción no existente.             |"
            echo "____________________________________________________|"
            echo
            ;;
    esac
done
clear
