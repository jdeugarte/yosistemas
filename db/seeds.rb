# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
publico = Grupo.create(nombre: 'Publico', descripcion: 'todos deben tener ingreso a temas publicos', estado: false, llave: "publico")
docente = Usuario.create(nombre_usuario: "docente", nombre: "docente", apellido: "seed", contrasenia: "123456", correo: "docente@gmail.com", activa: true, rol: "Docente")
estudiante = Usuario.create(nombre_usuario: "estudiante", nombre: "estudiante", apellido: "seed", contrasenia: "123456", correo: "estudiante@gmail.com", activa: true, rol: "Estudiante")