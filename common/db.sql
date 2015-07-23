create table tests(user_id integer not null, name varchar(255) not null, test_id integer primary key auto_increment not null);
create table test_actions(test_id integer not null, type varchar(255) not null, selector varchar(255), data varchar(255), test_action_id integer not null);
create unique index test_actions_idx on test_actions(test_id, test_action_id);
