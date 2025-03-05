import 'package:hive_flutter_calender/hive_objects/categories.dart';
import 'package:hive_flutter_calender/main.dart';
import 'hive_objects/event.dart';

mixin Func {
  /// create a new Event
  addEvent(Event event, Categories cat) async {
    /// i have to add category to event
    event.category.add(cat);

    /// add event to events table we sue add for it
    await eventBox.add(event);

    /// we have to save the changes
    event.save();
  }

  /// Create a new Category
  addCategory(Categories category) async {
    await categoryBox.add(category);
  }

  /// fetch all events from events table by date
  List<Event> getEventsByDate(DateTime dateTime) {
    return eventBox.values.where((event) => event.date == dateTime).toList();
  }

  /// update the category or event
  updateEvent(Event event, Categories cat) async {
    event.category.clear();
    event.category.add(cat);
    await eventBox.put(event.key, event);
    event.save();
  }

  /// delete an event
  deleteEvent(Event event) async {
    await eventBox.delete(event.key);
  }

  /// to search for a event

  List<Event> searchEvent(String searchWord) {
    String lowerSearchWord = searchWord.toLowerCase();

    return eventBox.values
        .where((event) =>
            event.eventName.toLowerCase().contains(lowerSearchWord) ||
            event.eventDescription.toLowerCase().contains(lowerSearchWord) ||
            event.category[0].name.toLowerCase().contains(lowerSearchWord))
        .toList();
  }

  /// view for event based on category -> view always is fetch search always is fetch and to see always is fetch

  List<Event> getByCategory(String category) {
    return eventBox.values
        .where((event) => event.category[0].name.contains(category))
        .toList();
  }
}
