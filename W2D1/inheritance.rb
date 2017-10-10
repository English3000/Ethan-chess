class Employee
  attr_reader :salary

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    @salary * multiplier
  end
end

class Manager < Employee
  def initialize(*args, subo)
    super(*args)
    @subo = subo
  end

  def bonus(multiplier)
    @subo.inject(0){|acc, el| acc = acc + el.salary} * multiplier
  end
end

# a = Employee.new("A", "a", 100, "Z")
# b = Employee.new("B", "b", 100, "Z")
# c = Manager.new("Z", "z", 120, "AA", [a, b])
