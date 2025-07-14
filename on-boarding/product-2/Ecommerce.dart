import 'dart:io';

class Product {
  String _name;
  String _description;
  double _price;
  String _status;

  Product(
    String name,
    String description,
    double price, [
    String status = 'pending',
  ]) : _name = name,
       _description = description,
       _price = price,
       _status = status;

  void setDescription(String description) {
    this._description = description;
  }

  void setPrice(double price) {
    this._price = price;
  }

  void setName(String name) {
    this._name = name;
  }

  void setStatus(String status) {
    this._status = status;
  }

  String getName() {
    return this._name;
  }

  String getDescription() {
    return this._description;
  }

  double getPrice() {
    return this._price;
  }

  String getStatus() {
    return this._status;
  }
}

class ProductManager {
  Map<String, Product> _products = {};

  void addProduct(String name, String description, double price) {
    if (_products.containsKey(name)) {
      print(' Product "$name" already exists.');
      return;
    }
    Product product = Product(name, description, price);
    _products[name] = product;
  }

  void viewAllProducts() {
    if (_products.isEmpty) {
      print('No products available.');
      return;
    }

    print('--- All Products ---');
    print('---------------------------------');
    _products.forEach((key, product) {
      displayProduct(product);
    });
  }

  void viewSingleProduct(String name) {
    var product = _products[name];
    if (product != null) {
      displayProduct(product);
    } else {
      print('Product with name "$name" not found.');
    }
  }

  void viewCompletedProducts() {
    var completed = _products.values
        .where((p) => p.getStatus() == 'completed')
        .toList();
    if (completed.isEmpty) {
      print('No completed products.');
    } else {
      print('--- Completed Products ---');
      for (var p in completed) {
        displayProduct(p);
      }
    }
  }

  void viewPendingProducts() {
    var pending = _products.values
        .where((p) => p.getStatus() == 'pending')
        .toList();
    if (pending.isEmpty) {
      print('No pending products.');
    } else {
      print('--- Pending Products ---');
      for (var p in pending) {
        displayProduct(p);
      }
    }
  }

  void markAsCompleted(String name) {
    var product = _products[name];
    if (product != null) {
      product.setStatus('completed');
      print('Product "$name" marked as completed.');
    } else {
      print('Product "$name" not found.');
    }
  }

  void deleteProduct(String name) {
    _products.remove(name);
    print('Product "$name" deleted.');
  }

  void editProduct(
    String currentName, {
    required String newName,
    required String newDescription,
    required double newPrice,
  }) {
    var product = _products[currentName];
    if (product == null) {
      print('Product with name "$currentName" not found.');
      return;
    }

    // Remove old key if name is changing
    if (currentName != newName) {
      _products.remove(currentName);
    }

    // Update product fields
    product.setName(newName);
    product.setDescription(newDescription);
    product.setPrice(newPrice);

    // Add product back if name changed (under new key)
    _products[newName] = product;

    print(' Product "$currentName" updated successfully.');
  }

  void displayProduct(Product product) {
    print('--- Product Details ---');
    print('Name       : ${product.getName()}');
    print('Description: ${product.getDescription()}');
    print('Price      : \$${product.getPrice().toStringAsFixed(2)}');
    print('Status     : ${product.getStatus()}');
    print('-----------------------');
  }
}

void main() {
  final manager = ProductManager();
  int choice = -1;

  while (choice != 0) {
    print('\n===== 📱 E-Commerce Menu =====');
    print('1️⃣  Add Product');
    print('2️⃣  View All Products');
    print('3️⃣  View Single Product');
    print('4️⃣  View Completed Products');
    print('5️⃣  View Pending Products');
    print('6️⃣  Edit Product');
    print('7️⃣  Delete Product');
    print('8️⃣  Mark Product as Completed');
    print('0️⃣  Exit');
    stdout.write('\n👉 Enter your choice (0-8): ');
    final input = stdin.readLineSync() ?? '';

    switch (input) {
      case '1':
        stdout.write('Enter product name: ');
        final name = stdin.readLineSync() ?? '';
        stdout.write('Enter description: ');
        final description = stdin.readLineSync() ?? '';
        stdout.write('Enter price: ');
        final price = double.tryParse(stdin.readLineSync()!) ?? 0.0;
        manager.addProduct(name, description, price);
        break;

      case '2':
        manager.viewAllProducts();
        break;

      case '3':
        stdout.write('Enter product name to view: ');
        final name = stdin.readLineSync() ?? '';
        manager.viewSingleProduct(name);
        break;

      case '4':
        manager.viewCompletedProducts();
        break;

      case '5':
        manager.viewPendingProducts();
        break;

      case '6':
        stdout.write('Enter current name: ');
        final current = stdin.readLineSync() ?? '';
        stdout.write('Enter new name: ');
        final newName = stdin.readLineSync() ?? '';
        stdout.write('Enter new description: ');
        final newDesc = stdin.readLineSync() ?? '';
        stdout.write('Enter new price: ');
        final newPrice = double.tryParse(stdin.readLineSync()!) ?? 0.0;
        manager.editProduct(
          current,
          newName: newName,
          newDescription: newDesc,
          newPrice: newPrice,
        );
        break;

      case '7':
        stdout.write('Enter product name to delete: ');
        final name = stdin.readLineSync() ?? '';
        manager.deleteProduct(name);
        break;

      case '8':
        stdout.write('Enter product name to mark as completed: ');
        final name = stdin.readLineSync() ?? '';
        manager.markAsCompleted(name);
        break;

      case '0':
        print('👋 Exiting... Thank you!');
        return;

      default:
        print('❗ Invalid choice. Please select from 0 to 8.');
    }
    stdout.write('\n Press 0 to exit or any other key to continue: ');
    final exitInput = stdin.readLineSync();
    if (exitInput == '0') {
      choice = 0;
    } else {
      choice = -1;
    }
  }
  print('👋 Exiting... Thank you!');
}
