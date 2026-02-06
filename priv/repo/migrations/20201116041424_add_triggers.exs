defmodule MyApp.Repo.Migrations.AddPostgresTriggerAndFunctionForAllTables do
  use Ecto.Migration

  def up do
    # Create a function that broadcasts row changes
    execute "
      CREATE OR REPLACE FUNCTION broadcast_changes()
      RETURNS trigger AS $$
      DECLARE
        current_row RECORD;
      BEGIN
        IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
          current_row := NEW;
        ELSE
          current_row := OLD;
        END IF;
        IF (TG_OP = 'INSERT') THEN
          OLD := NEW;
        END IF;
        IF (TG_OP = 'DELETE') THEN
          NEW := OLD;
        END IF;
      PERFORM pg_notify(
          'table_changes',
          json_build_object(
            'table', TG_TABLE_NAME,
            'type', TG_OP,
            'id', current_row.id,
            'new_row_data', row_to_json(NEW),
            'old_row_data', row_to_json(OLD)
          )::text
        );
      RETURN current_row;
      END;
      $$ LANGUAGE plpgsql;"

    # Create a trigger that links all of the tables to the broadcast function. Skip the migrations table.

    execute   "CREATE OR REPLACE FUNCTION create_notify_triggers()
                RETURNS event_trigger
                LANGUAGE plpgsql
                AS $$
                DECLARE
                  r RECORD;
                BEGIN
                  FOR r IN SELECT *
                           FROM information_schema.tables
                           where table_schema = 'public'
                           and table_name <> 'schema_migrations'
                  LOOP
                    RAISE NOTICE 'CREATE FOR: %', r.table_name::text;
                    EXECUTE 'DROP TRIGGER IF EXISTS notify_table_changes_trigger ON ' || r.table_name || ';';
                    EXECUTE 'CREATE TRIGGER notify_table_changes_trigger
                            AFTER INSERT OR UPDATE OR DELETE
                            ON ' || r.table_name || '
                            FOR EACH ROW
                            EXECUTE PROCEDURE broadcast_changes();';
                  END LOOP;
                END;
                $$;"

    #What if we add more tables later, after this is run? This adds a trigger to add the above triggers to any new tables as well.
    execute "CREATE EVENT TRIGGER add_table_broadcast_triggers ON ddl_command_end
              WHEN TAG IN ('CREATE TABLE','CREATE TABLE AS')
              EXECUTE PROCEDURE create_notify_triggers();"

  end

  def down do
    execute "DROP EVENT TRIGGER add_table_broadcast_triggers"

    execute "FOR r IN SELECT *
                     FROM information_schema.tables
                     where table_schema = 'public'
                     and table_name <> 'schema_migrations'
            LOOP
              RAISE NOTICE 'CREATE FOR: %', r.table_name::text;
              EXECUTE 'DROP TRIGGER IF EXISTS notify_table_changes_trigger ON ' || r.table_name || ';';
            END LOOP;"
  end
end
