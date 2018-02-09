require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'test/unit'

class TestUntitled < Test::Unit::TestCase

  def test_normal_items
    # BEFORE EXPIRY DATE
    items = [Item.new("foo", 1, 3)]
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 2

    # AFTER EXPIRY DATE
    items = [Item.new("foo", 0, 3)]
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 1
  end

  def test_aged_brie_items
    # BEFORE EXPIRY DATE
    items = [Item.new("Aged Brie", 1, 3)]
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 4

    # AFTER EXPIRY DATE
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 6
  end

  def test_backstage_passes
    # MORE THAN TEN DAYS BEFORE CONCERT
    items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 3)]
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 4

    # LESS OR EQUALS 10 DAYS BEFORE CONCERT
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 6

    # LESS OR EQUALS 5 DAYS BEFORE CONCERT
    items[0].sell_in = 5
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 9

    # LESS OR EQUALS 5 DAYS BEFORE CONCERT
    items[0].sell_in = 0
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 0
  end

  def test_sulfuras_items
    # NOT MODIFY VALUES
    items = [Item.new("Sulfuras, Hand of Ragnaros", 11, 3)]
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 3
    assert_equal items[0].sell_in, 11

    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 3
    assert_equal items[0].sell_in, 11
  end

  def test_conjured_items
    items = [Item.new("Conjured Mana Cake", 10, 10)]
    GildedRose.new(items).update_quality
    assert_equal items[0].quality, 8

    GildedRose.new(items).update_quality
    assert_equal items[0].quality, 6
  end

  def test_quality_never_negative
    # NORMAL ITEM
    items = [Item.new("foo", 0, 1)]
    GildedRose.new(items).update_quality()
    assert items[0].quality >= 0

    # items = [Item.new("foo", 0, 1)]
    GildedRose.new(items).update_quality()
    assert items[0].quality >= 0

    # AGED BRIE
    items = [Item.new("Aged Brie", 0, 1)]
    GildedRose.new(items).update_quality()
    assert items[0].quality >= 0

    GildedRose.new(items).update_quality()
    assert items[0].quality >= 0

    # Backstage passes to a TAFKAL80ETC concert
    items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 1)]
    GildedRose.new(items).update_quality()
    assert items[0].quality >= 0
    
    GildedRose.new(items).update_quality()
    assert items[0].quality >= 0

    # Sulfuras, Hand of Ragnaros
    items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]
    GildedRose.new(items).update_quality()
    assert items[0].quality == 80

    GildedRose.new(items).update_quality()
    assert items[0].quality == 80

    # Conjured Item
    items = [Item.new("Conjured Mana Cake", 0, 1)]
    GildedRose.new(items).update_quality()
    assert items[0].quality >= 0

    GildedRose.new(items).update_quality()
    assert items[0].quality >= 0
  end

end