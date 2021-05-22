from crontab import CronTab
import os

# prepare environments
SCHEDULE = os.getenv('schedule')
EXECUTOR = os.getenv('executor')
PROGRAM = os.getenv('program')

if not SCHEDULE:
  SCHEDULE = '* * * * *'

if not EXECUTOR:
  EXECUTOR = '/usr/local/bin/python3'

if not PROGRAM:
  PROGRAM = '/app/backup.py'

# create cron folder
CRON_DIR = '/etc/cron.d/'
os.makedirs(CRON_DIR, exist_ok=True)
  
# create cron file
TAB_FILE='/etc/cron.d/backup.job'
f = open(TAB_FILE, 'w')
f.write('{schedule} {executer} {program}'.format(
  schedule=SCHEDULE,
  executer=EXECUTOR,
  program=PROGRAM,
))
f.close()

# start crontab
tab = CronTab(
  tabfile=TAB_FILE, 
  user='root'
)

for result in tab.run_scheduler():
  print(result)