﻿using System.Collections.Generic;

namespace PostGreKeyRotation.Models
{
    public class PostgreSQLConnectResult
    {
        public string SecretMountPoint { get; set; }
        public string SecretValue { get; set; }
        public IEnumerable<SimpleUser> Users { get; set; }
    }
}
