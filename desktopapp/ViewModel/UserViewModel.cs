using CommunityToolkit.Mvvm.Input;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace desktopapp.ViewModel
{
    public class UserViewModel : MainpageViewModel
    {
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
        [RelayCommand]
        public async void LogInCommand()
        {
            await Task.Delay(100);


        }




    }
}
