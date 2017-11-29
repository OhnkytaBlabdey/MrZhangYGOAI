-- COMMAND_LET_AI_DECIDE  = -1
-- COMMAND_SUMMON         = 0
-- COMMAND_SPECIAL_SUMMON = 1
-- COMMAND_CHANGE_POS     = 2
-- COMMAND_SET_MONSTER    = 3
-- COMMAND_SET_ST         = 4
-- COMMAND_ACTIVATE       = 5
-- COMMAND_TO_NEXT_PHASE  = 6
-- COMMAND_TO_END_PHASE   = 7
 file_seq=nil
 choice_seq=nil
 str_had_selected=nil

path_log=nil
file_log=nil 
--open in add mode to add a beginning code and logs.when decision is to end phase ,write the ending code and close it.

--[choice type]
OHNKYTA_LOG_COMBINE=1 --todo:组合式的选择
OHNKYTA_LOG_SINGLE=2 --多选一
--[data type]
OHNKYTA_LOG_NUM=2 --
OHNKYTA_LOG_TABLE=3 -- eg, INIT
--[file description]
LOG_INIT_COMMAND=1
LOG_CARD=2
LOG_EFFECT_YESNO=3
LOG_NUMBER=4


--[外来的]
function file_exists(tmpath)
  local tmfile,tmerr = io.open(tmpath, "r+")
  if tmfile then tmfile:close() end
  return tmfile ~= nil
end

function find_min_cid()
  -- body
  local aiall=AIAll()
  if #aiall > 0 then
    MIN_CID=aiall[1].cardid
    for k,v in pairs(aiall) do
	print("cardid:", v.cardid)
      if v.cardid <= MIN_CID then
        MIN_CID=v.cardid
      end
    end
  else
    MIN_CID=0
  end
end

function check_end_log(text_f)
local char_l=""
local ct_l=0
local ct_r=0
local length=text_f:len()
 for i=1,length do
 char_l=text_f:sub(i,i)
 --print("char_l : ",char_l)
  if char_l=="{" then 
   ct_l=ct_l+1
  end
  if char_l=="}" then
	ct_r=ct_r+1
  end
 end
 print("text_f",text_f)
 print("in func",ct_l,ct_r)
 print("char_l",char_l)
 return ct_l==ct_r 
end

function init_log()

if not os then os=require("os") end
-- local xx=
-- print("xx is ",xx)
if not os.execute("cd \"ailog\" >nul 2>nul") then
 os.execute("mkdir ailog")
 print("created.")
 -- print(os.execute("cd ailog"))
else
  os.execute("cd ..")
  print("dir exists.")
end
os=nil

if not io then io=require("io") end
local str_log=""

if file_exists("./ailog/log-1.lua") then
--init file_log if it has not been open
 file_seq=1
 path_log="./ailog/log-"..file_seq..".lua"
 while(file_exists(path_log))do
  file_seq=file_seq+1 
  path_log="./ailog/log-"..file_seq..".lua"
  --file_log:close()
 end
 
 if file_seq > 1 then file_seq=file_seq-1 end
else
file_seq=1
path_log="./ailog/log-1.lua"
file_log=io.open(path_log,"w+")
file_log:write("combo_log={}\n")
file_log:close()
file_seq=2
path_log="./ailog/log-2.lua"
file_log=io.open(path_log,"w+")
file_log:write("combo_log={")
file_log:close()
print("init log complete.")
return true
end 
 path_log="./ailog/log-"..file_seq..".lua"
 file_log=io.open(path_log,"r+")
 local l_str=file_log:read("*a")
 --print(l_str)
 if file_log and (l_str) then 
 --todo:筛除已经录制结束的log文件 如：读取所有字符，然后判断其中的{}是否匹配
  file_log:close()
  if check_end_log(l_str) then
  print("log- "..file_seq.." ended")
   file_seq=file_seq+1
   path_log="./ailog/log-"..file_seq..".lua"
   file_log=io.open(path_log,"a+")
   str_log="combo_log={"
   file_log:write(str_log)
   file_log:close()
  end
  print("log- "..file_seq.." opened")
  file_log=io.open(path_log,"a+")
  
 else
  if flie_log then file_log:close() end
  file_log=io.open(path_log,"a+")
  str_log="combo_log={"
  file_log:write(str_log)
  file_log:close()
  print("path :",path_log)
 end
 print("init log complete.")
