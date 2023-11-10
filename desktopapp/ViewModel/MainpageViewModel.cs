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

namespace desktopapp.ViewModel
{
    public partial class MainpageViewModel  : ObservableObject
    {
        public string username { get; set; }
        public string password { get; set; }
        public int acces { get; set; }
        public LogInCommand logInCommand { get; set; }
        public async Task<int> LogIn()
        {
            int result = await getacces();
            return result;

        }
        public async Task<int> getacces()
        {
            await Task.Delay(1000);
            return 0;

        }

        public async void LogInCommand()
        {
            await Task.Delay(100);


        }
        public MainpageViewModel()
        {
            this.logInCommand = new LogInCommand(this);

        }



    }
}
