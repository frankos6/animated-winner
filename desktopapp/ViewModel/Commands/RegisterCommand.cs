using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace desktopapp.ViewModel.Commands
{
    public class RegisterCommand : ICommand
    {
        public event EventHandler CanExecuteChanged;
        public MainpageViewModel MainpageViewModel;

        public RegisterCommand(MainpageViewModel vm)
        {
            this.MainpageViewModel = vm;


        }

        public bool CanExecute(object parameter)
        {
            return true;
        }

        public async void Execute(object parameter)
        {
            MainpageViewModel.Register();
        }
    }
}
