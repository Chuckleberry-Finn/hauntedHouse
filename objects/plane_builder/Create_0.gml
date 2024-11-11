vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_texcoord();
format = vertex_format_end();

vb_plane = vertex_create_buffer();
vertex_begin(vb_plane, format);

// Define vertices with positions, colors, and texture coordinates
vertex_position_3d(vb_plane, -r_w, 0, -r_h);
vertex_color(vb_plane, p_color, 1);
vertex_texcoord(vb_plane, 0, 0);

vertex_position_3d(vb_plane, r_w, 0, -r_h);
vertex_color(vb_plane, p_color, 1);
vertex_texcoord(vb_plane, 1, 0);

vertex_position_3d(vb_plane, -r_w, 0, r_h);
vertex_color(vb_plane, p_color, 1);
vertex_texcoord(vb_plane, 0, 1);

vertex_position_3d(vb_plane, -r_w, 0, r_h);
vertex_color(vb_plane, p_color, 1);
vertex_texcoord(vb_plane, 0, 1);

vertex_position_3d(vb_plane, r_w, 0, -r_h);
vertex_color(vb_plane, p_color, 1);
vertex_texcoord(vb_plane, 1, 0);

vertex_position_3d(vb_plane, r_w, 0, r_h);
vertex_color(vb_plane, p_color, 1);
vertex_texcoord(vb_plane, 1, 1);

vertex_end(vb_plane);