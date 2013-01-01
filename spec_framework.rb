require "./fortholito.rb"

module Specification
  def spec name, args
    define_method "specmethod_#{name}" do
      forth = Fortholito.new
      result = forth.eval args[:code]
      if result == args[:expect]
        puts "  passed : #{name}"
      else
        puts "* FAILED : #{name}"
        puts "    expected #{args[:expect].inspect}"
        puts "     but got #{result.inspect}"
      end
    end
  end
end

class FortholitoSpecification
  def execute
    puts "\n*** Executing Fortholito specification ***"
    methods.
      select {|m| m =~ /^specmethod_/ }.
      each {|s| send s }
    puts
  end
end
