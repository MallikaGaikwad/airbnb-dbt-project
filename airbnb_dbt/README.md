# Airbnb dbt project (`airbnb_dbt`)

dbt models and configuration for an Airbnb-style analytics pipeline. Raw data lives in a declared **source** layer; the **bronze** layer exposes thin views on top of those tables.

## Project configuration

| Setting | Value |
|--------|--------|
| **Project name** | `airbnb_dbt` |
| **Version** | `1.0.0` |
| **dbt profile** | `airbnb_dbt` (configure in your local `~/.dbt/profiles.yml`) |

Model paths follow the dbt defaults: `models/`, `macros/`, `tests/`, `seeds/`, `analyses/`, `snapshots/`.

## Custom schema naming

The project overrides dbt’s default `generate_schema_name` behavior in `macros/generate_schema_name.sql`:

- If a model sets a **custom schema** (e.g. `bronze_layer`), that name is used **as the full schema name** (no `{{ target.schema }}_` prefix).
- If no custom schema is set, models use **`target.schema`** from your active dbt target.

Together with `dbt_project.yml`, bronze models are built into the **`bronze_layer`** schema (not the default `target_schema` + `_bronze_layer` pattern).

## Data sources

Sources are defined in `models/sources/sources.yml`.

| Property | Value |
|----------|--------|
| **Source name** | `source_schema` |
| **Database** | `airbnb_db` |
| **Schema** | `source_schema` |

### Source tables

| Table | dbt reference | Description |
|-------|-----------------|-------------|
| `listings` | `{{ source('source_schema', 'listings') }}` | All listings data |
| `bookings` | `{{ source('source_schema', 'bookings') }}` | All bookings data |
| `hosts` | `{{ source('source_schema', 'hosts') }}` | Airbnb hosts data |

Upstream objects in the warehouse: **`airbnb_db.source_schema.listings`**, **`bookings`**, **`hosts`**.

## Bronze layer

Configured in `dbt_project.yml` under `models.airbnb_dbt.bronze_layer`:

| Setting | Value |
|---------|--------|
| **Materialization** | `view` |
| **Custom schema** | `bronze_layer` |

### Bronze models

All bronze models are **`select *`** pass-throughs from the matching source table.

| Model file | Built object (typical) | Source |
|------------|-------------------------|--------|
| `models/bronze_layer/bronze_listings.sql` | `bronze_layer.bronze_listings` (view) | `source_schema.listings` |
| `models/bronze_layer/bronze_bookings.sql` | `bronze_layer.bronze_bookings` (view) | `source_schema.bookings` |
| `models/bronze_layer/bronze_hosts.sql` | `bronze_layer.bronze_hosts` (view) | `source_schema.hosts` |

Exact database/catalog depends on your warehouse and `profiles.yml` target.

## Layer summary

```text
airbnb_db.source_schema          bronze_layer (views)
─────────────────────          ─────────────────────
listings        ───────────►  bronze_listings
bookings        ───────────►  bronze_bookings
hosts           ───────────►  bronze_hosts
```

## Common commands

```bash
dbt debug          # verify profile and connection
dbt run            # build models (bronze views)
dbt test           # run tests (add tests under tests/ or in YAML as you grow the project)
dbt docs generate && dbt docs serve   # lineage and documentation
```

## Resources

- [dbt documentation](https://docs.getdbt.com/docs/introduction)
- [Discourse](https://discourse.getdbt.com/)
- [dbt community Slack](https://community.getdbt.com/)
