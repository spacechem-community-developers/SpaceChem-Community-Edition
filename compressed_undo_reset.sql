-- SpaceChem save file compressor, restore script.
-- Usage:
-- sqlite3 save_file_path < path_to_this_file
-- This file will undo the changes made by the SpaceChem save file compressor script.
-- The schema is restored to factory status, along with the disk space necessary to store the save file.

-- MAKE SURE TO BACK UP YOUR IMPORTANT SAVE FILES BEFORE RUNNING THIS ON THEM!

CREATE TABLE [UndoRestore] (
    [level_id] text NOT NULL,
    [id] integer NOT NULL,
    [log] text DEFAULT NULL,
    CONSTRAINT [PK_Undo] PRIMARY KEY ([level_id], [id])
);

INSERT INTO [UndoRestore]
SELECT [level_id], [id], [log]
FROM Undo;

DROP VIEW Undo;

ALTER TABLE UndoRestore RENAME TO [Undo];

DROP TABLE CompressedUndo;

DROP TABLE IF EXISTS LevelNameDedup;

CREATE INDEX [IX_Undo_level_id_id] ON [Undo] ([level_id], [id]);

VACUUM;

