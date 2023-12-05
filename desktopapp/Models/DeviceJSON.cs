using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace desktopapp.Models
{
    public class DeviceJSON
    {
        [JsonProperty("device")]
        public Device device { get; set; }
    }
}
