using CommunityToolkit.Mvvm.Input;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using desktopapp.ViewModel.Commands;
using System.Net.Http;

namespace desktopapp.ViewModel
{
    public partial class MainpageViewModel  : ObservableObject
    {
        public string username { get; set; }
        public string password { get; set; }
        public int acces { get; set; }
        public LogInCommand logInCommand { get; set; }

        /*LogIn- 
         * hashing the values and awaiting getacces
         * which is getting api call 
         */
        public async Task<int> LogIn()
        {

            string tobase64 = username+ ":" + password;
            string base64code = Convert.ToBase64String(Encoding.UTF8.GetBytes(tobase64));

            int result = await getacces();
            return result;
            


        }
        public async Task<int> getacces()
        {

            using (var client = new HttpClient())
            {
                client.BaseAddress= new Uri("http://192.168.137.80");
                client.DefaultRequestHeaders.Clear();
                client.DefaultRequestHeaders.Add("Content-Type", "application/json");
                client.DefaultRequestHeaders.Add("Authorization", "Basic \" + base64code");

                HttpResponseMessage responseMessage = await client.GetAsync("/auth");
                if (responseMessage.IsSuccessStatusCode)
                { 
                
                
                
                }



            
            }


            await Task.Delay(1000);
            return 0;

        }
        public MainpageViewModel()
        {
            this.logInCommand = new LogInCommand(this);

        }



    }
}
