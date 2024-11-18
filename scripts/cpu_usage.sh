#!/bin/bash
while true
do
cpu_usage=$(mpstat 3 1 | grep "Average" | awk 'NR==2 {printf "%.1f%%\n", 100 - $11}')

cat <<EOF > /usr/share/nginx/html/cpu_usage.html

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Загрузка CPU</title>
    <meta http-equiv="refresh" content="3">
</head>
<body>
    <div>Загрузка CPU: ${cpu_usage}</div>
</body>
</html>

EOF
done
