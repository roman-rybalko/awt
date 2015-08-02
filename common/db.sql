create table tests(user_id integer not null, name varchar(255) not null, test_id integer primary key auto_increment not null);
create table test_actions(test_id integer not null, type varchar(255) not null, selector varchar(255), data varchar(255), action_id integer not null);
create unique index test_actions_idx on test_actions(test_id, action_id);
create table tasks(user_id integer not null, test_id integer not null, type varchar(255) not null, status integer not null, data varchar(255), task_id integer primary key auto_increment not null, time integer not null);
create index tasks_idx on tasks(status); -- первоначальный запрос
create index tasks_idx2 on tasks(time); -- удаление
create table task_actions(task_id integer not null, type varchar(255) not null, selector varchar(255), data varchar(255), action_id integer not null, scrn_filename varchar(255), failed varchar(255));
create index task_actions_idx on task_actions(task_id, action_id);
