using desktopapp.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace desktopapp.Models
{
    public class User:UserViewModel
    {

        public User(string username, string password)
        { 
        this.username = username;
        this.password = password;
   
        }




    }
}
