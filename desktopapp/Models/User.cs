using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace desktopapp.Models
{
    public class User
    {
        public string username { get; set; }
        public string password { get; set; }
        public int acces { get; set; }
        public User(string username, string password)
        { 
        this.username = username;
        this.password = password;
   
        }
        public async Task<int> LogIn() { 
        int result = await getacces();
            return result;
        
        }
        public async Task<int> getacces() {
            await Task.Delay(1000);
            return 0;
        
        }



    }
}
