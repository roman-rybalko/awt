create table tests(user_id integer not null, name varchar(256) not null, test_id integer primary key auto_increment not null);
create table test_actions(test_id integer not null, type varchar(256) not null, selector varchar(256), data varchar(256), action_id integer not null);
create unique index test_actions_idx on test_actions(test_id, action_id);
create table tasks(user_id integer not null, test_id integer not null, test_name varchar(255) not null, type varchar(32) not null, debug integer(1), status integer not null, data varchar(256), task_id integer primary key auto_increment not null, time integer not null);
create index tasks_idx on tasks(status); -- первоначальный запрос
create index tasks_idx2 on tasks(time); -- удаление
create table task_actions(task_id integer not null, type varchar(256) not null, selector varchar(256), data varchar(256), action_id integer not null, scrn_filename varchar(256), failed varchar(256));
create unique index task_actions_idx on task_actions(task_id, action_id);
create table task_types(type_id integer primary key auto_increment not null, name varchar(32) not null, parent_type_id integer);
create unique index task_types_idx on task_types(name);
