using System;
using System.Collections.Generic;
using System.Linq;
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

namespace desktopapp
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public LogInCommand LogInCommand { get; set; }
        public MainpageViewModel MainpageViewModel { get; set; }
        public MainWindow()
        {
            InitializeComponent();
            MainpageViewModel = new MainpageViewModel(this);
            this.DataContext = MainpageViewModel;
        }

        public async void changepage(User user) {
            SecondPage secondPage = new SecondPage(user);
            this.Content = secondPage;
        
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
    }
}
