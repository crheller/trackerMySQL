-- create tables for the tracker DATABASE and initialize with some dummy information

---------------------------------------------------------------
-- DATA table (the "master" table)
CREATE TABLE tracker.data (
    experiment_id INT NOT NULL AUTO_INCREMENT, -- shared across tables (e.g. analysis)
    experiment_class VARCHAR(100) NOT NULL,
    experiment_rig VARCHAR(100) NOT NULL,
    fish_id VARCHAR(100) NOT NULL,             -- id not sure this is the best (since it "hides" genotype info etc.), but let's try it
    fish_idx INT NOT NULL,                     -- 1st, 2nd, 3rd etc. expt with this fish?
    chamber_id VARCHAR(100) NOT NULL,          -- description / name-- links to "chambers" table
    hardware_test INT DEFAULT 0,
    data_path VARCHAR(100),
    imaging INT,                               -- imaging expt, or behavior only
    date_added TIMESTAMP,
    last_mod TIMESTAMP,
    bad INT DEFAULT 0,                         -- if there was a hardware glitch, for example, and need to flag and exclude data.
                                               -- this is something that probably needs to happen in the browser
    addedby VARCHAR(100),                      -- USER
    comments TEXT,                             -- anything else that doesn't fit neatly into a field. Text box in browser
    PRIMARY KEY ( experiment_id )

);
-- fill the table
INSERT INTO tracker.data (experiment_class, experiment_rig, fish_id, fish_idx, chamber_id, data_path, imaging, date_added, last_mod, bad, addedby, comments)
VALUES 
    ("prolene", "RoLi-11", "expert-parakeet", 1, "my_first_chamber", "/path/to/the/data/", 0, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 0, "charlie", "extra notes go here"),
    ("prolene_ctrl", "RoLi-11", "expert-parakeet", 2, "my_first_chamber", "/path/to/the/data2/", 0, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 0, "charlie", "e.g. I re-ran expert-parakeet bc he's a champ"),
    ("prolene", "RoLi-10", "sad-panda", 1, "my_first_chamber", "/path/to/the/data3/", 1, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 0, "vikash", "vikash added new expt on new animal/rig. he did imaging")
;

---------------------------------------------------------------
-- ANALYSIS table (keep track of postprocessing for each dataset. e.g. image registration)
-- so, every time a new experiment gets created in DATA, a new analysis entry gets made for that experiment_id too
CREATE TABLE tracker.analysis (
    experiment_id INT NOT NULL,
    eye_tracking INT DEFAULT 0,  -- 0 (not done), 1 (in progress), 2 (complete)
    roi_detection INT            -- -1 (behavior only), 0 (not done), 1 (in progress), 2 (complete)
);
-- fill the table
INSERT INTO tracker.analysis (experiment_id, eye_tracking, roi_detection)
VALUES 
    (1, 0, -1),
    (2, 1, -1),
    (3, 2, 1)
;

---------------------------------------------------------------
-- "FISH" table 
CREATE TABLE tracker.fish (
    fish_id VARCHAR(100) NOT NULL,         -- gets auto-generated each time someone uses dasher to add a fish
    dpf INT NOT NULL,                      -- should all this animal stuff get replaced by a fish_id
    genotype VARCHAR(100) NOT NULL,
    addedby VARCHAR(100)                   -- user name pulled from os
);
-- fill the table
INSERT INTO tracker.fish (fish_id, dpf, genotype, addedby)
VALUES
    ("expert-parakeet", "8", "Tg(elavl3:H2B-GCaMP6s+/+)", "charlie"),
    ("sad-panda", "5", "Tg(elavl3:H2B-GCaMP6s+/+)", "vikash")
;

---------------------------------------------------------------
-- CHAMBERS table
CREATE TABLE tracker.chambers (
    chamber_id VARCHAR(100) NOT NULL,
    addedby VARCHAR(100),
    photo_path VARCHAR(100),
    comments TEXT
);

-- fill the table
INSERT INTO tracker.chambers (chamber_id, addedby, photo_path, comments)
VALUES 
    ("my_first_chamber", "charlie", "/home/charlie/Desktop/roli/trackerdb/chambers/my_chamber.png", 
                "My first chamber using Lilian's oval flow design")
;

---------------------------------------------------------------
-- USERS table
CREATE TABLE tracker.users (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50),
    pass VARCHAR(100),
    email VARCHAR(100),
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    PRIMARY KEY ( id )
);

-- fill the table
INSERT INTO tracker.users (username, pass, email, firstname, lastname)
VALUES 
    ('charlie', 'demo', 'charles.r.heller@gmail.com', 'Charlie', 'Heller'),
    ('vikash', 'demo', 'vikash7991vikki@gmail.com', 'Vikash', 'Choudary')
;