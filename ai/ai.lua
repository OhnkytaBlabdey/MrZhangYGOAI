Version = "0.35"
Experimental = false

--[[
  AI Script for YGOPro Percy:
  http://www.ygopro.co/

  script by Snarky
  original script by Percival18
  
  GitHub repository: 
  https://github.com/Snarkie/YGOProAIScript/
  
  Check here for updates: 
  http://www.ygopro.co/Forum/tabid/95/g/posts/t/7877/AI-Updates
  
  Contributors: ytterbite, Sebrian, Skaviory, francot514
  Optional decks: Yeon, Satone, rothayz, Ildana, Iroha, Postar, Nachk, Xaddgx, neftalimich
  You can find and download optional decks here:
  http://www.ygopro.co/Forum/tabid/95/g/posts/t/7877/AI-Updates
  
  for more information about the AI script, check the ai-template.lua
  
  
  
  The MIT License (MIT)

  Copyright (c) 2015 Snarky

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

]]

GlobalCheating = false
TRASHTALK = true -- some decks might comment their actions. Set to false, if you don't like that
EXTRA_DRAW = 0
EXTRA_SUMMON = 0
LP_RECOVER = 0
--
-- drct=4
ob1=0
ob2=0
--第二级的数值即对应着循环的（最）小单元 ； 数值于onselectinitcommand时计算更新 ，并 根据此值决定这一步的command 
 --command=nil


COMMAND_OHNKYTA_GLOBAL =nil
NOTE_OHNKYTA_GLOBAL=nil
 num=nil --number 
 gid=nil
 ida=nil
 idb=nil
 idc=nil
 seq=nil
 maxim=nil --maxamount
 selct=0 --count
 yesno=nil --trigger/chain/effect
 
 --[]
 mode_log=true --add log
 --[crack pazzle]
 mode_crack=true --破解残局

 last_log_seq=nil --file_seq-1
 last_log_filepath=nil --log-(file_seq-1).lua
 last_choice_path=nil --last turn had selected
 choice_path={} --current to select
 MIN_CID=nil --minium cardid
 --
PRINT_DRAW = 1 -- for debugging

function requireoptional(module)
  if not pcall(require,module) then
    print("file missing or syntax error: "..module)
  end
end

-- require("ai.mod.AICheckList")
require("ai.mod.AIHelperFunctions")
require("ai.mod.AIHelperFunctions2")
require("ai.mod.AICheckPossibleST")
require("ai.mod.AIOnDeckSelect")
require("ai.mod.DeclareAttribute")
require("ai.mod.DeclareCard")
require("ai.mod.DeclareMonsterType")
require("ai.mod.SelectBattleCommand")
-- requireoptional("ai.mod.submod")
if not mode_crack then
requireoptional("ai.mod.combo")
end
requireoptional("ai.mod.SelectCard")
require("ai.mod.SelectChain")
require("ai.mod.SelectEffectYesNo")

requireoptional("ai.mod.SelectInitCommand")

require("ai.mod.SelectNumber")
require("ai.mod.SelectOption")
require("ai.mod.SelectPosition")
require("ai.mod.SelectSum")
require("ai.mod.SelectTribute")
require("ai.mod.SelectYesNo")
require("ai.mod.SelectChainOrder")

math.randomseed( require("os").time() )

function OnStartOfDuel()
  AI.Chat("AI script version "..Version)
  --if Experimental then AI.Chat("This is an experimental AI version, it might contain bugs and misplays") end
  print("start of duel")
  if mode_log then
   io=require("io")
   init_log()
   --[crack mode]
 if mode_crack then 
    combo=nil
	if not choice_seq then choice_seq=1 end
    --[initialization crack member]
	 last_choice_path={}
	 last_choice_path.choice={}
	 last_choice_path.type={}
	 last_choice_path.set={}
	 last_choice_path.data_type={}
	 
	 last_log_seq=file_seq-1
	 print("last_log_seq",last_log_seq)
  if last_log_seq > 0 then
	 last_log_filepath="./ailog/log-"..last_log_seq..".lua"
	 requireoptional(last_log_filepath)
	 local last_log=combo_log
	 --combo_log=nil --[与上一次和下一次的读取切断]
	if last_log and #last_log > 1 then
	 --[get last_choice_path]
	 print("get last_choice_path")
	 local last_length = #last_log
	 last_length = last_length - 1
	 for i=1,last_length do
	  last_choice_path.choice[i]=last_log[i]["selected"]
	  last_choice_path.type[i]=last_log[i]["choice_type"]
	  last_choice_path.set[i]=last_log[i]["choices"]
	  last_choice_path.data_type[i]=last_log[i]["data_type"]
	  --eg, last_choice_path[1]={5,0} , for it activated in the first turn. 
	  --[[
	   记录选项类型等要素
	  --]]
	 end
	 -- choice_seq=1
	 -- print("choice_seq is ", choice_seq)
	end
	 -- choice_seq=1
	 -- print("choice_seq is ", choice_seq)
	 --[get choice_path]
	 if not choice_seq then choice_seq=1 end
	 get_choice_path()
  else
  print("only log-1 tried.")
  	 choice_seq=1
	 print("choice_seq is ", choice_seq)
	 get_choice_path()
  end
	 --[]
	 
 end
  --[]
  end
  print("duel will start now")
  Startup()
end