end

--require(addtolog)

function end_log()
print("end log.")
--open_file
file_log=io.open(path_log,"a+")
file_log:write("\n[-1]=nil\n}\n return combo_log \n")
--close_file
file_log:close()
file_log=nil
path_log=nil
str_had_selected=nil
choice_seq=nil
end

--[get choice_path]
function get_choice_path()
 local last_length = #last_choice_path.choice
 if last_length <1 then
  choice_path={}
  print("last_length :", last_length)
  return true
 end
 --[[
 从末元查找，由<样本空间,选项类型,上次选项>判断是否在此结点有”下一个“选项
 直到匹配到一个结点：它存在“下一个”选项。
 记录此结点的序号，将 choice_path 的第xx项（其之后的为未知）记为“下一个”选项，
 其余的之前的选项复制于 last_choice_path 的前xx-1项。
 --]]
 local seq_to_change=0
 for i = last_length , 1 ,-1 do
 --[判断是否在此结点有”下一个“选项]
  if check_next_choice(i) then 
   seq_to_change=i
   break
  end
 --[]
 end
 --[copy]
 for i=1,seq_to_change do
  choice_path[i]=last_choice_path[i]
 end
 --[get_next_choice]
 choice_path[seq_to_change]=get_next_choice()
 --[]
end

--[判断是否在此结点有”下一个“选项]
function check_next_choice(n)
 --[type_single]
 if last_choice_path.type[n]==OHNKYTA_LOG_SINGLE then
  
 end
 --[type_double]
 if last_choice_path.type[n]==OHNKYTA_LOG_DOUBLE then
  
 end
 --[type_combine]
 if last_choice_path.type[n]==OHNKYTA_LOG_COMBINE then
  
 end
--[]
end

--[从last_choice_path中得到下一个选项]
function get_next_choice()
 --[type_single]
 if last_choice_path.type[n]==OHNKYTA_LOG_SINGLE then
  
 end
 --[type_double]
 if last_choice_path.type[n]==OHNKYTA_LOG_DOUBLE then
  
 end
 --[type_combine]
 if last_choice_path.type[n]==OHNKYTA_LOG_COMBINE then
  
 end
--[]
end

function add_raw_log(raw_choices, data_type, selected, choice_type)
  --[]
  local str_log=""
  --init file_log if it has not been open
  if not path_log and not file_log then
   init_log()
  end


  --open_file
  file_log=io.open(path_log,"a+")

  --add logs
  if file_log then

  --[choice_seq]
  if not choice_seq then
   choice_seq=0
  end
  choice_seq=choice_seq+1
  -- file_log:write("\n["..choice_seq.."]=")
  -- file_log:write("{")
  str_log=str_log.."\n["..choice_seq.."]=".."{"
  --[choices]
  -- file_log:write("[".."choices".."]={")
  str_log=str_log.."["..'"'.."choices"..'"'.."]={"
  if #raw_choices > 0 then
   for i=1,#raw_choices do
   --[,]
    if i>1 then
	 -- file_log:write(",")
	 str_log=str_log..","
	end
	--[DATA TYPE]
    if data_type==OHNKYTA_LOG_TABLE then
	--[table]
	 local achoice_t=raw_choices[i]
	  -- file_log:write("{")
	  str_log=str_log.."{"
	 if #achoice_t > 0 then
	   for j=1,#achoice_t do 
	    --[,]
		if j>1 then
		 -- file_log:write(",")
		 str_log=str_log..","
		end
		--[table]
		-- file_log:write(achoice_t[j])
		str_log=str_log..achoice_t[j]
		--[]
	   end
	  -- file_log:write("}")
	  str_log=str_log.."}"
	 end
	 --[num]
	elseif data_type==OHNKYTA_LOG_NUM then
	 --[num]
	 -- file_log:write(raw_choices[i])
	 str_log=str_log..raw_choices[i]
	 --[]
	end
	--[]
   end
  end
  -- file_log:write("},")
  str_log=str_log.."},"
  --[selected]
  str_log=str_log.."["..'"'.."selected"..'"'.."]={"
  
  if #selected > 0 then
   for i=1,#selected do
    if i>1 then
	 str_log=str_log..","
	end
    if data_type==OHNKYTA_LOG_TABLE then
	 local achoice_t=selected[i]
	  str_log=str_log.."{"
	 if #achoice_t > 0 then
	   for j=1,#achoice_t do 
		if j>1 then
		 str_log=str_log..","
		end
		str_log=str_log..achoice_t[j]
	   end
	 end
	 str_log=str_log.."}"
	elseif data_type==OHNKYTA_LOG_NUM then
    end
   end
  end
  
  str_log=str_log.."}"
  --[choice type]
  local choice_type_t={
  [OHNKYTA_LOG_SINGLE]="OHNKYTA_LOG_SINGLE",
  [OHNKYTA_LOG_COMBINE]="OHNKYTA_LOG_COMBINE",
  }
  -- file_log:write(",["..'"'.."choice_type"..'"'.."]="..choice_type_t[choice_type])
  str_log=str_log..",["..'"'.."choice_type"..'"'.."]="..choice_type_t[choice_type]
  --[data type]
  local data_type_t={
  [OHNKYTA_LOG_TABLE]="OHNKYTA_LOG_TABLE",
  [OHNKYTA_LOG_NUM]="OHNKYTA_LOG_NUM",
  }
  -- file_log:write(",["..'"'.."data_type"..'"'.."]="..data_type_t[data_type])
  str_log=str_log..",["..'"'.."data_type"..'"'.."]="..data_type_t[data_type]
  --[]
  --[end of a choice]
  -- file_log:write("},")
  str_log=str_log.."},"
  file_log:write(str_log)
  --close_file
  file_log:close()
  return true
  end
  --[]
