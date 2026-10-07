BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "item_note" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "itemId" uuid NOT NULL,
    "body" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "item_note_owner_item_idx" ON "item_note" USING btree ("ownerId", "itemId", "createdAt");
CREATE INDEX "item_note_search_fts_idx" ON "item_note" USING gin (to_tsvector('simple', "body"));

--
-- ACTION CREATE TABLE
--
CREATE TABLE "item_progress" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "itemId" uuid NOT NULL,
    "firstOpenedAt" timestamp without time zone,
    "lastOpenedAt" timestamp without time zone,
    "openCount" bigint NOT NULL DEFAULT 0,
    "firstReviewedAt" timestamp without time zone,
    "lastReviewedAt" timestamp without time zone,
    "completedAt" timestamp without time zone,
    "appliedAt" timestamp without time zone,
    "rebuiltAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "item_progress_owner_item_idx" ON "item_progress" USING btree ("ownerId", "itemId");
CREATE INDEX "item_progress_owner_reviewed_idx" ON "item_progress" USING btree ("ownerId", "firstReviewedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "item_review_control" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "itemId" uuid NOT NULL,
    "snoozedUntil" timestamp without time zone,
    "remindersPaused" boolean NOT NULL DEFAULT false,
    "lastDismissedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "item_review_control_owner_item_idx" ON "item_review_control" USING btree ("ownerId", "itemId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reminder_settings" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "delayHours" bigint NOT NULL DEFAULT 24,
    "timezone" text NOT NULL DEFAULT 'UTC'::text,
    "timezoneOffsetMinutes" bigint NOT NULL DEFAULT 0,
    "quietStartMinute" bigint,
    "quietEndMinute" bigint,
    "dailyCap" bigint NOT NULL DEFAULT 1,
    "remindersPaused" boolean NOT NULL DEFAULT false,
    "queueLimit" bigint NOT NULL DEFAULT 5,
    "dismissCooldownMinutes" bigint NOT NULL DEFAULT 120
);

-- Indexes
CREATE UNIQUE INDEX "reminder_settings_owner_idx" ON "reminder_settings" USING btree ("ownerId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "review_digest" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "digestKey" text NOT NULL,
    "localDate" text NOT NULL,
    "body" text NOT NULL,
    "itemCount" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "review_digest_owner_key_idx" ON "review_digest" USING btree ("ownerId", "digestKey");
CREATE INDEX "review_digest_owner_created_idx" ON "review_digest" USING btree ("ownerId", "createdAt");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "review_event" ADD COLUMN "clientEventId" text;
CREATE UNIQUE INDEX "review_event_owner_client_id_idx" ON "review_event" USING btree ("ownerId", "clientEventId");

-- Serverpod 4 does not currently express PostgreSQL expression indexes in
-- model YAML. These match SearchService's weighted keyword document.
CREATE INDEX "item_search_fts_idx" ON "item" USING gin ((
    setweight(to_tsvector('simple', coalesce("title", '')), 'A') ||
    setweight(to_tsvector('simple', coalesce("intention", '') || ' ' || coalesce("noteText", '')), 'B') ||
    setweight(to_tsvector('simple', coalesce("url", '') || ' ' || "sourcePlatform" || ' ' || "contentType"), 'C')
));
CREATE INDEX "tag_search_fts_idx" ON "tag" USING gin (
    to_tsvector('simple', "displayName" || ' ' || "normalizedName")
);
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "item_note"
    ADD CONSTRAINT "item_note_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "item_note"
    ADD CONSTRAINT "item_note_fk_1"
    FOREIGN KEY("itemId")
    REFERENCES "item"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "item_progress"
    ADD CONSTRAINT "item_progress_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "item_progress"
    ADD CONSTRAINT "item_progress_fk_1"
    FOREIGN KEY("itemId")
    REFERENCES "item"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "item_review_control"
    ADD CONSTRAINT "item_review_control_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "item_review_control"
    ADD CONSTRAINT "item_review_control_fk_1"
    FOREIGN KEY("itemId")
    REFERENCES "item"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "reminder_settings"
    ADD CONSTRAINT "reminder_settings_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "review_digest"
    ADD CONSTRAINT "review_digest_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR pinne
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('pinne', '20261007020809661', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261007020809661', "timestamp" = now();

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
