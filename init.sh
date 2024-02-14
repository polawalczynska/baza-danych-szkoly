SCRIPT_DIR=$(pwd)

MYSQL_DATABASE="schoolDB"
MYSQL_USER="root"
MYSQL_PASSWORD="userRoot"

CRONE_DIR="${SCRIPT_DIR}/crone"
SAVE_DIR="${SCRIPT_DIR}/dumps"

rm -rf  ${CRONE_DIR}
rm -rf ${SAVE_DIR}
mkdir ${CRONE_DIR}
mkdir ${SAVE_DIR}

UPDATE_SCRIPT="${CRONE_DIR}/updateLessonsInProgress.sh"
CREATE_DUMP_SCRIPT="${CRONE_DIR}/createDumpOfDatabase.sh"
CRONE_TAB_FILE="${CRONE_DIR}/crontab.txt"

echo "*/1 * * * * bash ${UPDATE_SCRIPT}" > ${CRONE_TAB_FILE}
echo "* */1 * * * bash ${CREATE_DUMP_SCRIPT}" >> ${CRONE_TAB_FILE}
crontab ${CRONE_TAB_FILE}

echo "mysql   -u ${MYSQL_USER} --password=${MYSQL_PASSWORD} -e 'call ${MYSQL_DATABASE}.update_lessons_in_progress;'" > ${UPDATE_SCRIPT}
echo "mysqldump -u ${MYSQL_USER} --password=${MYSQL_PASSWORD} --databases ${MYSQL_DATABASE} > ${SAVE_DIR}/\$(date +%m-%d-%Y_%H:%M).sql;" > ${CREATE_DUMP_SCRIPT}
echo "if ( \$(find ${SAVE_DIR} | wc -l) == 10 ); then rm \$(ls ${SAVE_DIR} -t | head -10 | tail -1); fi">> ${CREATE_DUMP_SCRIPT}
