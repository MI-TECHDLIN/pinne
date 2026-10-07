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
CREATE TABLE "ai_daily_usage" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "dateKey" text NOT NULL,
    "requestCount" bigint NOT NULL DEFAULT 0
);

-- Indexes
CREATE UNIQUE INDEX "ai_daily_usage_owner_date_unique" ON "ai_daily_usage" USING btree ("ownerId", "dateKey");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_organize_task" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "itemId" uuid NOT NULL,
    "state" text NOT NULL DEFAULT 'queued'::text,
    "requestedVersion" bigint NOT NULL DEFAULT 1,
    "processedVersion" bigint NOT NULL DEFAULT 0,
    "dailySlotClaimed" boolean NOT NULL DEFAULT false,
    "quotaDateKey" text,
    "claimedAt" timestamp without time zone,
    "completedAt" timestamp without time zone,
    "provider" text
);

-- Indexes
CREATE UNIQUE INDEX "ai_organize_task_item_unique" ON "ai_organize_task" USING btree ("itemId");
CREATE INDEX "ai_organize_task_owner_state_idx" ON "ai_organize_task" USING btree ("ownerId", "state");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_preference" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "enabled" boolean NOT NULL DEFAULT true
);

-- Indexes
CREATE UNIQUE INDEX "ai_preference_owner_unique" ON "ai_preference" USING btree ("ownerId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_suggestion" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "itemId" uuid NOT NULL,
    "kind" text NOT NULL,
    "origin" text NOT NULL DEFAULT 'ai'::text,
    "collectionId" uuid,
    "value" text,
    "rationale" text NOT NULL,
    "evidenceCoverage" text NOT NULL DEFAULT 'metadataOnly'::text,
    "uncertain" boolean NOT NULL DEFAULT false,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolvedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "ai_suggestion_owner_item_idx" ON "ai_suggestion" USING btree ("ownerId", "itemId", "status");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "item" ADD COLUMN "summary" text;
ALTER TABLE "item" ADD COLUMN "summaryOrigin" text;
ALTER TABLE "item" ADD COLUMN "summaryManuallyLocked" boolean NOT NULL DEFAULT false;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "item_tag" ADD COLUMN "manuallyLocked" boolean NOT NULL DEFAULT false;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ai_daily_usage"
    ADD CONSTRAINT "ai_daily_usage_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ai_organize_task"
    ADD CONSTRAINT "ai_organize_task_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "ai_organize_task"
    ADD CONSTRAINT "ai_organize_task_fk_1"
    FOREIGN KEY("itemId")
    REFERENCES "item"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ai_preference"
    ADD CONSTRAINT "ai_preference_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ai_suggestion"
    ADD CONSTRAINT "ai_suggestion_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "ai_suggestion"
    ADD CONSTRAINT "ai_suggestion_fk_1"
    FOREIGN KEY("itemId")
    REFERENCES "item"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "ai_suggestion"
    ADD CONSTRAINT "ai_suggestion_fk_2"
    FOREIGN KEY("collectionId")
    REFERENCES "collection"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR pinne
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('pinne', '20261007010817462', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261007010817462', "timestamp" = now();

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