end

-- [从combo中读取step存入global]
function get_combo_info()
 if combo then 
 AI.Chat("combo exists -- objecting ... ")
  print("combo exists -- objecting ... ")
  for k,v in pairs(combo) do 
  
   if v[1] == ob1 and v[2] == ob2 then 
    local proc = combo[k]
	AI.Chat(" step  matched!  ")
    print(" step  matched!  ")
	COMMAND_OHNKYTA_GLOBAL=proc[6]
	print("COMMAND_OHNKYTA_GLOBAL is ",COMMAND_OHNKYTA_GLOBAL)
	ida=proc[7]
	print("ida is ",ida)
	idb=proc[8]
	idc=proc[9]
	ids=proc[10]
	if proc[11] and proc[11] == 0 then 
	else 
	if not proc[11] then return end 
		local note=proc[11]
		--
		-- for k,v in pairs(note)
		 -- if #v == 0 then
		  -- v=nil
		 -- end
		-- end
		--
		if not NOTE_OHNKYTA_GLOBAL then 
		NOTE_OHNKYTA_GLOBAL=note
		end
		--
		
		--
		--bool
		--select yesno
		if NOTE_OHNKYTA_GLOBAL["note_bool"] then
		 yesno=NOTE_OHNKYTA_GLOBAL["note_bool"][1]
		 table.remove(NOTE_OHNKYTA_GLOBAL["note_bool"],1)
		 if #NOTE_OHNKYTA_GLOBAL["note_bool"] == 0 then 
		  NOTE_OHNKYTA_GLOBAL["note_bool"]=nil
		 end
		end
		
		--
		--num 
		--anounce number
		if NOTE_OHNKYTA_GLOBAL["note_num"] then
		 num=NOTE_OHNKYTA_GLOBAL["note_num"][1]
		 table.remove(NOTE_OHNKYTA_GLOBAL["note_num"],1)
		 if #NOTE_OHNKYTA_GLOBAL["note_num"] == 0 then 
		  NOTE_OHNKYTA_GLOBAL["note_num"]=nil
		 end
		end
		
		--
		--pos 
		--select position
		if NOTE_OHNKYTA_GLOBAL["note_pos"] then
		 num=NOTE_OHNKYTA_GLOBAL["note_pos"][1]
		 table.remove(NOTE_OHNKYTA_GLOBAL["note_pos"],1)
		 if #NOTE_OHNKYTA_GLOBAL["note_pos"] == 0 then 
		  NOTE_OHNKYTA_GLOBAL["note_pos"]=nil
		 end
		end
		-- if note[1]== 1 then --maxim
		-- maxim=note[2]
		-- elseif note[1]== 2 then --seq
		-- seq=note[2] --seq
		-- elseif note[1]== 3 then --yesno
		-- yesno=note[2] --yesno
		-- print("yesno is : ",yesno,'\n' )
		-- elseif note[1]== 4 then --position
		-- pos=note[2] --position
		-- elseif note[1]== 5 then --number
		-- num=note[2] --number
		-- end
		if #NOTE_OHNKYTA_GLOBAL == 0 then
		 NOTE_OHNKYTA_GLOBAL =nil
		end

	end
	if proc[12] and #(proc[12]) >= 1 then
	
	end 
	return
   end
   
  end
  AI.Chat("step not found")
  print("step not found")
 else
 AI.Chat("error : combo not exist")
  print("error : combo not exist")
 end
