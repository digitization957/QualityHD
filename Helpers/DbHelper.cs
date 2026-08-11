using System.Configuration;
using MySqlConnector;

namespace QualityHD.Helpers
{
    public static class DbHelper
    {
        public static MySqlConnection GetConnection()
        {
            string connStr = ConfigurationManager.ConnectionStrings["QualityHDConnection"].ConnectionString;
            return new MySqlConnection(connStr);
        }
    }
}
