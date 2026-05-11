INSERT INTO f1_seasons(season_year) VALUES (2026);

INSERT INTO f1_teams(team_code, name, country, engine)
VALUES ('RBR', 'Red Bull Racing', 'Austria', 'Honda');

INSERT INTO f1_teams(team_code, name, country, engine)
VALUES ('FER', 'Ferrari', 'Italy', 'Ferrari');

INSERT INTO f1_teams(team_code, name, country, engine)
VALUES ('MER', 'Mercedes', 'Germany', 'Mercedes');

INSERT INTO f1_teams(team_code, name, country, engine)
VALUES ('MCL', 'McLaren', 'United Kingdom', 'Mercedes');

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('VER',
  (SELECT team_id FROM f1_teams WHERE team_code='RBR'),
  'Max', 'Verstappen', 'Netherlands', DATE '1997-09-30'
);

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('PER',
  (SELECT team_id FROM f1_teams WHERE team_code='RBR'),
  'Sergio', 'Perez', 'Mexico', DATE '1990-01-26'
);

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('LEC',
  (SELECT team_id FROM f1_teams WHERE team_code='FER'),
  'Charles', 'Leclerc', 'Monaco', DATE '1997-10-16'
);

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('SAI',
  (SELECT team_id FROM f1_teams WHERE team_code='FER'),
  'Carlos', 'Sainz', 'Spain', DATE '1994-09-01'
);

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('HAM',
  (SELECT team_id FROM f1_teams WHERE team_code='MER'),
  'Lewis', 'Hamilton', 'United Kingdom', DATE '1985-01-07'
);

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('RUS',
  (SELECT team_id FROM f1_teams WHERE team_code='MER'),
  'George', 'Russell', 'United Kingdom', DATE '1998-02-15'
);

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('NOR',
  (SELECT team_id FROM f1_teams WHERE team_code='MCL'),
  'Lando', 'Norris', 'United Kingdom', DATE '1999-11-13'
);

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('PIA',
  (SELECT team_id FROM f1_teams WHERE team_code='MCL'),
  'Oscar', 'Piastri', 'Australia', DATE '2001-04-06'
);

INSERT INTO f1_races(season_id, gp_code, gp_name, race_date, country, city)
VALUES (
  (SELECT season_id FROM f1_seasons WHERE season_year = 2026),
  'BAHRAIN_2026', 'Bahrain GP', DATE '2026-03-08',
  'Bahrain', 'Sakhir'
);

INSERT INTO f1_races(season_id, gp_code, gp_name, race_date, country, city)
VALUES (
  (SELECT season_id FROM f1_seasons WHERE season_year = 2026),
  'EMILIA_2026', 'Emilia Romagna GP', DATE '2026-05-17',
  'Italy', 'Imola'
);

INSERT INTO f1_races(season_id, gp_code, gp_name, race_date, country, city)
VALUES (
  (SELECT season_id FROM f1_seasons WHERE season_year = 2026),
  'MONACO_2026', 'Monaco GP', DATE '2026-05-24',
  'Monaco', 'Monte Carlo'
);

COMMIT;