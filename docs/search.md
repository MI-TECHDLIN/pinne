# Search implementation

`SearchService.keyword` is the keyword candidate source. It uses PostgreSQL
`websearch_to_tsquery('simple', ...)`, always constrains candidates by owner,
and returns field-level evidence. A semantic candidate source can later merge
at the service boundary without changing the endpoint contract.

Serverpod 4 does not model PostgreSQL expression indexes in `*.spy.yaml`, so
migration `20261007020809661` adds matching GIN indexes for item fields, user
notes, and tags as raw SQL. The same indexes are present in that migration's
`definition.sql`; keep their expressions aligned with `SearchService` when
changing searchable fields.
