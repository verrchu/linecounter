-module(file_util).
-export([count_lines/1, get_size/1, list_dir_recursive/1, aaa/0]).

-include("records.hrl").

aaa() -> #file_info{name="ddd", size="ddd", lines="ddd"}.

count_lines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    do_count_lines(Device, 0).

list_dir_recursive(DirName) ->
    DeepFileList = do_list_dir_recursive(DirName),
    lists:map(fun({ok, FileName}) -> FileName end,
              lists:flatten(DeepFileList)).

get_size(FileName) -> filelib:file_size(FileName).

do_list_dir_recursive(BaseName) ->
    {ok, FileList} = file:list_dir(BaseName),
    ExtendedFileList = lists:map(fun(FileName) ->
                                      add_basename(BaseName, FileName)
                                  end, FileList),
    lists:map(fun (FileName) ->
                  case filelib:is_dir(FileName) of
                      true -> do_list_dir_recursive(FileName);
                      false -> {ok, FileName}
                  end
              end,
              ExtendedFileList).

do_count_lines(Device, Result) ->
    case io:get_line(Device, "") of
        eof -> file:close(Device), Result;
        _Line -> do_count_lines(Device, Result + 1)
    end.

add_basename(BaseName, FileName) -> BaseName ++ "/" ++ FileName.
