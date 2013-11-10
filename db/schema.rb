# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131110143052) do

  create_table "adjuntos_comentarios", force: true do |t|
    t.integer  "tema_comentario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "archivo_file_name"
    t.string   "archivo_content_type"
    t.integer  "archivo_file_size"
    t.datetime "archivo_updated_at"
  end

  add_index "adjuntos_comentarios", ["tema_comentario_id"], name: "index_adjuntos_comentarios_on_tema_comentario_id"

  create_table "archivo_adjunto_comentarios", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archivo_adjunto_respuesta", force: true do |t|
    t.integer  "responder_tarea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "archivo_file_name"
    t.string   "archivo_content_type"
    t.integer  "archivo_file_size"
    t.datetime "archivo_updated_at"
  end

  add_index "archivo_adjunto_respuesta", ["responder_tarea_id"], name: "index_archivo_adjunto_respuesta_on_responder_tarea_id"

  create_table "archivo_adjunto_respuestas", force: true do |t|
    t.integer  "responder_tarea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "archivo_file_name"
    t.string   "archivo_content_type"
    t.integer  "archivo_file_size"
    t.datetime "archivo_updated_at"
  end

  add_index "archivo_adjunto_respuestas", ["responder_tarea_id"], name: "index_archivo_adjunto_respuestas_on_responder_tarea_id"

  create_table "archivo_adjunto_temas", force: true do |t|
    t.integer  "tema_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "archivo_file_name"
    t.string   "archivo_content_type"
    t.integer  "archivo_file_size"
    t.datetime "archivo_updated_at"
  end

  add_index "archivo_adjunto_temas", ["tema_id"], name: "index_archivo_adjunto_temas_on_tema_id"

  create_table "archivo_adjuntos", force: true do |t|
    t.integer  "tarea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "archivo_file_name"
    t.string   "archivo_content_type"
    t.integer  "archivo_file_size"
    t.datetime "archivo_updated_at"
  end

  add_index "archivo_adjuntos", ["tarea_id"], name: "index_archivo_adjuntos_on_tarea_id"

  create_table "grupos", force: true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.boolean  "estado"
    t.string   "llave"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grupos", ["usuario_id"], name: "index_grupos_on_usuario_id"

  create_table "notificacion_grupos", force: true do |t|
    t.boolean  "notificado"
    t.integer  "subscripcion_id"
    t.integer  "tarea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notificacion_grupos", ["subscripcion_id"], name: "index_notificacion_grupos_on_subscripcion_id"
  add_index "notificacion_grupos", ["tarea_id"], name: "index_notificacion_grupos_on_tarea_id"

  create_table "notificacions", force: true do |t|
    t.boolean  "notificado"
    t.integer  "suscripcion_tema_id"
    t.integer  "tema_comentario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notificacions", ["suscripcion_tema_id"], name: "index_notificacions_on_suscripcion_tema_id"
  add_index "notificacions", ["tema_comentario_id"], name: "index_notificacions_on_tema_comentario_id"

  create_table "responder_tareas", force: true do |t|
    t.string   "descripcion"
    t.integer  "usuario_id"
    t.integer  "tarea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responder_tareas", ["tarea_id"], name: "index_responder_tareas_on_tarea_id"
  add_index "responder_tareas", ["usuario_id"], name: "index_responder_tareas_on_usuario_id"

  create_table "solicitud_contrasenia", force: true do |t|
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "solicitud_contrasenia", ["usuario_id"], name: "index_solicitud_contrasenia_on_usuario_id"

  create_table "subscripcions", force: true do |t|
    t.string   "llave"
    t.integer  "usuario_id"
    t.integer  "grupo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscripcions", ["grupo_id"], name: "index_subscripcions_on_grupo_id"
  add_index "subscripcions", ["usuario_id"], name: "index_subscripcions_on_usuario_id"

  create_table "suscripcion_temas", force: true do |t|
    t.integer  "tema_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suscripcion_temas", ["tema_id"], name: "index_suscripcion_temas_on_tema_id"
  add_index "suscripcion_temas", ["usuario_id"], name: "index_suscripcion_temas_on_usuario_id"

  create_table "tarea_comentarios", force: true do |t|
    t.text     "cuerpo"
    t.integer  "tarea_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tarea_comentarios", ["tarea_id"], name: "index_tarea_comentarios_on_tarea_id"
  add_index "tarea_comentarios", ["usuario_id"], name: "index_tarea_comentarios_on_usuario_id"

  create_table "tareas", force: true do |t|
    t.string   "titulo"
    t.string   "descripcion"
    t.date     "fecha_entrega"
    t.integer  "grupo_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "hora_entrega"
  end

  add_index "tareas", ["grupo_id"], name: "index_tareas_on_grupo_id"
  add_index "tareas", ["usuario_id"], name: "index_tareas_on_usuario_id"

  create_table "tema_comentarios", force: true do |t|
    t.text     "cuerpo"
    t.integer  "tema_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tema_comentarios", ["tema_id"], name: "index_tema_comentarios_on_tema_id"
  add_index "tema_comentarios", ["usuario_id"], name: "index_tema_comentarios_on_usuario_id"

  create_table "temas", force: true do |t|
    t.string   "titulo"
    t.text     "cuerpo"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "visible",    default: 1, null: false
    t.integer  "grupo_id"
  end

  add_index "temas", ["grupo_id"], name: "index_temas_on_grupo_id"
  add_index "temas", ["usuario_id"], name: "index_temas_on_usuario_id"

  create_table "usuarios", force: true do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.string   "contrasenia"
    t.string   "correo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activa",                   default: false
    t.integer  "grupo_id"
    t.integer  "solicitud_contrasenia_id"
    t.string   "rol"
    t.string   "nombre_usuario"
  end

  add_index "usuarios", ["grupo_id"], name: "index_usuarios_on_grupo_id"

end
