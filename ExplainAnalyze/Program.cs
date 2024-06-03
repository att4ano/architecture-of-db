using db3;
using DotNetEnv;

var queries = new List<string>()
{
    """
    SELECT 
        b.id AS board_id,
        b.title AS board_title,
        COUNT(p.id) AS pin_count,
        COALESCE(AVG(CASE WHEN i.action = 'like' THEN 1 ELSE 0 END), 0) AS average_likes
    FROM 
        board b
    LEFT JOIN 
        pin p ON b.id = p.board_id
    LEFT JOIN 
        interaction i ON p.id = i.pin_id AND i.action = 'like'
    GROUP BY 
        b.id, b.title
    ORDER BY 
        b.id;
    """,
    
    """
    SELECT 
        b.id AS board_id,
        b.title AS board_title,
        b.privacy_level
    FROM 
        board b
    WHERE 
        b.user_id = @user_id
    ORDER BY 
        b.id; 
    """,
    
    """
    WITH comment_counts AS (
        SELECT 
            user_id,
            DATE_TRUNC('month', times) AS month,
            COUNT(*) AS comment_count
        FROM 
            comment
        WHERE 
            times >= NOW() - INTERVAL '5 years'
        GROUP BY 
            user_id, month
    ),
    monthly_averages AS (
        SELECT 
            user_id,
            EXTRACT(YEAR FROM month) AS year,
            EXTRACT(MONTH FROM month) AS month,
            AVG(comment_count) AS avg_comments
        FROM 
            comment_counts
        GROUP BY 
            user_id, year, month
    )
    SELECT 
        user_id,
        year,
        month,
        avg_comments
    FROM 
        monthly_averages
    ORDER BY 
        user_id, year, month;
    """
};

var connectionString = Environment.GetEnvironmentVariable("CONNECTION_STRING") 
                       ?? "Host=localhost;Port=16432;Username=postgres;Password=postgres;Database=postgres;";

var queryExecutor = new QueryExecutor(connectionString);
var analyzeWriter = new AnalyzeWriter("analyze_result/" + DateTime.Now.ToString("yyyy_MM_dd") + ".txt", queryExecutor);
var numberAttempts = int.Parse(Environment.GetEnvironmentVariable("NUM_ATTEMPTS") ?? "5");

foreach (var query in queries)
{
    analyzeWriter.Write(query, numberAttempts);
}
