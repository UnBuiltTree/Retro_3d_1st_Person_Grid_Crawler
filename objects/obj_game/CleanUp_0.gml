
// Free rendering surfaces
if (surface_exists(texd_surface_current)) surface_free(texd_surface_current);
if (surface_exists(texd_surface_from   )) surface_free(texd_surface_from);
if (surface_exists(texd_surface_to     )) surface_free(texd_surface_to);

cleanup_all_entities();

instance_destroy(obj_dungeon_generator)
instance_destroy(obj_UI)

