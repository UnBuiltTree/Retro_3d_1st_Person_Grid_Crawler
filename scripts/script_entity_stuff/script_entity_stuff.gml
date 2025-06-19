function entity_create(_x, _y, _type, _data) {
    var entity = {
        x: _x,
        y: _y,
        type: _type,
        sprite: (variable_struct_exists(_data, "sprite") ? _data.sprite : -1),
        data: _data
    };

    var index = _y * grid_size + _x;
    ds_list_add(global.entity_grid[index], entity);
    return entity;
}

function get_entities_at(_x, _y) {
    var index = _y * grid_size + _x;
    return global.entity_grid[index];
}

function entity_remove(entity) {
    var index = entity.y * grid_size + entity.x;
    var list = global.entity_grid[index];

    for (var i = 0; i < ds_list_size(list); i++) {
        if (list[| i] == entity) {
            ds_list_delete(list, i);
            break;
        }
    }
}

function cleanup_all_entities() {
    if (is_array(global.entity_grid)) {
        var len = array_length(global.entity_grid);
        for (var i = 0; i < len; i++) {
            var lst = global.entity_grid[i];
            if (lst != undefined && ds_exists(lst, ds_type_list)) {
                ds_list_destroy(lst);
            }
        }
    }
    
    global.entity_grid = undefined;
}
