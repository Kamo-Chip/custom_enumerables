module Enumerable
  def my_each
    return self.to_enum unless block_given?

    if Array === self then
      i = 0
      while i < self.size
        yield self[i]
        i += 1
      end
    else
      i = 0
      self_arr = self.flatten
      while i < self_arr.size
        yield self_arr[i], self_arr[i+1]
        i += 2
      end
    end
  end

  def my_each_with_index
    return self.to_enum unless block_given?

    if Array === self then
      i = 0
      while i < self.size
        yield self[i], i
        i += 1
      end
    else
      i = 0
      self_arr = self.to_a
      while i < self_arr.size
        yield self_arr[i], i
        i += 1
      end
    end
  end

  def my_select
    return self.to_enum unless block_given?

    if Array === self then
      arr = []
      self.my_each do |element|
        if yield element
          arr << element
        end
      end
      arr
    else
      hash = {}
      self.my_each do |k, v|
        if yield k,v
          hash[k] = v
        end
      end
      hash
    end
  end

  def my_all?
    return self.to_enum unless block_given?

    if Array === self then
      arr = []
      self.my_each do |element|
        if yield element
          arr << element
        end
      end
      arr.size == self.size
    else
      hash = {}
      self.my_each do |k, v|
        if yield k,v
          hash[k] = v
        end
      end
      hash.size == self.size
    end 
  end

  def my_any?
    return self.to_enum unless block_given?

    if Array === self then
      arr = []
      self.my_each do |element|
        if yield element
          arr << element
        end
      end
      arr.size > 0
    else
      hash = {}
      self.my_each do |k, v|
        if yield k,v
          hash[k] = v
        end
      end
      hash.size > 0
    end 
  end

  def my_none?
    return self.to_enum unless block_given?
    
    if Array === self then
      arr = []
      self.my_each do |element|
        if yield element
          arr << element
        end
      end
      arr.size == 0
    else
      hash = {}
      self.my_each do |k, v|
        if yield k,v
          hash[k] = v
        end
      end
      hash.size == 0
    end 
  end

  def my_count(num = "!@#$%")
    if block_given? then
      if Array === self then
        arr = []
        self.my_each do |element|
          if yield element
            arr << element
          end
        end
        arr.size
        else
          hash = {}
          self.my_each do |k, v|
            if yield k,v
              hash[k] = v
            end
          end
          hash.size 
        end 
        elsif !num.eql?("!@#$%")
          if Array === self then
            self.my_select{|item| item == num}.size
          else
            return 0
          end
    else
      self.size
    end
  end

  def my_map(&block)
    return self.to_enum unless block_given?
    arr = []
    if Array === self then
      self.my_each do |element|
        arr << block.call(element)
      end
    else
      self.my_each do |k, v|
        arr << block.call(k, v)
      end
    end
    arr
  end

  def my_inject(*n)
    if n == []
      if Array == self then
        result = 0
        self.my_each do |element|
          result = yield(result, element) 
        end
      else
        arr = self.to_a.drop(1)
        result = self.to_a[0]
        arr.my_each_with_index do |element, idx|
          result = yield(result, arr[idx])
        end
      end
    else
      result = n[0]
      self.my_each do |element|
        result = yield(result, element) 
      end
    end
    result
  end

end

array = [1, 2, 3 , 4 , 5]
hash = {a: 1, b: 2, c: 3, d: 4}

puts "#my_each vs #each"
puts "Arrays:"

puts "#my_each:"
array.my_each{|item| puts item}
puts "#each:"
array.each{|item| puts item}

puts "Hashes:"
puts "#my_each:"
hash.my_each{|k, v| puts "#{k} => #{v}"}
puts "#each:"
hash.each{|k, v| puts "#{k} => #{v}"}

puts "#my_each_with_index vs #each_with_index"
puts "Arrays:"
puts "#my_each:"
array.my_each{|item, idx| puts "#{idx}, #{item}"}
puts "#each:"
array.each{|item, idx| puts "#{idx}, #{item}"}

puts "Hashes:"
puts "#my_each:"
hash.my_each{|item, idx| puts "#{idx}, #{item}"}
puts "#each:"
hash.each{|item, idx| puts "#{idx}, #{item}"}

puts "#my_select vs #select"
puts "Arrays:"
puts "#my_select:"
p array.my_select{|item| item > 2}
puts "#select:"
p array.select{|item| item > 2}

puts "Hashes:"
puts "#my_select:"
p hash.my_select{|k, v| k < :d}
puts "#select:"
p hash.select{|k, v| k < :d}

puts "#my_all? vs #all?"
puts "Arrays:"
puts "#my_all?"
p array.my_all?{|item| item == 1}
puts "#all?"
p array.all?{|item| item == 1}

puts "Hashes:"
puts "#my_all?"
p hash.my_all?{|k, v| v == 3}
puts "#all?"
p hash.all?{|k, v| v == 3}

puts "#my_any? vs #any?"
puts "Arrays:"
puts "#my_any?"
p array.my_any?{|item| item == 1}
puts "#any?"
p array.any?{|item| item == 1}

puts "Hashes:"
puts "#my_any?"
p hash.my_any?{|k, v| v == 3}
puts "#any?"
p hash.any?{|k, v| v == 3}

puts "#my_none? vs #none?"
puts "Arrays:"
puts "#my_none?"
p array.my_none?{|item| item == 0}
puts "#none?"
p array.none?{|item| item == 0}

puts "Hashes:"
puts "#my_none?"
p hash.my_none?{|k, v| v == 0}
puts "#none?"
p hash.none?{|k, v| v == 0}

puts "#my_count vs #count"
puts "Arrays:"
puts "#my_count:"
p array.my_count
p array.my_count(2)
p array.my_count{|item| item > 3}
puts "#count:"
p array.count
p array.count(2)
p array.count{|item| item > 3}

puts "Hashes:"
puts "#my_count:"
p hash.my_count
p hash.my_count(2)
p hash.my_count{|k, v| v == 4}

puts "#count:"
p hash.count
p hash.count(2)
p hash.count{|k, v| v == 4}

puts "#my_map vs #map"
puts "Arrays:"
puts "#my_map:"
p array.my_map{|item| item * 2}
puts "#map:"
p array.map{|item| item * 2}

puts "Hashes:"
puts "#my_map:"
p hash.my_map{|k, v| k > :a}
puts "#map:"
p hash.map{|k, v| k > :a}

puts "#my_inject vs inject"
puts "Arrays:"
puts "#my_inject:"
p array.my_inject{|sum, n| sum * n}
puts "#inject"
p array.inject{|sum,n| sum * n}

puts "Hashes:"
puts "#my_inject:"
hash.my_inject{|k, v| p "#{k}, #{v} #{k}"}
puts "#inject:"
hash.inject{|k, v| p "#{k}, #{v} #{k}"}

def multiply_els(arr)
  arr.my_inject{|result, value| result * value}
end

p multiply_els([2, 4, 5])