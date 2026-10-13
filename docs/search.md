# Search implementation

`SearchService.keyword` is the keyword candidate source. It uses PostgreSQL
`websearch_to_tsquery('simple', ...)`, always constrains candidates by owner,
and returns field-level evidence. A semantic candidate source can later merge
at the service boundary without changing the endpoint contract.

Serverpod 4 does not model PostgreSQL expression indexes in `*.spy.yaml`, so
migration `20261007020809661` adds matching GIN indexes for item fields, user
notes, and tags as raw SQL. Later migrations regenerated `definition.sql`
without them, and Serverpod builds an empty database from the latest
`definition.sql` only, so a database created from scratch (such as a new Cloud
project) has no `*_fts_idx` indexes; one migrated step by step keeps them.
Searches still work because candidates are filtered by owner first. Restoring
the indexes needs a new migration that keeps them in `definition.sql`; keep
their expressions aligned with `SearchService` when changing searchable fields.
