##################################################
export  TASK_DIR="$HOME/.task"
export _indexFile="${TASK_DIR}/index.psv"
export _doneFile="${TASK_DIR}/done.psv"
##################################################
git -C "${TASK_DIR}" pull
test $? -ne 0 && return 1
git -C "${TASK_DIR}" push
