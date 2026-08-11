using System;
using System.Web;

namespace QualityHD.Helpers
{
    public static class AuthHelper
    {
        // Every WebMethod that touches data must call this first; it throws
        // if the bearer JWT (set at Login) is missing, tampered, or expired.
        public static string RequireRole()
        {
            string authHeader = HttpContext.Current.Request.Headers["Authorization"];
            if (string.IsNullOrWhiteSpace(authHeader) || !authHeader.StartsWith("Bearer "))
                throw new UnauthorizedAccessException("Missing session token.");

            string token = authHeader.Substring("Bearer ".Length).Trim();
            string role;
            if (!JwtHelper.TryValidate(token, out role))
                throw new UnauthorizedAccessException("Session expired or invalid. Please sign in again.");

            return role;
        }
    }
}
