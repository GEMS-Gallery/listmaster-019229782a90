import Bool "mo:base/Bool";
import List "mo:base/List";

import Array "mo:base/Array";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

actor {
  // Define the structure of a shopping list item
  type ShoppingItem = {
    id: Nat;
    text: Text;
    completed: Bool;
  };

  // Store the shopping list items
  stable var shoppingList: [ShoppingItem] = [];
  stable var nextId: Nat = 0;

  // Add a new item to the shopping list
  public func addItem(text: Text) : async Nat {
    let id = nextId;
    nextId += 1;
    let newItem: ShoppingItem = {
      id = id;
      text = text;
      completed = false;
    };
    shoppingList := Array.append(shoppingList, [newItem]);
    id
  };

  // Get all items in the shopping list
  public query func getItems() : async [ShoppingItem] {
    shoppingList
  };

  // Toggle the completion status of an item
  public func toggleItem(id: Nat) : async Bool {
    shoppingList := Array.map(shoppingList, func (item: ShoppingItem) : ShoppingItem {
      if (item.id == id) {
        return {
          id = item.id;
          text = item.text;
          completed = not item.completed;
        };
      };
      item
    });
    true
  };

  // Delete an item from the shopping list
  public func deleteItem(id: Nat) : async Bool {
    let oldLen = shoppingList.size();
    shoppingList := Array.filter(shoppingList, func (item: ShoppingItem) : Bool {
      item.id != id
    });
    shoppingList.size() != oldLen
  };
}
