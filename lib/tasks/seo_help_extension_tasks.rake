namespace :radiant do
  namespace :extensions do
    namespace :seo_help do
      
      desc "Runs the migration of the Seo Help extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          SeoHelpExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          SeoHelpExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Seo Help to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[SeoHelpExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(SeoHelpExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
