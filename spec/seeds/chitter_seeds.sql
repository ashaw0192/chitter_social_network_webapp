TRUNCATE TABLE users, peeps RESTART IDENTITY;

INSERT INTO users ("name", "email", "username", "password") VALUES
('User One', 'one@one.com', 'one1', crypt('password1', gen_salt('bf'))),
('User Two', 'two@two.com', 'two2', crypt('password2', gen_salt('bf'))),
('User Three', 'three@three.com', 'three3', crypt('password3', gen_salt('bf')));

INSERT INTO peeps ("content", "time", "user_id") VALUES
('First', current_timestamp, 1),
('Second', current_timestamp, 2),
('Third', current_timestamp, 3);

