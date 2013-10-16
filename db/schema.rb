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

ActiveRecord::Schema.define(version: 20131013224210) do

  create_table "comments", force: true do |t|
    t.text     "body"
    t.integer  "tema_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["tema_id"], name: "index_comments_on_tema_id"
  add_index "comments", ["usuario_id"], name: "index_comments_on_usuario_id"

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

  create_table "passwords_requests", force: true do |t|
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "passwords_requests", ["usuario_id"], name: "index_passwords_requests_on_usuario_id"

  create_table "subscriptions", force: true do |t|
    t.string   "llave"
    t.integer  "usuario_id"
    t.integer  "grupo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["grupo_id"], name: "index_subscriptions_on_grupo_id"
  add_index "subscriptions", ["usuario_id"], name: "index_subscriptions_on_usuario_id"

  create_table "suscripcion_temas", force: true do |t|
    t.integer  "tema_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suscripcion_temas", ["tema_id"], name: "index_suscripcion_temas_on_tema_id"
  add_index "suscripcion_temas", ["usuario_id"], name: "index_suscripcion_temas_on_usuario_id"

  create_table "tareas", force: true do |t|
    t.string   "titulo"
    t.string   "descripcion"
    t.date     "fecha_entrega"
    t.integer  "grupo_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tareas", ["grupo_id"], name: "index_tareas_on_grupo_id"
  add_index "tareas", ["usuario_id"], name: "index_tareas_on_usuario_id"

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
    t.string   "contrasenia_de_confirmacion"
    t.string   "correo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activa",                      default: false
    t.integer  "grupo_id"
    t.integer  "passwords_request_id"
    t.string   "rol"
  end

  add_index "usuarios", ["grupo_id"], name: "index_usuarios_on_grupo_id"

end
