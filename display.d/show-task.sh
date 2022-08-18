tasknum=$(/bin/ls -1 ~/.task/*.source 2>/dev/null | wc -l)

if [[ $tasknum == 0 ]];then
  echo "Congratulations! タスクはありません."
else
echo "現在、${tasknum}のtaskがあります"
fi
