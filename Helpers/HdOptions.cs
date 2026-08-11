namespace QualityHD.Helpers
{
    // Server-side whitelist mirroring the dropdown options in HD.md.
    // Every incoming value is checked against these before it reaches SQL.
    public static class HdOptions
    {
        public static readonly string[] ImprovementTypes = { "Reactive", "Proactive" };

        public static readonly string[] Plants = { "NGP", "ZHB", "RDP", "JPR", "RJK", "KND" };

        public static readonly string[] Aggregates = {
            "Tractor", "Transmission", "Engine", "VTU Assembly", "CV Assembly",
            "Machine Shop", "Front Axle", "PTCD", "Paint Shop"
        };

        public static readonly string[] ModelFamilies = { "H1", "H2", "YT+", "Novo", "OJA", "JIVO", "H3", "H1R" };

        public static readonly string[] IssueSources = {
            "Domestic CVL", "CLR", "Traveler Card", "IO CVL", "IO Field Issue",
            "Proactive Improvement", "Gate Audit"
        };

        public static readonly string[] ImprovementCategories = {
            "Poka-Yoke", "Process Improvement", "Supplier Process Improvement",
            "Facility Improvement", "Part Standardisation", "Design Improvement"
        };

        public static readonly string[] OrcStatuses = { "Open", "R1", "R2", "Closed", "Initiator", "Not Applicable" };
    }
}
