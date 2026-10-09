BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "item" ADD COLUMN "titleManuallyLocked" boolean NOT NULL DEFAULT false;
-- Existing rows predate the explicit lock bit. Preserve any title that does
-- not exactly match the deterministic host/path fallback; those are the rows
-- that may have been supplied or edited by a person.
UPDATE "item"
SET "titleManuallyLocked" = true
WHERE "url" IS NULL
   OR "canonicalUrl" IS NULL
   OR "title" <> left(
        regexp_replace(
          regexp_replace("canonicalUrl", '^https?://(www\.)?', '', 'i'),
          '/+$',
          ''
        ),
        80
      );
ALTER TABLE "item" ADD COLUMN "previewDescription" text;
ALTER TABLE "item" ADD COLUMN "previewAuthor" text;
ALTER TABLE "item" ADD COLUMN "previewSiteName" text;
ALTER TABLE "item" ADD COLUMN "previewProvider" text;
ALTER TABLE "item" ADD COLUMN "thumbnailUrl" text;
ALTER TABLE "item" ADD COLUMN "durationSeconds" bigint;
ALTER TABLE "item" ADD COLUMN "previewMetadataJson" text;
ALTER TABLE "item" ADD COLUMN "previewUpdatedAt" timestamp without time zone;
ALTER TABLE "item" ADD COLUMN "previewStartedAt" timestamp without time zone;
ALTER TABLE "item" ADD COLUMN "previewAttemptCount" bigint NOT NULL DEFAULT 0;

--
-- MIGRATION VERSION FOR pinne
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('pinne', '20261009064122315', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261009064122315', "timestamp" = now();

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
