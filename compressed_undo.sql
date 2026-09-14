-- SpaceChem save file compressor
-- Usage:
-- sqlite3 save_file_path < path_to_this_file
-- This file will change the schema of your SpaceChem save file to make it use
-- less disk space, in exchange for more CPU time. It shrank my save file by roughly 60%, but your results may vary.
-- In exchange, it may considerably increase the CPU load for undoing and redoing.

-- MAKE SURE TO BACK UP YOUR IMPORTANT SAVE FILES BEFORE RUNNING THIS ON THEM!

CREATE TABLE CompressedUndo(
[level_id] integer NOT NULL, [id] integer NOT NULL, [log] text DEFAULT NULL,
CONSTRAINT [PK_CompressedUndo] PRIMARY KEY ([level_id], [id]));

CREATE TABLE LevelNameDedup(
[numeric] integer PRIMARY KEY, [text] text NOT NULL,
CONSTRAINT [UNIQ_LevelNameDedup] UNIQUE ([text]));

INSERT INTO LevelNameDedup
SELECT DISTINCT null, [level_id] FROM Undo;

INSERT INTO CompressedUndo
SELECT LevelNameDedup.[numeric], Undo.[id], rtrim(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
Undo.[log], 'UPDATE ', x'01'),
' SET ', x'02'),
' WHERE ', x'03'),
' AND ', x'04'),
'DELETE FROM ', x'05'),
'INSERT INTO ', x'06'),
' VALUES (', x'07'),
'Component', x'08'),
'Annotation', x'0b'), -- skip tab and newline
'Pipe', x'0c'),
'Member', x'0e'),';') AS [log] -- skip carriage return
FROM Undo
INNER JOIN LevelNameDedup ON Undo.[level_id]=LevelNameDedup.[text];

DROP TABLE Undo;

CREATE VIEW Undo AS
SELECT LevelNameDedup.[text] AS level_id, CompressedUndo.[id] AS id,
replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
CompressedUndo.[log], x'01', 'UPDATE '),
x'02', ' SET '),
x'03', ' WHERE '),
x'04', ' AND '),
x'05', 'DELETE FROM '),
x'06', 'INSERT INTO '),
x'07', ' VALUES ('),
x'08', 'Component'),
x'0b', 'Annotation'),
x'0c', 'Pipe'),
x'0e', 'Member') || ';' AS log
FROM CompressedUndo
INNER JOIN LevelNameDedup ON CompressedUndo.[level_id]=LevelNameDedup.[numeric];

CREATE TRIGGER Undo_Insert
INSTEAD OF INSERT ON Undo
BEGIN
  INSERT OR IGNORE INTO LevelNameDedup VALUES ((SELECT [numeric] FROM LevelNameDedup WHERE text=new.[level_id]) , new.[level_id]);
  INSERT INTO CompressedUndo
  SELECT [numeric], new.[id], rtrim(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
  new.[log], 'UPDATE ', x'01'),
  ' SET ', x'02'),
  ' WHERE ', x'03'),
  ' AND ', x'04'),
  'DELETE FROM ', x'05'),
  'INSERT INTO ', x'06'),
  ' VALUES (', x'07'),
  'Component', x'08'),
  'Annotation', x'0b'), -- skip tab and newline
  'Pipe', x'0c'),
  'Member', x'0e'),';') -- skip carriage return
  FROM LevelNameDedup WHERE [text]=new.[level_id];
END;

CREATE TRIGGER Undo_Delete
INSTEAD OF DELETE ON UNDO
BEGIN
  DELETE FROM CompressedUndo
  WHERE CompressedUndo.[level_id] = (SELECT [numeric] FROM LevelNameDedup WHERE [text]=old.[level_id])
  AND CompressedUndo.[id] = old.[id];
END;

VACUUM;

