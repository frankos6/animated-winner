using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using CommunityToolkit.Mvvm.Input;
using desktopapp.Models;
using desktopapp.ViewModel;
using desktopapp.ViewModel.Commands;
using desktopapp.Views;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
namespace desktopapp
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public LogInCommand LogInCommand { get; set; }
        public MainpageViewModel MainpageViewModel { get; set; }
        public ObservableCollection<Device> devices { get; set; }

        public string httpadress = "http://192.168.0.227:245";
        public MainWindow()
        {
            devices = new ObservableCollection<Device>();
            InitializeComponent();
            MainpageViewModel = new MainpageViewModel(this);
            this.DataContext = MainpageViewModel;
            Device device = new Device();
            device.temp = 20;
            device.humidity = 70;
            device.alertmessage = "OK";
            devices.Add(device);
            lwdata.ItemsSource = devices;
        }


        private async void btnlogin_Click(object sender, RoutedEventArgs e)
        {
            MainpageViewModel.username = tbusername.Text;
            MainpageViewModel.password = tbpassword.Text;
            int x = await MainpageViewModel.LogIn();
            if (x == 1)
            {
                SecondPage second = new SecondPage(new User(MainpageViewModel));
                loginopt.Visibility = Visibility.Collapsed;
                loggedopt.Visibility = Visibility.Visible;


            
            }

        }
        public async Task<Device> getdata(string base64code)
        {
            await Task.Delay(1000);

            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(httpadress);
                client.DefaultRequestHeaders.Clear();
                client.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");
                client.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", "Basic " + base64code);
                User user1 = new User(MainpageViewModel);
                HttpResponseMessage responseMessage = await client.GetAsync("/device/1/data?limit=0");
                responseMessage.EnsureSuccessStatusCode();
                string responsebody = await responseMessage.Content.ReadAsStringAsync();
                string s = await addtoobservable(responsebody);

            }
            Device device = new Device() ;
            return device;
        }

        public async Task<string> addtoobservable(string data)
        {
            await Task.Delay(100);
            bool smt = false;
            string data2 = data;
            while (smt == false)
            {
                JArray a = JArray.Parse(data);
                foreach (JObject o in a.Children<JObject>())
                {
                    foreach (JProperty p in o.Properties())
                    {
                        string x = p.Name;
                        if (p.Name != "timestamp")
                        {
                            JObject o2 = JObject.Parse(p.Value.ToString());
                            double temperature = 0;
                            double hum = 0;
                            foreach (JProperty p2 in o2.Properties())
                            {
                                x = p2.Name;
                                string xx = p2.Value.ToString();
                                if (p2.Name == "temperature")
                                {
                                    temperature = (double)p2.Value;
                                }
                                else
                                {
                                    hum = (double)p2.Value;
                                }
                            }

                            Device device = new Device();
                            device.temp = temperature;
                            device.humidity = hum;
                            device.alertmessage = "Ok";
                            devices.Add(device);
                        }
                        //JArray z  = JArray.Parse(p.Value.ToString());
                        //foreach (JObject o2 in z.Children<JObject>())
                        //{
                        //    foreach (JProperty p2 in o2.Properties())
                        //    { 
                        //    string zz = p2.Name;
                        //        string zzz = p2.Value.ToString();
                        //    }

                        //}


                    }
                }


            //    int startindex = data.IndexOf("{\"t");
            //int separatorindex = data.IndexOf("},\"t");
            //    char x = data.ElementAt(separatorindex);
            //    char y = data.ElementAt(separatorindex + 1);
            //    char z = data.ElementAt(separatorindex -1);
            //    string oneobject = data2.Substring(startindex, separatorindex+1-startindex);
            //    data2 = data2.Remove(0,separatorindex);
            //    int sepindex = data.IndexOf(':');

                
               
                smt = true;  
            
            }

            string s="";
            return s;
        }



        private async void btngetbyid_Click(object sender, RoutedEventArgs e)
        {
            Device device = new Device();

            string tobase64 = MainpageViewModel.username + ":" + MainpageViewModel.password;
            string base64code = Convert.ToBase64String(Encoding.UTF8.GetBytes(tobase64));
            device = await getdata(base64code);




        }
    }
}
