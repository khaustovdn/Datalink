datalink_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
  'file-reader.vala',
]

datalink_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
]

datalink_sources += gnome.compile_resources('datalink-resources',
  'datalink.gresource.xml',
  c_name: 'datalink'
)

executable('datalink', datalink_sources,
  dependencies: datalink_deps,
       install: true,
)
