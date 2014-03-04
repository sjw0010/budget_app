class Budget < ActiveRecord::Base
	has_many :users
	validates(:name,
	   presence: true, 
	   length: {maximum: 50},
	   :if => lambda { |b| b.current_step == "general" })
	validates(:allowance, presence: true,
	 	:format => { :with => /\A\d+??(?:\.\d{0,2})?\Z/ },
	 	:numericality => {:greater_than => 0, :less_than => 1000000000},
	 	:if => lambda {|b| b.current_step == "money"})
	 validates(:target, presence: true,
	 	:format => { :with => /\A\d+??(?:\.\d{0,2})?\Z/ },
	 	:numericality => {:greater_than => 0, :less_than => 1000000000},
	 	:if => lambda {|b| b.current_step == "money"})

	attr_writer :current_step

	def current_step
		@current_step || steps.first
	end

	def steps
		%w[general money calendar confirmation]
	end

	def next_step
		self.current_step = steps[steps.index(current_step) + 1]
	end

	def previous_step
		self.current_step = steps[steps.index(current_step) - 1]
	end

	def first_step?
		current_step == steps.first
	end

	def last_step?
		current_step == steps.last
	end

	def all_valid?
		steps.all? do |step|
			self.current_step = step
			valid?
		end
	end
end
