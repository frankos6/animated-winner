using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace desktopapp.ViewModel.Commands
{
    public class LogInCommand : ICommand
    {
        public event EventHandler CanExecuteChanged;
        public MainpageViewModel MainpageViewModel;

        public LogInCommand(MainpageViewModel vm) { 
        this.MainpageViewModel = vm;
        
        
        }

        public bool CanExecute(object parameter)
        {
            return true;
        }

        public async void Execute(object parameter)
        {
            await MainpageViewModel.LogIn();
        }


    }
}
