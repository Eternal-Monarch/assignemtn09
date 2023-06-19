import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: ProductListPage(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [
    Product(name: 'Product 1', price: '10'),
    Product(name: 'Product 2', price: '20'),
    Product(name: 'Product 3', price: '30'),
    Product(name: 'Product 4', price: '35'),
    Product(name: 'Product 5', price: '40'),
    Product(name: 'Product 6', price: '45'),
    Product(name: 'Product 7', price: '50'),
    Product(name: 'Product 8', price: '50'),
    Product(name: 'Product 9', price: '50'),
    Product(name: 'Product 10', price: '50'),
    // ... add more products here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
              child: ListTile(
                title: Text(products[index].name),
                subtitle: Text('\$${products[index].price}'),
                trailing: CounterButton(
                  onPressed: () {
                    setState(() {
                      products[index].incrementCounter(context);
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(products: products),
            ),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class Product {
  String name;
  String price;
  int counter;
  VoidCallback? onCounterReach5;

  Product({required this.name, required this.price, this.counter = 0});

  void incrementCounter(BuildContext context) {
    counter++;
    if (counter == 5) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You\'ve bought 5 $name!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (counter > 5) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Limit Reached'),
            content: Text('You have already added $name to the cart more than 5 times. You cannot add it anymore.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class CounterButton extends StatefulWidget {
  final VoidCallback onPressed;

  CounterButton({required this.onPressed});

  @override
  _CounterButtonState createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Counter: $counter',
          style: TextStyle(fontSize: 12),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              counter++;
              widget.onPressed();
            });
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(300 / 5, 35)),
          ),
          child: Text('Buy Now'),
        ),
      ],
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Product> products;

  CartPage({required this.products});

  int getTotalBoughtProducts() {
    int total = 0;
    for (Product product in products) {
      total += product.counter;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Center(
        child: Text('Total products bought: ${getTotalBoughtProducts()}'),
      ),
    );
  }
}
