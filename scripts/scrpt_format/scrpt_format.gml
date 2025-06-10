function vertex_format_position_3d_color_texture() {
    var fmt = vertex_format_begin();
    vertex_format_add_position_3d();
    vertex_format_add_colour();
    vertex_format_add_texcoord();
    return vertex_format_end();
}


function wall_format() {
    var u0 = 0, v0 = 0, u1 = 1, v1 = 1;

    var w = tile_width;
    var d = tile_width;
    var h = tile_tall;

    global.vb_wall = vertex_create_buffer();
    vertex_begin(global.vb_wall, global.vf_wall);

    // FRONT face (y = 0)
    vertex_position_3d(global.vb_wall, 0, 0, 0);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u0, v1);

    vertex_position_3d(global.vb_wall, w, 0, 0);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u1, v1);

    vertex_position_3d(global.vb_wall, 0, 0, h);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u0, v0);

    vertex_position_3d(global.vb_wall, w, 0, h);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u1, v0);

    // BACK face (y = d)
    vertex_position_3d(global.vb_wall, w, d, 0);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u0, v1);

    vertex_position_3d(global.vb_wall, 0, d, 0);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u1, v1);

    vertex_position_3d(global.vb_wall, w, d, h);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u0, v0);

    vertex_position_3d(global.vb_wall, 0, d, h);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u1, v0);

    // LEFT face (x = 0)
    vertex_position_3d(global.vb_wall, 0, d, 0);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u0, v1);

    vertex_position_3d(global.vb_wall, 0, 0, 0);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u1, v1);

    vertex_position_3d(global.vb_wall, 0, d, h);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u0, v0);

    vertex_position_3d(global.vb_wall, 0, 0, h);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u1, v0);

    // RIGHT face (x = w)
    vertex_position_3d(global.vb_wall, w, 0, 0);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u0, v1);

    vertex_position_3d(global.vb_wall, w, d, 0);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u1, v1);

    vertex_position_3d(global.vb_wall, w, 0, h);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u0, v0);

    vertex_position_3d(global.vb_wall, w, d, h);
    vertex_colour(global.vb_wall, c_white, 1);
    vertex_texcoord(global.vb_wall, u1, v0);

    vertex_end(global.vb_wall);
}

function draw_wall(_x, _y, _spr, _col) {
    var tex = sprite_get_texture(_spr, 0);
    var uv  = sprite_get_uvs(_spr, 0);
    var u0 = uv[0], v0 = uv[1], u1 = uv[2], v1 = uv[3];

    var w = tile_width;
    var d = tile_width;
    var h = tile_tall;

    var vb = vertex_create_buffer();
    vertex_begin(vb, global.vf_quad);  // Assume vf_quad includes position, color, texcoord

    // === FRONT face ===
    vertex_position_3d(vb, 0, 0, 0); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v0);
    vertex_position_3d(vb, w, 0, 0); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v0);
    vertex_position_3d(vb, 0, 0, h); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v1);

    vertex_position_3d(vb, w, 0, 0); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v0);
    vertex_position_3d(vb, w, 0, h); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v1);
    vertex_position_3d(vb, 0, 0, h); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v1);

    // === BACK face ===
    vertex_position_3d(vb, w, d, 0); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v0);
    vertex_position_3d(vb, 0, d, 0); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v0);
    vertex_position_3d(vb, w, d, h); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v1);

    vertex_position_3d(vb, 0, d, 0); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v0);
    vertex_position_3d(vb, 0, d, h); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v1);
    vertex_position_3d(vb, w, d, h); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v1);

    // === LEFT face ===
    vertex_position_3d(vb, 0, d, 0); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v0);
    vertex_position_3d(vb, 0, 0, 0); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v0);
    vertex_position_3d(vb, 0, d, h); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v1);

    vertex_position_3d(vb, 0, 0, 0); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v0);
    vertex_position_3d(vb, 0, 0, h); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v1);
    vertex_position_3d(vb, 0, d, h); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v1);

    // === RIGHT face ===
    vertex_position_3d(vb, w, 0, 0); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v0);
    vertex_position_3d(vb, w, d, 0); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v0);
    vertex_position_3d(vb, w, 0, h); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v1);

    vertex_position_3d(vb, w, d, 0); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v0);
    vertex_position_3d(vb, w, d, h); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v1);
    vertex_position_3d(vb, w, 0, h); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v1);

    vertex_end(vb);

    var mat = matrix_build(_x, _y, 0, 0, 0, 0, 1, 1, 1);
    matrix_set(matrix_world, mat);
    vertex_submit(vb, pr_trianglelist, tex);
    matrix_set(matrix_world, matrix_build_identity());

    vertex_delete_buffer(vb);
}

