%% ----------------------------------------------------------------------------
%%
%% zerolog: Log transport that just works with zero effort.
%%
%% Copyright (c) 2012 KIVRA
%%
%% Permission is hereby granted, free of charge, to any person obtaining a
%% copy of this software and associated documentation files (the "Software"),
%% to deal in the Software without restriction, including without limitation
%% the rights to use, copy, modify, merge, publish, distribute, sublicense,
%% and/or sell copies of the Software, and to permit persons to whom the
%% Software is furnished to do so, subject to the following conditions:
%%
%% The above copyright notice and this permission notice shall be included in
%% all copies or substantial portions of the Software.
%%
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
%% DEALINGS IN THE SOFTWARE.
%%
%% ----------------------------------------------------------------------------

-module(zerolog).

-export([start/0, start_link/0, stop/0]).

%% @spec start_link() -> {ok,Pid::pid()}
%% @doc Starts the app for inclusion in a supervisor tree
start_link() ->
    zerolog_sup:start_link().

%% @spec start() -> ok
%% @doc Start the zerolog server.
start() ->
    ok = start_apps([sasl, crypto, inets, webmachine,
                     luke, erlang_js, mochiweb, os_mon,
                     riak_sysmon, riak_core, riak_pipe, riak_kv]),
    ok = application:start(zerolog).

%% @spec stop() -> ok
%% @doc Stop the zerologserver.
stop() ->
    ok = application:stop(zerolog),
    ok = application:stop(riak_kv),
    ok = application:stop(riak_core),
    ok = application:stop(inets),
    ok = application:stop(crypto),
    ok = application:stop(sasl).

start_apps([]) ->
    ok;
start_apps([H|T]) ->
    ok = application:load(H),
    ok = application:start(H),
    start_apps(T).
