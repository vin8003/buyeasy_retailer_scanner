import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/scanner_provider.dart';
import 'capture_session_screen.dart';

class SessionSelectionScreen extends StatefulWidget {
  const SessionSelectionScreen({super.key});

  @override
  State<SessionSelectionScreen> createState() => _SessionSelectionScreenState();
}

class _SessionSelectionScreenState extends State<SessionSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSessions();
    });
  }

  Future<void> _loadSessions() async {
    final auth = context.read<AuthProvider>();
    if (auth.token != null) {
      await context.read<ScannerProvider>().fetchActiveSessions(auth.token!);
    }
  }

  Future<void> _startNewSession() async {
    final nameController = TextEditingController();

    // Show dialog to enter name
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Session Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'Enter session name (optional)',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (_) =>
              Navigator.pop(context, nameController.text.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text('START'),
          ),
        ],
      ),
    );

    if (name == null) return; // Cancelled

    final auth = context.read<AuthProvider>();
    if (auth.token == null) return;

    try {
      if (!mounted) return;
      await context.read<ScannerProvider>().startSession(
        auth.token!,
        name: name.isEmpty ? null : name,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CaptureSessionScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _resumeSession(int sessionId) async {
    final auth = context.read<AuthProvider>();
    if (auth.token == null) return;

    try {
      await context.read<ScannerProvider>().resumeSession(
        auth.token!,
        sessionId,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CaptureSessionScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error resuming: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Session'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadSessions),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              // Navigator pop is handled by auth listener usually or handled in main.
            },
          ),
        ],
      ),
      body: Consumer<ScannerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.sessions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: _loadSessions,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: provider.isLoading ? null : _startNewSession,
                    icon: const Icon(Icons.add),
                    label: const Text('START NEW SESSION'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: provider.sessions.isEmpty
                    ? const Center(child: Text('No active sessions found'))
                    : RefreshIndicator(
                        onRefresh: _loadSessions,
                        child: ListView.builder(
                          itemCount: provider.sessions.length,
                          itemBuilder: (context, index) {
                            final session = provider.sessions[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                title: Text(
                                  session.name ??
                                      'Untitled Session #${session.id}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Created: ${session.createdAt.toLocal().toString().split('.')[0]}\nStatus: ${session.status}',
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                isThreeLine: true,
                                onTap: () => _resumeSession(session.id),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
