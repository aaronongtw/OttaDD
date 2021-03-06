class GeneratorController < ApplicationController
  def create
    generate_scaffold
  end

  def index
  end

  def tutorial
    @database = Database.find(params[:id])
  end

  def qr
    @database = Database.find(params[:id])
    
    if params[:allow] == "on"
      @auth = @current_user.email.hash - 1
    else
      @auth = @current_user.email.hash
    end

    @datapath = "http://ottadd.herokuapp.com/databases/#{@database.id}/#{@auth}"
    @qr = RQRCode::QRCode.new( @datapath, :size => 7, :level => :h )
  end

  private
  def database_params
  params.require(:relationship).permit(:name, :database_id)
  end

  def generate_scaffold
    @text = ""
    if params[:test] == "on"
    @text += "File.open('Gemfile','a') do |l|
      l.puts(\"
gem 'remove_turbolinks'
gem 'devise'

group :development do
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'annotate'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end


group :development, :test do
  gem 'simplecov', :require => false
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'faker'
  gem 'factory_girl_rails'
end\")\nend\n"

    @text += "system('bundle')\n"
    @text += "system('rails g rspec:install')\n"
    @text += "
  specfile = File.read('spec/spec_helper.rb')
  File.open('spec/spec_helper.rb', 'w') do |l|
  l.puts(\"require 'simplecov'\")
  l.puts(\"SimpleCov.start\")
  l.puts(specfile)
  end\n"

    @text += "system('rails generate remove_turbolinks:remove')\n"
  else
  end
    @database = Database.find(params[:id])
    @filename = params[:fname]
    
    @database.tables.each do |table|

      @text += "system('rails g scaffold #{table.name} "
      table.fields.each do |field| 
      @text += "" + "#{field.name}" + ':' + "#{field.fieldtype} " 
      end
      @text += "')\n"
end
@database.tables.each do |table|
      if table.table_relations[0].present?     
      @text += "
          File.open('app/models/#{table.name}.rb', 'w') do |file|
            file.puts('class #{table.name.capitalize} <ActiveRecord::Base')\n"
        table.table_relations.each do |r|
          table.name = table.name.downcase
          r.table_to = r.table_to.downcase
          if r.through.present?
            r.through = r.through.downcase
          end
          if r.relationship.include? "through"
            @text += "file.puts('   #{r.relationship.split(' ')[0]}"
            if r.relationship.include? "many"
              @text += " :#{r.table_to.pluralize},"
            else
              @text += " :#{r.table_to},"
            end
            @text += " :through => :#{r.through.pluralize}')\n"
            else
          @text += "file.puts('   #{r.relationship}"
            if r.relationship.include? "many"
              @text += " :#{r.table_to.pluralize}')\n"
            else
              @text += " :#{r.table}')\n"
            end
          end

        end
        @text += "file.puts('end')\n"
        @text += "end\n"

        

    end
  end
@database.tables.each do |table|  
  table.table_relations.each do|r|
          if r.relationship.include? 'has_and_belongs_to_many'
            @relationshiptable = [table.name.pluralize, r.table_to.pluralize].sort.join('_')
            @text += "system('rails generate migration create_#{@relationshiptable} #{table.name}_id:integer #{r.table_to}_id:integer') \n"
          end
          if r.relationship.include? 'through'
          else
      @text += "
          file = File.read('app/models/#{r.table_to}.rb')
          filtered = file.gsub(/end/, '')
          File.open('app/models/#{r.table_to}.rb', 'w') do |f|
            f.write(filtered)
          end
          File.open('app/models/#{r.table_to}.rb', 'a') do |l|"
        case r.relationship
          when "has_one"
            @text += "l.puts('   has_one :#{table.name}')"
          when "has_many"
            @text += "l.puts('   belongs_to :#{table.name}')"
          when "belongs_to"
            @text += "l.puts('   has_many :#{table.name.pluralize}')"
          when "has_and_belongs_to_many"
            @text += "l.puts('   has_and_belongs_to_many :#{table.name.pluralize}')"
          end
          
        @text += "\nl.puts('end')\n"
        @text += "end\n"    
    end
  end
end


@text += "system('rake db:create')\n"

if params[:test] == "on"
@text += "system('rails generate devise:install')\n"
@text += "system('rails generate devise User')\n"
@text += "system('rails generate devise:views')\n"
@text += "system('rake db:migrate')\n"
@text += "system('rspec')\n"
else
  @text += "system('rake db:migrate')\n"
  @text += "system('rake stats')\n"
  end
    send_data @text, :filename => "#{@filename}"+'.rb'
end




end


#   File.open(@filename +".rb", 'wb') do |f| 
#     @database.tables.each do |table|
#   f.write("system('rails g scaffold #{table.name} ") 
#     table.fields.each do |field| 
#       f.write("" + "#{field.name}" + ':' + "#{field.fieldtype} " )
#   end 
#   f.write("')")
#   f.write('
#     ')
#   end
# end

  


