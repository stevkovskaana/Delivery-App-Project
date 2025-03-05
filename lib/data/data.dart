import '../models/dish.dart';
import '../models/restaurant.dart';

final Restaurant restaurant = Restaurant(
  id: 'r1',
  name: 'Olive Grove',
  address: '3, Vasil Glavinov, Skopje',
  contact: '+123 456 7890',
  workingHours: '10:00 AM - 10:00 PM',
  imageUrl:
      'https://cdn.vox-cdn.com/uploads/chorus_image/image/62582192/IMG_2025.280.jpg',
);

final List<Dish> dishes = [
  Dish(
    id: '1',
    name: 'Pizza Margherita',
    price: 8.99,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-pIPrHJepjYMh9E2vRHVc2rlSp2wHDIvymg&s',
    ingredients: 'Tomato, Mozzarella, Basil, Olive Oil',
  ),
  Dish(
    id: '2',
    name: 'Chicken Tikka Masala',
    price: 10.49,
    imageUrl:
        'https://www.seriouseats.com/thmb/DbQHUK2yNCALBnZE-H1M2AKLkok=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/chicken-tikka-masala-for-the-grill-recipe-hero-2_1-cb493f49e30140efbffec162d5f2d1d7.JPG',
    ingredients: 'Chicken, Tomato Sauce, Cream, Spices',
  ),
  Dish(
    id: '3',
    name: 'Spaghetti Carbonara',
    price: 10.99,
    imageUrl:
        'https://leitesculinaria.com/wp-content/uploads/2024/04/spaghetti-carbonara-1200.jpg',
    ingredients: 'Spaghetti, Pancetta, Egg, Pecorino Cheese, Pepper',
  ),
  Dish(
    id: '4',
    name: 'Caesar Salad',
    price: 7.49,
    imageUrl:
        'https://www.noracooks.com/wp-content/uploads/2022/06/vegan-caesar-salad-4.jpg',
    ingredients: 'Romaine Lettuce, Croutons, Parmesan, Caesar Dressing',
  ),
  Dish(
    id: '5',
    name: 'Beef Stroganoff',
    price: 11.99,
    imageUrl:
        'https://www.allrecipes.com/thmb/Ef9j7yw7Ii6NrvST8EFrlQSuwpo=/0x512/filters:no_upscale():max_bytes(150000):strip_icc()/25202beef-stroganoff-iii-ddmfs-3x4-233-0f26fa477e9c446b970a32502468efc6.jpg',
    ingredients: 'Beef, Mushrooms, Onions, Sour Cream',
  ),
  Dish(
    id: '6',
    name: 'Sushi Platter',
    price: 14.99,
    imageUrl:
        'https://cdn.foodstorm.com/e5184b75632349358c9031c2ef988e6b/images/0ac13014da6f4fd1adee7eb7fc2f70eb_1080w.jpg',
    ingredients: 'Assorted Sushi, Wasabi, Soy Sauce, Pickled Ginger',
  ),
  Dish(
    id: '7',
    name: 'Veggie Burger',
    price: 8.49,
    imageUrl:
        'https://www.seriouseats.com/thmb/_c-xbP-tch4dpSTxKE1zY16sHo8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/20231204-SEA-VeganBurger-FredHardy-00-dbf603c78b694bfd99489b85ab44f4c4.jpg',
    ingredients: 'Veggie Patty, Lettuce, Tomato, Onion, Pickles, Bun',
  ),
  Dish(
    id: '8',
    name: 'Grilled Salmon',
    price: 12.99,
    imageUrl:
        'https://www.thespruceeats.com/thmb/HgM2h42z1HGEcSWkWk5CgAjDDpQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/how-to-grill-salmon-2216658-hero-01-a9c948f8a238400ebaafc0caf509c7fa.jpg',
    ingredients: 'Salmon, Lemon, Dill, Olive Oil',
  ),
  Dish(
    id: '9',
    name: 'Greek Salad',
    price: 7.49,
    imageUrl:
        'https://www.simplyrecipes.com/thmb/0NrKQlJ691l6L9tZXpL06uOuWis=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Simply-Recipes-Easy-Greek-Salad-LEAD-2-4601eff771fd4de38f9722e8cafc897a.jpg',
    ingredients: 'Tomatoes, Cucumbers, Feta Cheese, Olives, Olive Oil',
  ),
  Dish(
    id: '10',
    name: 'Lasagna',
    price: 12.49,
    imageUrl:
        'https://static01.nyt.com/images/2023/08/31/multimedia/RS-Lasagna-hkjl/RS-Lasagna-hkjl-threeByTwoMediumAt2X.jpg',
    ingredients: 'Pasta, Ground Beef, Tomato Sauce, Ricotta, Mozzarella',
  ),
];
