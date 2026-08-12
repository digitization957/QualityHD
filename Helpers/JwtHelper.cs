using System;
using System.Collections.Generic;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using Newtonsoft.Json;

namespace QualityHD.Helpers
{
    // Minimal HS256 JWT issue/verify so the app can emulate the token+role
    // handed off by the real app-launcher, without pulling in a full auth stack.
    public static class JwtHelper
    {
        private static string Secret
        {
            get { return ConfigurationManager.AppSettings["JwtSecret"]; }
        }

        private static string Issuer
        {
            get { return ConfigurationManager.AppSettings["JwtIssuer"]; }
        }

        private static int ExpiryMinutes
        {
            get
            {
                int minutes;
                return int.TryParse(ConfigurationManager.AppSettings["JwtExpiryMinutes"], out minutes) ? minutes : 60;
            }
        }

        public static string Issue(string subjectToken, string role, string plant)
        {
            var header = new Dictionary<string, object> { { "alg", "HS256" }, { "typ", "JWT" } };
            long now = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
            var payload = new Dictionary<string, object>
            {
                { "sub", subjectToken },
                { "role", role },
                { "plant", plant },
                { "iss", Issuer },
                { "iat", now },
                { "exp", now + (ExpiryMinutes * 60) }
            };

            string headerSegment = Base64UrlEncode(JsonConvert.SerializeObject(header));
            string payloadSegment = Base64UrlEncode(JsonConvert.SerializeObject(payload));
            string unsigned = headerSegment + "." + payloadSegment;
            string signature = Sign(unsigned);

            return unsigned + "." + signature;
        }

        public static bool TryValidate(string token, out string role, out string plant)
        {
            role = null;
            plant = null;
            if (string.IsNullOrWhiteSpace(token)) return false;

            string[] parts = token.Split('.');
            if (parts.Length != 3) return false;

            string unsigned = parts[0] + "." + parts[1];
            string expectedSignature = Sign(unsigned);

            if (!FixedTimeEquals(expectedSignature, parts[2])) return false;

            Dictionary<string, object> payload;
            try
            {
                payload = JsonConvert.DeserializeObject<Dictionary<string, object>>(Base64UrlDecode(parts[1]));
            }
            catch
            {
                return false;
            }

            if (payload == null) return false;

            long exp = Convert.ToInt64(payload.ContainsKey("exp") ? payload["exp"] : 0);
            if (DateTimeOffset.UtcNow.ToUnixTimeSeconds() > exp) return false;

            if (!payload.ContainsKey("role")) return false;
            role = Convert.ToString(payload["role"]);
            plant = payload.ContainsKey("plant") ? Convert.ToString(payload["plant"]) : null;
            return true;
        }

        private static string Sign(string data)
        {
            using (var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(Secret)))
            {
                byte[] hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(data));
                return Base64UrlEncodeBytes(hash);
            }
        }

        private static bool FixedTimeEquals(string a, string b)
        {
            if (a.Length != b.Length) return false;
            int diff = 0;
            for (int i = 0; i < a.Length; i++)
            {
                diff |= a[i] ^ b[i];
            }
            return diff == 0;
        }

        private static string Base64UrlEncode(string plain)
        {
            return Base64UrlEncodeBytes(Encoding.UTF8.GetBytes(plain));
        }

        private static string Base64UrlEncodeBytes(byte[] bytes)
        {
            return Convert.ToBase64String(bytes).Replace('+', '-').Replace('/', '_').TrimEnd('=');
        }

        private static string Base64UrlDecode(string encoded)
        {
            string padded = encoded.Replace('-', '+').Replace('_', '/');
            switch (padded.Length % 4)
            {
                case 2: padded += "=="; break;
                case 3: padded += "="; break;
            }
            return Encoding.UTF8.GetString(Convert.FromBase64String(padded));
        }
    }
}
