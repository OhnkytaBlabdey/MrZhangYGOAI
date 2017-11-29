
 OHNKYTA_LOG_DOUBLE=nil --二元选项。 1：分类     2：序号

 OHNKYTA_LOG_CARD=nil --可以是多个
 
--[[ comment:
para:
choice_log:a table contains the choices.
data_type_log:the data type of the choices, eg:card,cardtable,number,etc.
selected_log:a table contains the selected choice 
desc_log:file/function
choice_type_log:single/double/combine
double_first: if double choice, this is the first one(selected_log[1] )

return:
1:succeed
nil:fail

--]]

function add_to_log(prime_choice_log, data_type_log, selected_log, desc_log, choice_type_log)
if not io then io=require("io") end
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
file_log:write("\n["..choice_seq.."]=")

--[had selected]
if not str_had_selected then
 str_had_selected={}
end
str_had_selected[choice_seq]=nil

--[finc minium cardid]
 find_min_cid()

--[choice description]
local desc_str=""
if desc_log then 
--eg:Init/Card/Yesno
local desc_t={
[LOG_INIT_COMMAND]="LOG_INIT_COMMAND",
[LOG_EFFECT_YESNO]="LOG_EFFECT_YESNO"
}
desc_str="{["..'"'.."desc"..'"'.."]="..desc_t[desc_log]..","
file_log:write(desc_str)
else
file_log:write("{")
end

str_log="["..'"'.."choices"..'"'.."]={"
file_log:write(str_log)
--[card to cardid]
local choice_log={}
print("data_type_log:"..data_type_log)
if data_type_log==OHNKYTA_LOG_CARD then 
print("choices are cards")
  if #prime_choice_log > 0 then
 for i=1,#prime_choice_log do 
  choice_log[i]=prime_choice_log[i].cardid - MIN_CID
 end
  end
  else
  choice_log=prime_choice_log
end

--[debug print]
local jtm=0
print("selected: "..#selected_log)
if #selected_log > 0 then
 for jtm=1,#selected_log do 
  print(jtm.." : "..selected_log[jtm])
 end
end

print("choices: "..#choice_log)
if #choice_log > 0 then
 for jtm=1,#choice_log do 
  if(choice_log[jtm])then print(jtm.." : "..choice_log[jtm]) end
 end
end


  if (#choice_log>0) and (type_log~=OHNKYTA_LOG_COMBINE) then
  str_log=""..choice_log[1]
   if (#choice_log>1) then
    local seq_max=#choice_log
	for i=2,seq_max do 
	 str_log=str_log..","..choice_log[i]
	end
   end
   file_log:write(str_log)
  end
  --above write single card,num choices
  
  str_log="},["..'"'.."selected"..'"'.."]={"
  local str_log_container="{"
  -- 为了更好地记录此次加上以前的选项

  -- file_log:write(str_log)
  if (#selected_log>0) and (type_log~=OHNKYTA_LOG_COMBINE) then
  str_log=str_log..selected_log[1]
  str_log_container = str_log_container ..selected_log[1]
   if (#selected_log>1) then
    local seq_max=#selected_log
	for i=2,seq_max do 
	 str_log=str_log..","..selected_log[i]
	 str_log_container = str_log_container ..","..selected_log[i]
	end
   end
   -- file_log:write(str_log)
  end
  str_log=str_log.."}"
  str_log_container = str_log_container .."}"
  file_log:write(str_log)
  str_had_selected[choice_seq]=str_log_container
  str_log_container=nil
  --above write single card,num selection
end
--[choice type]
local choice_type_t={
  -- [OHNKYTA_LOG_DOUBLE]="OHNKYTA_LOG_DOUBLE",
  [OHNKYTA_LOG_SINGLE]="OHNKYTA_LOG_SINGLE",
  [OHNKYTA_LOG_COMBINE]="OHNKYTA_LOG_COMBINE",
}
file_log:write(",["..'"'.."choice_type"..'"'.."]="..choice_type_t[choice_type_log])
--[data type]
local data_type_t={
  [OHNKYTA_LOG_TABLE]="OHNKYTA_LOG_TABLE",
  [OHNKYTA_LOG_NUM]="OHNKYTA_LOG_NUM",
}
file_log:write(",["..'"'.."data_type"..'"'.."]="..data_type_t[data_type_log])

--[had selected]
file_log:write(",["..'"'.."had_selected"..'"'.."]=".."{"..str_had_selected[choice_seq].."}")

--[end of a choice]
file_log:write("},")
--close_file
file_log:close()
return true
end