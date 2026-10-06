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
CREATE TABLE "capture_receipt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "operationId" uuid NOT NULL,
    "clientItemId" uuid NOT NULL,
    "itemId" uuid NOT NULL,
    "requestHash" text NOT NULL,
    "duplicate" boolean NOT NULL,
    "receivedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "capture_receipt_owner_operation_idx" ON "capture_receipt" USING btree ("ownerId", "operationId");
CREATE UNIQUE INDEX "capture_receipt_owner_client_item_idx" ON "capture_receipt" USING btree ("ownerId", "clientItemId");

--
-- ACTION ALTER TABLE
--
DROP INDEX "item_owner_canonical_url_idx";
ALTER TABLE "item" ADD COLUMN "clientItemId" uuid;
ALTER TABLE "item" ADD COLUMN "sourceItemId" text;
ALTER TABLE "item" ADD COLUMN "noteText" text;
ALTER TABLE "item" ADD COLUMN "enrichmentState" text NOT NULL DEFAULT 'pending'::text;
ALTER TABLE "item" ADD COLUMN "accessState" text NOT NULL DEFAULT 'unknown'::text;
CREATE UNIQUE INDEX "item_owner_source_item_idx" ON "item" USING btree ("ownerId", "sourcePlatform", "sourceItemId");
CREATE UNIQUE INDEX "item_owner_client_item_idx" ON "item" USING btree ("ownerId", "clientItemId");
CREATE UNIQUE INDEX "item_owner_canonical_url_idx" ON "item" USING btree ("ownerId", "canonicalUrl");
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "capture_receipt"
    ADD CONSTRAINT "capture_receipt_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "capture_receipt"
    ADD CONSTRAINT "capture_receipt_fk_1"
    FOREIGN KEY("itemId")
    REFERENCES "item"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR pinne
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('pinne', '20261006091426637', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261006091426637', "timestamp" = now();

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
