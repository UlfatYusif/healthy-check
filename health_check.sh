#!/bin/bash
# health_check.sh
##############################################
# Purpose check system and PostgeSQL statuses#
# version         : 0.1                      #
# developed  date : 21-Feb-2026              #
##############################################

echo "Timestamp : $(date)"
echo ""

# -------- Functions --------

check_postgres() {
STATUS=$(brew services list | grep postgresql | awk '{print $2}')

if [ "$STATUS" = "started" ]; then
    echo "PostgreSQL is running via Homebrew ✅"
else
    echo "PostgreSQL is NOT running ❌"
fi
echo ""
}

show_disk() {
    df -h
}

show_date() {
    date
}

system_information() {
echo "Hostname: $(hostname)"
uname -a
sw_vers -productVersion
system_profiler SPHardwareDataType
echo ""
}

database_status() {
echo "Existing databases and sizes"
psql -c "SELECT datname, pg_size_pretty(pg_database_size(datname)) as size,
datcollate, datctype FROM pg_database ORDER BY size DESC;"
echo "PostgreSQL Version: $(psql --version)"
echo ""
echo "Database Users and Roles"
psql -c "\dn"
psql -c "\du"
echo ""
}

data_dictionary_structure() {
PGDATA=$(psql -t -c "SHOW data_directory;" 2>/dev/null | xargs)
if [ -z "$PGDATA" ]; then
PGDATA="/var/lib/postgresql"
fi
echo "PGDATA: $PGDATA"
if [ -d "$PGDATA" ]; then
tree -L 3 $PGDATA 2>/dev/null || find $PGDATA -maxdepth 3 -type d | sort
else
echo "ERROR: PGDATA directory not found!"
fi
echo ""
}

exit_program() {
    echo "Exiting..."
    exit 0
}

# -------- Menu Function --------

main_menu() {
    while true; do
        echo "======================"
        echo "      MAIN MENU       "
        echo "======================"
        echo "1. Check PostgreSQL"
        echo "2. Show Disk Usage"
        echo "3. Show Current Date"
        echo "4. System Information"
        echo "5. Database Information"
        echo "6. Data Dictionary Structure"
        echo "7. Exit"
        echo "======================"

        read -p "Choose option [1-7]: " choice

        case $choice in
            1) check_postgres ;;
            2) show_disk ;;
            3) show_date ;;
            4) system_information ;;
            5) database_status ;; 
            6) data_dictionary_structure ;;  
            7) exit_program ;;
            *) echo "Invalid option ❌" ;;
        esac

        echo ""
        read -p "Press Enter to continue..."
        clear
    done
}

# -------- Start Program --------
main_menu

