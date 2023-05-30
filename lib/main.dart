import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == 'admin' && password == '123456') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ItemGridView()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  final String name;
  final double price;

  Item({required this.name, required this.price});
}

class ItemGridView extends StatefulWidget {
  @override
  _ItemGridViewState createState() => _ItemGridViewState();
}

class _ItemGridViewState extends State<ItemGridView> {
  List<Item> _items = [
    Item(name: 'Item 1', price: 10.0),
    Item(name: 'Item 2', price: 15.0),
    Item(name: 'Item 3', price: 20.0),
    Item(name: 'Item 4', price: 25.0),
    Item(name: 'Item 5', price: 30.0),
  ];

  List<Item> _cartItems = [];
  double _cartTotal = 0.0;

  void _addItemToCart(Item item) {
    setState(() {
      _cartItems.add(item);
      _cartTotal += item.price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Grid'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_items[index].name),
                SizedBox(height: 8.0),
                Text('\$${_items[index].price.toStringAsFixed(2)}'),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () => _addItemToCart(_items[index]),
                  child: Text('Add to Cart'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15),
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Cart'),
                      content: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _cartItems.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(_cartItems[index].name),
                                    trailing: Text('\$${_cartItems[index].price.toStringAsFixed(2)}'),
                                  );
                                },
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Total: \$${_cartTotal.toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              label: Text('Cart'),
              icon: Icon(Icons.shopping_cart),
            ),
          ),
          Positioned(
            child: Container(
              decoration: BoxDecoration(color: Colors.deepOrange, shape: BoxShape.circle),
              padding: EdgeInsets.all(10),
              child: Text("${_cartItems.length}", style: TextStyle(color: Colors.white)),
            ),
            right: 0,
          )
        ],
      ),
    );
  }
}
