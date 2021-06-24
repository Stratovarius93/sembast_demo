import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_demo/db/app_theme.dart';
import 'package:sembast_demo/db/users_store.dart';
import 'package:sembast_demo/models/user.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> _users = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    this._load();
    super.initState();
  }

  _load() async {
    final Finder finder = Finder(sortOrders: [SortOrder('name')]);
    this._users = await UsersStore.instance.find(finder: finder);
    setState(() {});
  }

  _deleteUser(User user) async {
    final Finder finder = Finder(filter: Filter.byKey(user.id));
    await UsersStore.instance.delete(finder: finder);
    final SnackBar snackbar = SnackBar(content: Text('User deleted'));
    //_scaffoldKey.currentState!.showSnackBar(snackbar);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    this._load();
  }

  //_add() async {
  //final User user = User.fake();
  //await UsersStore.instance.add(user);
  //this._users.add(user);
  //setState(() {});
  //}

  //_delete() async {
  //final int count = await UsersStore.instance.delete();
  //final SnackBar snackbar = SnackBar(content: Text('$count item deleted'));
  //_scaffoldKey.currentState!.showSnackBar(snackbar);
  //this._load();
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            //onPressed: this._delete,
            onPressed: () async {
              final Finder finder =
                  Finder(filter: Filter.greaterThan('age', 40));
              final int count =
                  await UsersStore.instance.delete(finder: finder);
              final SnackBar snackbar =
                  SnackBar(content: Text('$count item deleted'));
              //_scaffoldKey.currentState!.showSnackBar(snackbar);
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              this._load();
            },
            child: Icon(
              Icons.clear_all,
              color: Colors.white,
            ),
            backgroundColor: Colors.redAccent,
            heroTag: 'clear',
          ),
          SizedBox(
            width: 16,
          ),
          FloatingActionButton(
            //onPressed: this._delete,
            onPressed: this._load,
            child: Icon(
              Icons.replay,
              color: Colors.white,
            ),
            backgroundColor: Colors.greenAccent,
            heroTag: 'clear',
          ),
          SizedBox(
            width: 16,
          ),
          FloatingActionButton(
            //onPressed: this._add,
            onPressed: () async {
              final User user = User.fake();
              await UsersStore.instance.add(user);
              this._users.add(user);
              setState(() {});
            },
            child: Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
            heroTag: 'add',
          ),
        ],
      ),
      appBar: AppBar(
        actions: [
          Switch(
              value: MyAppTheme.instance.darkEnable,
              onChanged: (bool value) {
                MyAppTheme.instance.change(value);
              })
        ],
      ),
      body: ListView.builder(
        itemCount: this._users.length,
        itemBuilder: (context, index) {
          final User _user = this._users[index];
          return ListTile(
            title: Text(_user.name),
            subtitle: Text('age: ${_user.age} email: ${_user.email}'),
            trailing: IconButton(
                onPressed: () {
                  _deleteUser(_user);
                },
                icon: Icon(Icons.delete)),
          );
        },
      ),
    );
  }
}
