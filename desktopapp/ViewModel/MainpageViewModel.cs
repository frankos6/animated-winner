using CommunityToolkit.Mvvm.Input;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm;
using CommunityToolkit.Mvvm.Input;
using desktopapp.ViewModel.Commands;
using System.Net.Http;
using System.Net;
using System.IO;
using desktopapp.Views;
using desktopapp.Models;
using System.Collections.ObjectModel;

namespace desktopapp.ViewModel
{
    public partial class MainpageViewModel
    {
        public string username { get; set; }
        public string password { get; set; }
        public string regusername { get; set; }
        public string regpassword { get; set; }
        public int acces { get; set; }
        public LogInCommand logInCommand { get; set; }
        public RegisterCommand registerCommand { get; set; }
        public string httpadress = "http://192.168.0.227:245";
        public ObservableCollection<Device> devices { get; set; }

        /*LogIn- 
         * hashing the values and awaiting getacces
         * which is getting api call 
         */
        public async Task<int> LogIn()
        {

            string tobase64 = username+ ":" + password;
            string base64code = Convert.ToBase64String(Encoding.UTF8.GetBytes(tobase64));

            int result = await getacces(base64code);
            return result;
            


        }
        public async void Register() {

            HttpWebRequest httpWebRequest = (HttpWebRequest)WebRequest.Create(httpadress+"/user/register");
            httpWebRequest.Method = "POST";
            httpWebRequest.ContentType = "application/json";

            using (StreamWriter streamwriter = new StreamWriter(httpWebRequest.GetRequestStream()))
            {
                string json = "{\"username\":\"" + regusername + "\",\"password\":\"" + regpassword + "\"}";
            streamwriter.Write(json);
            }
            var response = await httpWebRequest.GetResponseAsync();
            using (StreamReader streamReader = new StreamReader(response.GetResponseStream()))
            { 
            var result = streamReader.ReadToEnd();
            }



        
        }
        public async Task<int> getacces(string base64code)
        {
            int result = 0;
            using (var client = new HttpClient())
            {
                client.BaseAddress= new Uri(httpadress);
                client.DefaultRequestHeaders.Clear();
                client.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");
                client.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", "Basic " + base64code);
                User user1 = new User(this);
                HttpResponseMessage responseMessage = await client.GetAsync("/auth");
                if (responseMessage.IsSuccessStatusCode)
                {
                    result = 1;
                }

            }
            return result;

        }

        public async Task<Device> getdata(string base64code)
        {
            await Task.Delay(1000);
            HttpWebRequest httpWebRequest = (HttpWebRequest)WebRequest.Create(httpadress + "/device/1");
            httpWebRequest.Method = "GET";
            httpWebRequest.ContentType = "application/json";

            using (StreamWriter streamwriter = new StreamWriter(httpWebRequest.GetRequestStream()))
            {
                string json = "{\"username\":\"" + regusername + "\",\"password\":\"" + regpassword + "\"}";
                streamwriter.Write(json);
            }
            var response = await httpWebRequest.GetResponseAsync();
            using (StreamReader streamReader = new StreamReader(response.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();

                return new Device();
            }
        }


        public MainpageViewModel(MainWindow main)
        {
            this.logInCommand = new LogInCommand(this);
            this.registerCommand = new RegisterCommand(this);
            
            


        }
        public MainpageViewModel()
        {
            this.logInCommand = new LogInCommand(this);
            this.registerCommand = new RegisterCommand(this);

        }

        }
}
