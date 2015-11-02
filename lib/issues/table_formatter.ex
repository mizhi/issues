defmodule Issues.TableFormatter do
  def print_table_for_columns(issues, columns) do
    issue_columns = as_columns(issues, columns)
    column_widths = widths_for_columns(issue_columns)
    format = column_format_str(column_widths)

    :io.format(format, columns)
    :io.format(format, separator(column_widths))
    issue_columns
    |> issue_columns_to_list
    |> Enum.each(&:io.format(format, &1))
  end

  def as_columns(issues, columns) do
    for column <- columns do
      for issue <- issues, do: printable(issue[column])
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_for_columns(issue_columns) do
    for issue_column <- issue_columns do
      issue_column |> Enum.map(&String.length(&1)) |> Enum.max
    end
  end

  def column_format_str(column_widths) do
    Enum.map_join(column_widths, " | ", fn x -> "~#{x}s" end) <> "~n"
  end

  def separator(column_widths) do
    column_widths |> Enum.map(&List.duplicate("-", &1))
  end

  def issue_columns_to_list(issue_columns) do
    issue_columns
    |> List.zip
    |> Enum.map(&Tuple.to_list(&1))
  end
end
