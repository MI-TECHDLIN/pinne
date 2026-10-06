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
CREATE TABLE "calendar_connection" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "route" text NOT NULL,
    "accountKey" text NOT NULL,
    "label" text NOT NULL,
    "deviceId" uuid,
    "permission" text NOT NULL,
    "tokenSecretRef" text,
    "lastCheckedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "calendar_connection_owner_account_idx" ON "calendar_connection" USING btree ("ownerId", "route", "accountKey");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "calendar_event_link" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "sessionId" uuid NOT NULL,
    "selectionId" uuid NOT NULL,
    "deviceId" uuid,
    "eventUid" text NOT NULL,
    "externalEventId" text,
    "providerRevision" text,
    "syncState" text NOT NULL,
    "operationId" uuid NOT NULL,
    "lastError" text,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "calendar_event_link_session_selection_idx" ON "calendar_event_link" USING btree ("sessionId", "selectionId");
CREATE INDEX "calendar_event_link_owner_device_idx" ON "calendar_event_link" USING btree ("ownerId", "deviceId", "syncState");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "calendar_selection" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "connectionId" uuid NOT NULL,
    "externalCalendarId" text NOT NULL,
    "deviceId" uuid,
    "name" text NOT NULL,
    "accountName" text,
    "readOnly" boolean NOT NULL,
    "useForConflicts" boolean NOT NULL DEFAULT false,
    "useForWrites" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "calendar_selection_connection_calendar_idx" ON "calendar_selection" USING btree ("connectionId", "externalCalendarId");
CREATE INDEX "calendar_selection_owner_idx" ON "calendar_selection" USING btree ("ownerId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "planner_preferences" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "horizon" text NOT NULL,
    "weekdays" json NOT NULL,
    "windowStartMinute" bigint NOT NULL,
    "windowEndMinute" bigint NOT NULL,
    "sessionMinutes" bigint NOT NULL,
    "maxSessions" bigint NOT NULL,
    "bufferMinutes" bigint NOT NULL,
    "minLeadMinutes" bigint NOT NULL,
    "timezone" text NOT NULL,
    "approvalMode" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "planner_preferences_owner_idx" ON "planner_preferences" USING btree ("ownerId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "review_plan" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "horizonStart" timestamp without time zone NOT NULL,
    "horizonEnd" timestamp without time zone NOT NULL,
    "timezone" text NOT NULL,
    "coverage" json NOT NULL,
    "availabilityVerified" boolean NOT NULL,
    "commitOperationId" uuid,
    "committedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "review_plan_owner_created_idx" ON "review_plan" USING btree ("ownerId", "createdAt");
CREATE UNIQUE INDEX "review_plan_owner_operation_idx" ON "review_plan" USING btree ("ownerId", "commitOperationId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "review_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "planId" uuid,
    "startAt" timestamp without time zone NOT NULL,
    "endAt" timestamp without time zone NOT NULL,
    "timezone" text NOT NULL,
    "status" text NOT NULL,
    "schedulingMode" text NOT NULL,
    "availabilityVerified" boolean NOT NULL,
    "planRevision" bigint NOT NULL DEFAULT 1,
    "lastOperationId" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "review_session_owner_start_idx" ON "review_session" USING btree ("ownerId", "startAt");
CREATE INDEX "review_session_plan_idx" ON "review_session" USING btree ("planId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "session_item" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "sessionId" uuid NOT NULL,
    "itemId" uuid NOT NULL,
    "position" bigint NOT NULL,
    "plannedMinutes" bigint NOT NULL,
    "estimated" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "session_item_session_position_idx" ON "session_item" USING btree ("sessionId", "position");
CREATE UNIQUE INDEX "session_item_session_item_idx" ON "session_item" USING btree ("sessionId", "itemId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "calendar_connection"
    ADD CONSTRAINT "calendar_connection_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "calendar_event_link"
    ADD CONSTRAINT "calendar_event_link_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "calendar_event_link"
    ADD CONSTRAINT "calendar_event_link_fk_1"
    FOREIGN KEY("sessionId")
    REFERENCES "review_session"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "calendar_event_link"
    ADD CONSTRAINT "calendar_event_link_fk_2"
    FOREIGN KEY("selectionId")
    REFERENCES "calendar_selection"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "calendar_selection"
    ADD CONSTRAINT "calendar_selection_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "calendar_selection"
    ADD CONSTRAINT "calendar_selection_fk_1"
    FOREIGN KEY("connectionId")
    REFERENCES "calendar_connection"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "planner_preferences"
    ADD CONSTRAINT "planner_preferences_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "review_plan"
    ADD CONSTRAINT "review_plan_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "review_session"
    ADD CONSTRAINT "review_session_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "review_session"
    ADD CONSTRAINT "review_session_fk_1"
    FOREIGN KEY("planId")
    REFERENCES "review_plan"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "session_item"
    ADD CONSTRAINT "session_item_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "session_item"
    ADD CONSTRAINT "session_item_fk_1"
    FOREIGN KEY("sessionId")
    REFERENCES "review_session"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "session_item"
    ADD CONSTRAINT "session_item_fk_2"
    FOREIGN KEY("itemId")
    REFERENCES "item"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR pinne
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('pinne', '20261006095518982', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261006095518982', "timestamp" = now();

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
