class GildedRose

  def initialize(items)
    @items = items
  end
  
  # MODIFY QUALITY ACCORDING TO PARAMETERS
  # item = item to modify
  # increases = control increase or decrease in value
  # value = value to increase or decrease in quality
  def modify_quality(item, increases = false, value)
    if increases
      if item.quality < 50
        newValue = item.quality + value
        item.quality = (newValue > 50 ? 50 : newValue)
      end
    else
      if item.quality > 0
        newValue = item.quality - value        
        item.quality = (newValue < 0 ? 0 : newValue)
      end
    end
  end

  def update_sell_in_value(item)
    item.sell_in = item.sell_in - 1

    if item.sell_in < 0
      if item.name.downcase == "Backstage passes to a TAFKAL80ETC concert".downcase
        modify_quality(item, false, item.quality)
      elsif item.name.downcase == "Aged Brie".downcase
        modify_quality(item, true, 1)
      else
        modify_quality(item, false, 1)
      end
    end
  end

  # DEFAULT ITEMS METHOD
  # item = item to modify
  def default_items(item)
    modify_quality(item, false, 1)
    
    update_sell_in_value(item)
  end

  # AGED BRIE OR BACKSTAGE PASSES ITEMS METHOD
  # item = item to modify
  def aged_brie_or_backstage_passes_items(item)
    modify_quality(item, true, 1)

    if item.name.downcase == "Backstage passes to a TAFKAL80ETC concert".downcase
      if item.sell_in < 11
        modify_quality(item, true, 1)
      end
  
      if item.sell_in < 6
        modify_quality(item, true, 1)
      end
    end

    update_sell_in_value(item)
  end

  # CONJURED ITEMS METHOD
  # item = item to modify
  def conjured_items_method(item)
    modify_quality(item, false, 2)
  end

  def update_quality()
    @items.each do |item|
      if item.name.downcase == "Sulfuras, Hand of Ragnaros".downcase
        next
      elsif item.name.downcase == "Aged Brie".downcase or item.name.downcase == "Backstage passes to a TAFKAL80ETC concert".downcase
        aged_brie_or_backstage_passes_items(item)
      elsif item.name.downcase == "Conjured Mana Cake".downcase
        conjured_items_method(item)
      else
        default_items(item)
      end
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end