function draw_floor(_x, _y, _z, _spr, _col) {
    var tex = sprite_get_texture(_spr, 0);
    var uv  = sprite_get_uvs(_spr, 0);
    var u0 = uv[0], v0 = uv[1], u1 = uv[2], v1 = uv[3];

    var w = tile_width;
    var h = tile_width;

    var vb = vertex_create_buffer();
    vertex_begin(vb, global.vf_quad);

    // Floor lies on x, y at height _z
    vertex_position_3d(vb, _x,     _y + h, _z); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v1);
    vertex_position_3d(vb, _x,     _y,     _z); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u0, v0);
    vertex_position_3d(vb, _x + w, _y + h, _z); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v1);
    vertex_position_3d(vb, _x + w, _y,     _z); vertex_colour(vb, _col, 1); vertex_texcoord(vb, u1, v0);

    vertex_end(vb);
    vertex_submit(vb, pr_trianglestrip, tex);
    vertex_delete_buffer(vb);
}

function draw_pane(_x, _y, _ang, _spr, _col) {
    var tex = sprite_get_texture(_spr, 0);
    var uv  = sprite_get_uvs(_spr, 0);
    var u0 = uv[0], v0 = uv[1], u1 = uv[2], v1 = uv[3];

    var w = tile_width;
    var h = tile_tall;

    var dx = dcos(_ang);
    var dy = -dsin(_ang);
    var half = w * 0.5;

    var x1 = _x + half + dx * half;
    var y1 = _y + half + dy * half;

    var x2 = _x + half - dx * half;
    var y2 = _y + half - dy * half;

    var vb = vertex_create_buffer();
    vertex_begin(vb, global.vf_quad);

    // Bottom-left
    vertex_position_3d(vb, x1, y1, 0);
    vertex_colour(vb, _col, 1);
    vertex_texcoord(vb, u0, v0);

    // Top-left
    vertex_position_3d(vb, x1, y1, h);
    vertex_colour(vb, _col, 1);
    vertex_texcoord(vb, u0, v1);

    // Bottom-right
    vertex_position_3d(vb, x2, y2, 0);
    vertex_colour(vb, _col, 1);
    vertex_texcoord(vb, u1, v0);

    // Top-right
    vertex_position_3d(vb, x2, y2, h);
    vertex_colour(vb, _col, 1);
    vertex_texcoord(vb, u1, v1);

    vertex_end(vb);
    vertex_submit(vb, pr_trianglestrip, tex);
    vertex_delete_buffer(vb);
}

function draw_animated_pane(_x, _y, _ang, _spr, _frame, _col) {
    var tex = sprite_get_texture(_spr,  _frame);
    var uv  = sprite_get_uvs(_spr, _frame);
    var u0 = uv[0], v0 = uv[1], u1 = uv[2], v1 = uv[3];

    var w = tile_width;
    var h = tile_tall;

    var dx = dcos(_ang);
    var dy = -dsin(_ang);
    var half = w * 0.5;

    var x1 = _x + half + dx * half;
    var y1 = _y + half + dy * half;

    var x2 = _x + half - dx * half;
    var y2 = _y + half - dy * half;

    var vb = vertex_create_buffer();
    vertex_begin(vb, global.vf_quad);

    // Bottom-left
    vertex_position_3d(vb, x1, y1, 0);
    vertex_colour(vb, _col, 1);
    vertex_texcoord(vb, u0, v0);

    // Top-left
    vertex_position_3d(vb, x1, y1, h);
    vertex_colour(vb, _col, 1);
    vertex_texcoord(vb, u0, v1);

    // Bottom-right
    vertex_position_3d(vb, x2, y2, 0);
    vertex_colour(vb, _col, 1);
    vertex_texcoord(vb, u1, v0);

    // Top-right
    vertex_position_3d(vb, x2, y2, h);
    vertex_colour(vb, _col, 1);
    vertex_texcoord(vb, u1, v1);

    vertex_end(vb);
    vertex_submit(vb, pr_trianglestrip, tex);
    vertex_delete_buffer(vb);
}