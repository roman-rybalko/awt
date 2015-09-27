cat web_construction_set/database/relational/user.sql
sed 's/anacron/task_schedule/g' web_construction_set/database/relational/anacron.sql
cat web_construction_set/database/relational/history.sql
sed 's/anacron/mail_schedule/g' web_construction_set/database/relational/anacron.sql
