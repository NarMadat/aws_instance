terraform { 
  cloud { 
    
    organization = "narek_test" 

    workspaces { 
      name = "narek_workspace" 
    } 
  } 
}