end


--从全局中分析，结合具体返值要求，得出返值 
function act(ActivatableCards,id,seq)
--发动id的第seq个效果
 for i=1,#ActivatableCards do 
  if ActivatableCards[i].id == id then 
   if not seq or seq == 0 then 
    AI.Chat("act card : " .. id .. "")
    print("act card : " .. id .. "")
    GlobalActivatedCardID = ActivatableCards[i].id
    return COMMAND_ACTIVATE,i
   else
	  if ( ActivatableCards[i].description == ActivatableCards[i].id*16 + seq ) then 
	    AI.Chat("act effect : " .. id .. "'s" .. seq .. " th effect.")
	    print("act effect : " .. id .. "'s" .. seq .. " th effect.")
	    GlobalActivatedCardID = ActivatableCards[i].id
     return COMMAND_ACTIVATE,i
    end
   end
  end
 end
end

function spsm(SpSummonableCards,id)
 for i=1,#SpSummonableCards do
 AI.Chat('SpSummonableCards[i].id ', SpSummonableCards[i].id)
 print('SpSummonableCards[i].id ',i, SpSummonableCards[i].id)
  if SpSummonableCards[i].id == id then 
   sming=true
   GlobalSSCardID=SpSummonableCards[i].id
   return COMMAND_SPECIAL_SUMMON,i
  end
 end
 return 1,1 
end 
function summon(SummonableCards,id)
 for i=1,#SummonableCards do 
  if SummonableCards[i].id == id then 
   GlobalSummonedThisTurn=GlobalSummonedThisTurn+1 
   GlobalSummonedCardID=SummonableCards[i].id
   sming=true
   print("summon id: "..id)
   return COMMAND_SUMMON,i 
  end
 end
 return 0,1 
end
function comd(l_cmd,l_cards,l_id)
 for i=1,#l_cards do 
  if l_cards[i].id == l_id then 
   return l_cmd,i 
  end
 end
end

--全局操作
--compare global with a certain state num seq 
function cpindi(a,b)
 if ob1 and ob2 then
   return ( ob1 == a and ob2 == b )
 end
end
--refresh global 
function wrindi(a,b)
 if ( ob1 and ob2 ) then 
   ob1=a
   ob2=b
 end
end
--check condition
function concheck()



end 

function get_next_step()
--不返值，只负责更新(重算)全局的指导变量 
if combo then 
AI.Chat("combo exists -- refreshing ...")
 print("combo exists -- refreshing ...")
 for k,v in pairs(combo) do 
  if v[1] == ob1 and v[2] == ob2 then 
   local proc = combo[k]
   local drc=proc[5]
   if drc and #drc >= 1 then 
    for i=1,#drc do
    local drct=drc[i]
	if drct[1] then
	print()
	wrindi(drct[2],drct[3])
	end
	end
   end
   ----
   if proc[3] and proc[4] then 
    --AI.Chat
    --print(" k is : " .. k )
    wrindi(proc[3],proc[4] )
	return
   end
  end
 end
 AI.Chat("error : no such step !")
 print("error : no such step !")
else
 AI.Chat("error : combo doesn't exist")
 print("error : combo doesn't exist")
end

end

function get_pre_step()
if not combo then return end 
 for k,v in pairs(combo) do 
  if v[3] == ob1 and v[4] == ob2 then 
   local proc = combo[k]
   if proc[1] and proc[2] then 
    wrindi(proc[1],proc[2] )
	-- if false then
	  COMMAND_OHNKYTA_GLOBAL=nil
	  gid=nil
	  ida=nil
	  idb=nil
	  idc=nil
	  seq=nil
	  maxim=nil 
	  selct=0 
	  yesno=nil
	  get_combo_info()
	  print('\n'.. "pre() HAS BEEN DONE!!!" ..'\n')
	-- end
	return
   end
  end
 end
 AI.Chat("error : no such step !")
 print("error : no such step !")

end 

