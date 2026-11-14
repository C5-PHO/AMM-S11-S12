import 'package:flutter/cupertino.dart';
import 'data/datos_academicos.dart';

void main() => runApp(const MyApp());
const purple = Color(0xff5942ce);

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _App();
}

class _App extends State<MyApp> {
  final data = DatosAcademicos();
  @override
  Widget build(BuildContext c) => CupertinoApp(
    debugShowCheckedModeBanner: false,
    theme: const CupertinoThemeData(
      primaryColor: purple,
      brightness: Brightness.light,
    ),
    routes: {
      '/': (_) => Login(data),
      '/menu': (_) => Menu(data),
      '/alumnos': (_) => Students(data),
      '/registro': (_) => EditStudent(data),
      '/perfil': (_) => Profile(data),
      '/recursos': (_) => const Resources(),
    },
  );
}

Widget screen(String title, Widget child) => CupertinoPageScaffold(
  navigationBar: CupertinoNavigationBar(middle: Text(title)),
  child: SafeArea(
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: child,
      ),
    ),
  ),
);
Widget box(Widget child) => Container(
  margin: const EdgeInsets.only(bottom: 12),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: CupertinoColors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: CupertinoColors.systemGrey5),
  ),
  child: child,
);
Widget input(
  TextEditingController c,
  String hint, {
  Key? key,
  bool secret = false,
}) => Padding(
  padding: const EdgeInsets.only(bottom: 12),
  child: CupertinoTextField(
    key: key,
    controller: c,
    placeholder: hint,
    obscureText: secret,
    padding: const EdgeInsets.all(14),
  ),
);
bool emailOK(String s) =>
    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(s.trim());

class Login extends StatefulWidget {
  const Login(this.data, {super.key});
  final DatosAcademicos data;
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final email = TextEditingController(), pass = TextEditingController();
  String error = '';
  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => screen(
    'Aula',
    ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 40),
        const Icon(CupertinoIcons.person_2_fill, size: 72, color: purple),
        const SizedBox(height: 20),
        const Text(
          'Iniciar sesión',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        input(email, 'Correo electrónico', key: const Key('login-email')),
        input(
          pass,
          'Contraseña',
          key: const Key('login-password'),
          secret: true,
        ),
        Text(error, style: const TextStyle(color: CupertinoColors.systemRed)),
        CupertinoButton.filled(
          onPressed: () {
            if (!emailOK(email.text) || pass.text.length < 6) {
              setState(
                () => error =
                    'Ingresa un correo válido y una contraseña de al menos 6 caracteres',
              );
              return;
            }
            Navigator.pushReplacementNamed(c, '/menu');
          },
          child: const Text('Ingresar'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Acceso de demostración sin servidor.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class Menu extends StatefulWidget {
  const Menu(this.data, {super.key});
  final DatosAcademicos data;
  @override
  State<Menu> createState() => _Menu();
}

class _Menu extends State<Menu> {
  Future<void> open(String route) async {
    await Navigator.pushNamed(context, route);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext c) => screen(
    'Mi aula',
    ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Hola, ${widget.data.perfil['nombre']!.split(' ').first}',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text('${widget.data.alumnos.length} alumnos en tu aula'),
        const SizedBox(height: 24),
        box(
          Column(
            children: [
              for (final item in [
                (
                  'Registrar alumno',
                  '/registro',
                  CupertinoIcons.person_badge_plus,
                ),
                ('Listar alumnos', '/alumnos', CupertinoIcons.person_2),
                ('Perfil', '/perfil', CupertinoIcons.person_crop_circle),
                ('Fuentes e imágenes', '/recursos', CupertinoIcons.photo),
              ])
                CupertinoListTile(
                  title: Text(item.$1),
                  leading: Icon(item.$3, color: purple),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => open(item.$2),
                ),
            ],
          ),
        ),
        CupertinoButton(
          onPressed: () =>
              Navigator.pushNamedAndRemoveUntil(c, '/', (_) => false),
          child: const Text('Cerrar sesión'),
        ),
      ],
    ),
  );
}

class EditStudent extends StatefulWidget {
  const EditStudent(this.data, {super.key, this.student});
  final DatosAcademicos data;
  final Map<String, dynamic>? student;
  @override
  State<EditStudent> createState() => _EditStudent();
}

class _EditStudent extends State<EditStudent> {
  late final TextEditingController name, surname, grade;
  String error = '';
  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.student?['nombre']);
    surname = TextEditingController(text: widget.student?['apellido']);
    grade = TextEditingController(text: widget.student?['nota']?.toString());
  }

