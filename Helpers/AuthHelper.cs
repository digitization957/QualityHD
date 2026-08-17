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
            string role, plant;
            RequireAuth(out role, out plant);
            return role;
        }

        // Same check as RequireRole, but also returns the caller's plant
        // (from the JWT "plant" claim) so callers can scope data by plant.
        public static void RequireAuth(out string role, out string plant)
        {
            string authHeader = HttpContext.Current.Request.Headers["Authorization"];
            if (string.IsNullOrWhiteSpace(authHeader) || !authHeader.StartsWith("Bearer "))
            {
                HttpContext.Current.Response.StatusCode = 401;
                throw new UnauthorizedAccessException("Missing session token.");
            }

            string token = authHeader.Substring("Bearer ".Length).Trim();
            if (!JwtHelper.TryValidate(token, out role, out plant))
            {
                HttpContext.Current.Response.StatusCode = 401;
                throw new UnauthorizedAccessException("Session expired or invalid. Please sign in again.");
            }
        }
    }
}
