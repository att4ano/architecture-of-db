using System.Globalization;
using Npgsql;

namespace db3;

public class QueryExecutor
{
    private readonly string _connectionString;

    public QueryExecutor(string connectionString)
    {
        _connectionString = connectionString;
    }

    public double Execute(string query)
    {
        double cost = -1;
        using (var connection = new NpgsqlConnection(_connectionString))
        {
            connection.Open();
            using var command = new NpgsqlCommand($"EXPLAIN ANALYZE {query}", connection);
            using var reader = command.ExecuteReader();
            while (reader.Read())
            {
                var line = reader.GetString(0);
                if (line.Contains("cost="))
                {
                    Console.WriteLine(query);
                    Console.WriteLine(line);
                    var costString = string.Concat(line.Split("cost=")[1].Split(" ")[0].Split(".")[0], ".", line.Split("cost=")[1].Split(" ")[0].Split(".")[1].AsSpan(0, 2));
                    cost = double.Parse(costString, CultureInfo.InvariantCulture);
                    Console.WriteLine(cost);
                    break;
                }
            }
            return cost;
        }
    }
}