  @override
  void dispose() {
    name.dispose();
    surname.dispose();
    grade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => screen(
    widget.student == null ? 'Registrar alumno' : 'Editar alumno',
    ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(CupertinoIcons.person_badge_plus, size: 56, color: purple),
        const SizedBox(height: 24),
        input(name, 'Nombre', key: const Key('student-name')),
        input(surname, 'Apellido', key: const Key('student-surname')),
        input(grade, 'Nota (0 - 20)', key: const Key('student-grade')),
        Text(error, style: const TextStyle(color: CupertinoColors.systemRed)),
        CupertinoButton.filled(
          onPressed: () {
            final n = double.tryParse(grade.text.trim().replaceAll(',', '.'));
            if (name.text.trim().isEmpty ||
                surname.text.trim().isEmpty ||
                n == null ||
                !n.isFinite ||
                n < 0 ||
                n > 20) {
              setState(
                () =>
                    error = 'Ingresa nombre, apellido y una nota entre 0 y 20',
              );
              return;
            }
            final a = <String, dynamic>{
              'nombre': name.text.trim(),
              'apellido': surname.text.trim(),
              'nota': n,
              'imagen': widget.student?['imagen'] ?? 'ana.png',
            };
            if (widget.student == null) {
              widget.data.alumnos.add(a);
            } else {
              widget.student!.addAll(a);
            }
            Navigator.pop(c);
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}

class Students extends StatefulWidget {
  const Students(this.data, {super.key});
  final DatosAcademicos data;
  @override
  State<Students> createState() => _Students();
}

class _Students extends State<Students> {
  String query = '';
  Future<void> options(Map<String, dynamic> a) async {
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (c) => CupertinoActionSheet(
        title: Text('${a['nombre']} ${a['apellido']}'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(c, 'edit'),
            child: const Text('Editar'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(c, 'delete'),
            child: const Text('Eliminar'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(c),
          child: const Text('Cancelar'),
        ),
      ),
    );
    if (!mounted) return;
    if (action == 'edit') {
      await Navigator.push(
        context,
        CupertinoPageRoute<void>(
          builder: (_) => EditStudent(widget.data, student: a),
        ),
      );
      if (mounted) setState(() {});
    } else if (action == 'delete') {
      final ok = await showCupertinoDialog<bool>(
        context: context,
        builder: (c) => CupertinoAlertDialog(
          title: const Text('Eliminar alumno'),
          content: Text('¿Eliminar a ${a['nombre']} ${a['apellido']}?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Cancelar'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );
      if (ok == true && mounted) setState(() => widget.data.alumnos.remove(a));
    }
  }

  @override
  Widget build(BuildContext c) {
    final list = widget.data.alumnos
        .where(
          (a) => '${a['nombre']} ${a['apellido']}'.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    return screen(
      'Alumnos',
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CupertinoSearchTextField(
              placeholder: 'Buscar por nombre o apellido',
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('No se encontraron alumnos'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: list.length,
                    itemBuilder: (c, i) {
                      final a = list[i];
                      return box(
                        CupertinoListTile(
                          leading: ClipOval(
                            child: Image.asset(
                              'assets/images/${a['imagen']}',
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text('${a['nombre']} ${a['apellido']}'),
                          subtitle: Text(
                            'Nota: ${a['nota']} / 20 · ${widget.data.aprobado(a) ? 'Aprobado' : 'Desaprobado'}',
                          ),
                          trailing: const Icon(
                            CupertinoIcons.ellipsis_circle,
                            color: purple,
                          ),
                          onTap: () => options(a),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile(this.data, {super.key});
  final DatosAcademicos data;
  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext c) {
    final p = widget.data.perfil;
    return screen(
      'Perfil',
      ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(
            CupertinoIcons.person_crop_circle_fill,
            size: 90,
            color: purple,
          ),
          Text(
            p['nombre']!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(p['rol']!, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          box(
            Column(
              children: [
                CupertinoListTile(
                  title: const Text('Correo'),
                  subtitle: Text(p['email']!),
                ),
                CupertinoListTile(
                  title: const Text('Teléfono'),
                  subtitle: Text(p['telefono']!),
                ),
              ],
            ),
          ),
          CupertinoButton.filled(
            onPressed: () async {
              await Navigator.push(
                c,
                CupertinoPageRoute<void>(
                  builder: (_) => EditProfile(widget.data),
                ),
              );
              if (mounted) setState(() {});
            },
            child: const Text('Editar perfil'),
          ),
        ],
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile(this.data, {super.key});
  final DatosAcademicos data;
  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  late final TextEditingController name, email, phone;
  String error = '';
  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.data.perfil['nombre']);
    email = TextEditingController(text: widget.data.perfil['email']);
    phone = TextEditingController(text: widget.data.perfil['telefono']);
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => screen(
    'Editar perfil',
    ListView(
      padding: const EdgeInsets.all(24),
      children: [
        input(name, 'Nombre'),
        input(email, 'Correo'),
        input(phone, 'Teléfono'),
        Text(error, style: const TextStyle(color: CupertinoColors.systemRed)),
        CupertinoButton.filled(
          onPressed: () {
            if (name.text.trim().isEmpty ||
                !emailOK(email.text) ||
                !RegExp(r'^\d{9}$').hasMatch(phone.text.trim())) {
              setState(
                () => error =
                    'Ingresa nombre, correo válido y teléfono de 9 dígitos',
              );
              return;
            }
            widget.data.perfil.addAll({
              'nombre': name.text.trim(),
              'email': email.text.trim(),
              'telefono': phone.text.trim(),
            });
            Navigator.pop(c);
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}

class Resources extends StatelessWidget {
  const Resources({super.key});
  @override
  Widget build(BuildContext c) => screen(
    'Fuentes e imágenes',
    ListView(
      padding: const EdgeInsets.all(20),
      children: [
        box(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fuentes personalizadas',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Texto con fuente Jacquard Regular',
                style: TextStyle(fontFamily: 'Jacquard', fontSize: 24),
              ),
              SizedBox(height: 16),
              Text(
                'Texto con fuente Roboto Bold',
                style: TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16),
              Text('Texto con fuente normal Hugo Renzo'),
            ],
          ),
        ),
        const Text('Imágenes locales', style: TextStyle(fontSize: 22)),
        for (final name in ['ana.png', 'luis.png', 'carlos.png', 'docente.png'])
          box(
            Image.asset(
              'assets/images/$name',
              height: 180,
              fit: BoxFit.contain,
            ),
          ),
      ],
    ),
  );
}
