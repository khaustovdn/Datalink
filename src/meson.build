datalink_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
  'file-reader.vala',
  'tokenizer.vala',
  'serializer.vala',
  'user.vala',
  'option.vala',
  'authenticator.vala',
]

datalink_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('gee-0.8'),
]

datalink_sources += gnome.compile_resources('datalink-resources',
  'datalink.gresource.xml',
  c_name: 'datalink'
)

executable('datalink', datalink_sources,
  dependencies: datalink_deps,
       install: true,
)
