using desktopapp.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Animation;

namespace desktopapp.ViewModel
{
    public class SecondPageViewModel
    {
        User User { get; set; }
        ObservableCollection <Device> devices { get; set; }
        public SecondPageViewModel(User user) {
            this.User = user;


        }
        public async void getdatafromapi(){
        
        await Task.Delay(1000);
        
        
        }
        public async Task<Device> longpoolingdevicestates() { 
        await Task.Delay(1000);
            return new Device();
        
        }
    }
}
