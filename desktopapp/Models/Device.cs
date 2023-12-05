using Newtonsoft.Json;
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
        public string alertmessage { get; set; }

        [JsonProperty("payload")]
        public string payload { get; set; }
        [JsonProperty("timestamp")]
        public string timestamp { get; set; }

        public Device() {}




    }
}
