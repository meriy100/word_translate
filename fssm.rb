require 'fssm'
 
def create_action(base,file)
  open('log.txt', 'a'){|f|
    f.puts base + "/"  + file + " was created at " + `date`
  }
  system "git add " + base + "/" + file
  system "git commit -m\"add #{file}\""
end
 
def update_action(base,file)
  open('log.txt', 'a'){|f|
     f.puts base + "/"  + file + " was updated at " + `date`
  }
  puts file
  system "git commit -m \"#{file}\""
end
 
def delete_action(base,file)
  open('log.txt', 'a'){|f|
    f.puts base + "/" + file + " was deleted at " + `date`
  }
end




FSSM.monitor('.','**/*') do 
  create do |base,file|
    create_action(base, file)
  end
  update do |base,file|
    update_action(base, file)
  end
  delete do |base,file|
    delete_action(base, file)
  end
end
















































