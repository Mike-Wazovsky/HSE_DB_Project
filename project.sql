--1
DROP SCHEMA IF EXISTS project CASCADE;
CREATE SCHEMA project;

SET SEARCH_PATH = project;

DROP TABLE IF EXISTS project.discipline;
CREATE TABLE project.discipline (
    discipline_id serial primary key ,
    discipline_name varchar(100)
);

DROP TABLE IF EXISTS project.tournament_org;
CREATE TABLE project.tournament_org (
    tournament_org_id serial primary key,
    org_name varchar(100),
    num_of_tournament int check (num_of_tournament > 0),
    rating real check (rating between 0 and 5),
    org_location varchar(100)
);

DROP TABLE IF EXISTS project.tournament;
CREATE TABLE project.tournament (
    tournament_id varchar(100) primary key ,
    discipline_id int,
    tournament_org_id int,
    start_date date not null ,
    end_date date not null ,
    prize_pool money check (prize_pool > money(0)),

    foreign key (discipline_id) references discipline(discipline_id) on delete cascade on update cascade,
    foreign key (tournament_org_id) references tournament_org(tournament_org_id) on delete restrict on update cascade
);

DROP TABLE IF EXISTS project.sport_org;
CREATE TABLE project.sport_org (
    sport_org_id varchar(100) primary key,
    year_yearns money,
    country varchar(100)
);

DROP TABLE IF EXISTS project.team;
CREATE TABLE project.team (
    team_id serial primary key,
    discipline_id int,
    sport_org_id varchar(100),

    team_rating int check ( team_rating > 0 ),
    total_wins int check ( total_wins > -1 ),
    creation_date date check ( team.creation_date < current_date ),

    foreign key (discipline_id) references discipline(discipline_id) on delete cascade on update cascade,
    foreign key (sport_org_id) references sport_org(sport_org_id) on delete restrict on update cascade
);

DROP TABLE IF EXISTS project.tournament_x_team;
CREATE TABLE project.tournament_x_team (
    tournament_id varchar(100),
    team_id int,

    foreign key (tournament_id) references tournament(tournament_id) on delete cascade on update cascade,
    foreign key (team_id) references  team(team_id) on delete restrict on update cascade
);


DROP TABLE IF EXISTS project.player;
CREATE TABLE project.player (
    discipline_id int,
    team_id int,
    player_name varchar(100) not null ,
    player_nickname varchar(100) not null,
    valid_from_dttm date not null,
    valid_to_dttm date not null,

    constraint pk_player primary key (player_name, valid_from_dttm),
    foreign key (discipline_id) references discipline(discipline_id) on delete cascade on update cascade,
    foreign key (team_id) references team(team_id) on delete restrict on update cascade
);


DROP TABLE IF EXISTS project.discipline_x_sport_org;
CREATE TABLE project.discipline_x_sport_org (
    discipline_id int,
    sport_org_id varchar(100),

    foreign key (discipline_id) references discipline(discipline_id) on delete cascade on update cascade,
    foreign key (sport_org_id) references sport_org(sport_org_id) on delete restrict on update cascade
);

--2

insert into project.discipline(discipline_name)
values ('Dota 2'),
       ('CS-GO'),
       ('Hearthstone'),
       ('Tetris');

insert into project.tournament_org(org_name, num_of_tournament, rating, org_location)
values ('PGL', 23, 4.6, 'Romania'),
       ('ESL', 40, 4.2, NULL),
       ('DreamHack', 14, 4.0, 'Sweden'),
       ('StarLadder', 19, 3.9, NULL),
       ('Eleague', 61, 3.6, 'USA'),
       ('Blizzard Entertainment', 55, 3.1, 'USA'),
       ('Portland Retro Gaming Expo', 8, 3.2, 'USA');

