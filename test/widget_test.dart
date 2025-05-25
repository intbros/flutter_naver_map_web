import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_naver_map_web/flutter_naver_map_web.dart';

void main() {
  group('Flutter Naver Map Web', () {
    group('Place Model', () {
      test('should create Place with required fields', () {
        const place = Place(
          id: 'test_id',
          name: 'Test Place',
          latitude: 37.5666103,
          longitude: 126.9783882,
        );

        expect(place.id, equals('test_id'));
        expect(place.name, equals('Test Place'));
        expect(place.latitude, equals(37.5666103));
        expect(place.longitude, equals(126.9783882));
        expect(place.description, isNull);
        expect(place.category, isNull);
        expect(place.iconUrl, isNull);
      });

      test('should create Place with all fields', () {
        const place = Place(
          id: 'test_id',
          name: 'Test Place',
          latitude: 37.5666103,
          longitude: 126.9783882,
          description: 'Test Description',
          category: 'Test Category',
          iconUrl: 'https://example.com/icon.png',
        );

        expect(place.id, equals('test_id'));
        expect(place.name, equals('Test Place'));
        expect(place.latitude, equals(37.5666103));
        expect(place.longitude, equals(126.9783882));
        expect(place.description, equals('Test Description'));
        expect(place.category, equals('Test Category'));
        expect(place.iconUrl, equals('https://example.com/icon.png'));
      });

      test('should convert Place to JSON', () {
        const place = Place(
          id: 'test_id',
          name: 'Test Place',
          latitude: 37.5666103,
          longitude: 126.9783882,
          description: 'Test Description',
          category: 'Test Category',
          iconUrl: 'https://example.com/icon.png',
        );

        final json = place.toJson();
        
        expect(json['id'], equals('test_id'));
        expect(json['name'], equals('Test Place'));
        expect(json['latitude'], equals(37.5666103));
        expect(json['longitude'], equals(126.9783882));
        expect(json['description'], equals('Test Description'));
        expect(json['category'], equals('Test Category'));
        expect(json['iconUrl'], equals('https://example.com/icon.png'));
      });

      test('should create Place from JSON', () {
        final json = {
          'id': 'test_id',
          'name': 'Test Place',
          'latitude': 37.5666103,
          'longitude': 126.9783882,
          'description': 'Test Description',
          'category': 'Test Category',
          'iconUrl': 'https://example.com/icon.png',
        };

        final place = Place.fromJson(json);
        
        expect(place.id, equals('test_id'));
        expect(place.name, equals('Test Place'));
        expect(place.latitude, equals(37.5666103));
        expect(place.longitude, equals(126.9783882));
        expect(place.description, equals('Test Description'));
        expect(place.category, equals('Test Category'));
        expect(place.iconUrl, equals('https://example.com/icon.png'));
      });

      test('should handle null values in JSON', () {
        final json = {
          'id': 'test_id',
          'name': 'Test Place',
          'latitude': 37.5666103,
          'longitude': 126.9783882,
          'description': null,
          'category': null,
          'iconUrl': null,
        };

        final place = Place.fromJson(json);
        
        expect(place.id, equals('test_id'));
        expect(place.name, equals('Test Place'));
        expect(place.latitude, equals(37.5666103));
        expect(place.longitude, equals(126.9783882));
        expect(place.description, isNull);
        expect(place.category, isNull);
        expect(place.iconUrl, isNull);
      });
    });

    group('Coordinate Validation', () {
      test('should accept valid Seoul coordinates', () {
        const place = Place(
          id: 'seoul',
          name: 'Seoul',
          latitude: 37.5666103,  // Valid Seoul latitude
          longitude: 126.9783882, // Valid Seoul longitude
        );

        expect(place.latitude, inInclusiveRange(37.0, 38.0));
        expect(place.longitude, inInclusiveRange(126.0, 128.0));
      });

      test('should accept global coordinate ranges', () {
        const places = [
          Place(id: '1', name: 'North', latitude: 85.0, longitude: 0.0),
          Place(id: '2', name: 'South', latitude: -85.0, longitude: 0.0),
          Place(id: '3', name: 'East', latitude: 0.0, longitude: 179.0),
          Place(id: '4', name: 'West', latitude: 0.0, longitude: -179.0),
        ];

        for (final place in places) {
          expect(place.latitude, inInclusiveRange(-90.0, 90.0));
          expect(place.longitude, inInclusiveRange(-180.0, 180.0));
        }
      });
    });
  });
}
