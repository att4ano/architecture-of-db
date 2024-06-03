namespace db3;

public class AnalyzeWriter
{
    private readonly string _resultFileName;
    private readonly QueryExecutor _queryExecutor;

    public AnalyzeWriter(string resultFileName, QueryExecutor queryExecutor)
    {
        _resultFileName = resultFileName;
        _queryExecutor = queryExecutor;
    }

    public void Write(string query, int attempts)
    {
        if (!Directory.Exists("analyze_result"))
        {
            Directory.CreateDirectory("analyze_result");
        }
        
        using (var writer = new StreamWriter(_resultFileName, append: true))
        {
            var bestCase = double.PositiveInfinity;
            double worstCase = 0;
            double totalCost = 0;

            for (var i = 0; i < attempts; i++)
            {
                var cost = _queryExecutor.Execute(query);
                totalCost += cost;
                bestCase = Math.Min(bestCase, cost);
                worstCase = Math.Max(worstCase, cost);
            }

            var averageCase = totalCost / attempts;

            writer.WriteLine($"query: {query}");
            
            writer.WriteLine();
            writer.WriteLine("===================================================");
            writer.WriteLine();
            
            writer.WriteLine($"best case: {bestCase}");
            writer.WriteLine($"worst case: {worstCase}");
            writer.WriteLine($"average: {averageCase}");
            
            writer.WriteLine();
            writer.WriteLine("===================================================");
            writer.WriteLine();
        }
    }
}