insert into project.tournament(tournament_id, discipline_id, tournament_org_id, start_date, end_date, prize_pool)
values ('TI8', 1, 1, '2018-08-15', '2018-08-25', 25532177),
       ('TI10', 1, 1, '2021-10-07', '2021-10-17', 40018195),
       ('The Bucharest Major', 1, 1, '2018-03-04', '2018-03-11', 1000000),
       ('DreamLeague Season 13', 1, 3, '2020-01-18', '2020-01-26', 1000000),
       ('IEM Season XIV', 2, 2, '2020-02-24', '2020-03-01', 500000),
       ('ELEAGUE CS:GO Premier 2018', 2, 5, '2018-07-21', '2018-07-29', 1000000),
       ('The Chongqing Major', 1, 4, '2019-01-19', '2019-01-27', 1000000),
       ('IEM Rio Major 2022', 2, 2, '2022-10-31', '2022-11-13', 1250000),
       ('Hearthstone WC 2022', 3, 5, '2022-12-16', '2022-12-18', 500000),
       ('Tetris WC 2020', 4, 6, '2020-04-15', '2020-04-22', 100000);

insert into project.sport_org(sport_org_id, year_yearns, country)
values ('Navi', 5000000, 'Ukraine'),
       ('Team Secret', 4600000, 'EU'),
       ('Outsiders', 2000000, NULL),
       ('LGD', 3700000, 'China'),
       ('EG', 2300000, 'USA'),
       ('Astralis', 7000000, 'Denmark'),
       ('Team Spirit', 1200000, 'Russia');

insert into project.team(discipline_id, sport_org_id, team_rating, total_wins, creation_date)
values (2, 'Navi', 4, 24, '2008-06-17'),
       (2, 'Astralis', 25, 16, '2014-07-03'),
       (1, 'Navi', 17, 36, '2008-04-16'),
       (1, 'LGD', 2, 14, '2009-11-12'),
       (2, 'Outsiders', 1, 7, '2020-05-18'),
       (3, 'Team Spirit', NULL, 2, '2016-01-05'),
       (1, 'Team Secret', 3, 15, '2014-02-03');

insert into project.tournament_x_team(tournament_id, team_id)
values ('TI8', 3),
       ('TI8', 4),
       ('TI8', 7),
       ('TI10', 4),
       ('TI10', 7),
       ('Hearthstone WC 2022', 6),
       ('IEM Rio Major 2022', 5),
       ('IEM Rio Major 2022', 1);

insert into project.player(discipline_id, team_id, player_name, player_nickname, valid_from_dttm, valid_to_dttm)
values (1, 1, 'Danil Ishutin', 'Dendi', '2010-12-25', '2019-08-10'),
       (1, NULL, 'Danil Ishutin', 'Dendi', '2020-01-27', '9999-01-01'),
       (2, 1, 'Bob Bubibob', 'S1mple', '2014-01-01', '2016-03-11'),
       (2, 2, 'Bob Bubibob', 'S1mple', '2016-03-11', '2020-11-14'),
       (2, 5, 'Bob Bubibob', 'S1mple', '2020-11-14', '9999-01-01'),
       (3, 6, 'Vladislav Sinotov', 'Silvername', '2016-12-15', '9999-01-01'),
       (4, NULL, 'Josef Seily', 'Dog', '2019-01-17', '9999-01-01');


insert into project.discipline_x_sport_org(discipline_id, sport_org_id)
values (1, 'Navi'),
       (1, 'Team Secret'),
       (1, 'LGD'),
       (1, 'EG'),
       (1, 'Team Spirit'),
       (2, 'Navi'),
       (2, 'Outsiders'),
       (2, 'EG'),
       (2, 'Astralis'),
       (2, 'Team Spirit'),
       (3, 'Team Spirit');

--3

insert into project.sport_org(sport_org_id, year_yearns, country)
values ('OG', 120000000, 'EU');

select
    t.tournament_id,
    t.prize_pool
from
    tournament t
where
    t.discipline_id = 1;

update
    project.team
set
    team_rating = 21
where
    sport_org_id = 'Navi' and
    discipline_id = 1;

delete from
    discipline_x_sport_org dxs
where
    dxs.discipline_id = 2 and
    dxs.sport_org_id = 'Team Spirit';

insert into project.sport_org(sport_org_id, year_yearns, country)
values ('5 anchors', 100000, NULL);

select
    sum(so.year_yearns)
from
    sport_org so;

update
    project.tournament_org
set
    num_of_tournament = 25
where
    org_name = 'PGL';

delete from
    sport_org
where
    year_yearns < money(500000);