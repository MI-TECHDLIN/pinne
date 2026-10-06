BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "collection" ADD COLUMN "coverSeed" bigint NOT NULL DEFAULT 0;
ALTER TABLE "collection" ADD COLUMN "paletteIndex" bigint NOT NULL DEFAULT 0;

--
-- MIGRATION VERSION FOR pinne
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('pinne', '20261006044720453', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261006044720453', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
