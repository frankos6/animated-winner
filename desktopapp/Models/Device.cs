using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace desktopapp.Models
{
    public class Device
    {
        public string devicelog { get; set; }
        public double temp { get; set; }
        public double humidity { get; set; }

        public Device(string devicelog) {
        this.devicelog = devicelog;

        
        
        }
        public async void getdevice() { 
        await Task.Delay(1000);
           
        }




    }
}
