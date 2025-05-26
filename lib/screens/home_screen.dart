import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> _fetchTodos() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('todos')
        .select()
        .eq('user_id', user.id)
        .order('date', ascending: true);

    return response;
  }

  Future<void> _toggleDone(String id, bool current) async {
    await supabase.from('todos').update({'is_done': !current}).eq('id', id);
    setState(() {});
  }

  Future<void> _logout() async {
    await supabase.auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do Mahasiswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final todos = snapshot.data ?? [];

          if (todos.isEmpty) {
            return const Center(child: Text('Belum ada tugas'));
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Checkbox(
                    value: todo['is_done'] ?? false,
                    onChanged: (_) =>
                        _toggleDone(todo['id'], todo['is_done'] ?? false),
                  ),
                  title: Text(
                    todo['title'] ?? '',
                    style: TextStyle(
                      decoration: (todo['is_done'] ?? false)
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(todo['description'] ?? ''),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate ke halaman tambah todo
          // Navigator.pushNamed(context, '/add_todo');
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
