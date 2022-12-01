TRUNCATE TABLE users, peeps RESTART IDENTITY;

INSERT INTO users ("name", "email", "username", "password") VALUES
('User One', 'one@one.com', 'one1', 'password1'),
('User Two', 'two@two.com', 'two2', 'password2'),
('User Three', 'three@three.com', 'three3', 'password3');

INSERT INTO peeps ("content", "time", "user_id") VALUES
('First', current_timestamp, 1),
('Second', current_timestamp, 2),
('Third', current_timestamp, 3);

