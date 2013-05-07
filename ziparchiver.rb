require 'zipruby'
class ZipArchiver
    def initialize( zipFilePath )
        @zipfile = zipFilePath
    end
    def createZip( targetPath )
        begin
            Zip::Archive.open( @zipfile , Zip::CREATE) do | ar |
                rootDir = File.basename( "#{targetPath}/" )
                if FileTest::directory?( targetPath )
                    ar.add_dir( rootDir )
                    currentDir = ""
                    Dir.glob( targetPath + '/**/*' ).each do | path | #scan subdirectory
                        if FileTest::directory?( path )
                            tmpDir = "#{rootDir}#{path.gsub( /#{targetPath}/, '')}"
                            #p "add diretory( #{tmpDir} )"
                            ar.add_dir( tmpDir )
                        else
                            targetFile = "#{rootDir}#{path.gsub( /#{targetPath}/, '')}"
                            #p "add file=#{targetFile}"
                            ar.add_file( "#{targetFile}" , path )
                        end
                    end
                else
                    #p "add file=#{rootDir}"
                    ar.add_file( rootDir , targetPath )
                end
            end
        rescue
            p $!
        end
    end
    def encrypt( password )
        p "encrypt #{@zipfile}"
        begin
            Zip::Archive.encrypt( @zipfile , password)
        rescue
            p "exception happend. #{self.class.name}.#{__method__}"
            p $!
        end
    end
end
