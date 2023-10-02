--增火商星
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
function zsx_RandomSpecialSummon(c,sumt,sump,tp,noc,nol,pos,zone)
	local num=0
	if aux.GetValueType(tg)=="Card" then
		if Duel.SpecialSummonStep(tg,sumt,sump,tp,noc,nol,pos,zone) then
			num=1
		end
		Duel.SpecialSummonComplete()
		return num
	end
	if aux.GetValueType(tg)=="Group" then   
		for tc in aux.Next(tg) do
			if Duel.SpecialSummonStep(tc,sumt,sump,tp,noc,nol,pos,zone) then
				num=num+1
			end
		end
		Duel.SpecialSummonComplete()
	end
	return num
end
function zsx_RandomSpecialSummonStep(c,sumt,sump,tp,noc,nol,pos,zone)
	local zonet={0x01,0x02,0x04,0x08,0x10,0x20,0x40}
	if not c:IsLocation(LOCATION_EXTRA) then zonet={0x01,0x02,0x04,0x08,0x10} end
	local zoneToRemove = {}
	if zone==nil then 
		zone=0x7f
	end
	for i,v in pairs(zonet) do
		if not Duel.CheckLocation(tp,LOCATION_MZONE,math.log(v,2)) or v|zone ==0 then
			table.insert(zoneToRemove,i)
		end
	end
	for i = #zoneToRemove,1,-1 do
		table.remove(zonet,zoneToRemove[i])
	end
	zone=zonet[zsx_roll(1,#zonet)]
	return Duel.SpecialSummonStep(c,sumt,sump,tp,noc,nol,pos,zone)
end
--by PurpleNightfall
local A=1103515245
local B=12345
local M=32767
function zsx_roll(min,max)
	if not zsx_random then
		local g=Duel.GetFieldGroup(0,0xff,0xff):RandomSelect(2,1)
		zsx_random=g:GetFirst():GetCode()+Duel.GetTurnCount()+Duel.GetFieldGroupCount(1,LOCATION_GRAVE,0)
	end
	min=tonumber(min)
	max=tonumber(max)
	zsx_random=((zsx_random*A+B)%M)/M
	if min~=nil then
		if max==nil then
			return math.floor(zsx_random*min)+1
		else
			max=max-min+1
			return math.floor(zsx_random*max+min)
		end
	end
	return zsx_random
end
function zsx_CreateCode()
	ac=nil
	while not ac do
		local int=zsx_roll(1,132000015)
		if int>132000000 and int<132000014 then int=int+739100000 end
		if int==132000014 then int=460524290 end
		if int==132000015 then int=978210027 end
		local cc,ca,ctype=Duel.ReadCard(int,CARDDATA_CODE,CARDDATA_ALIAS,CARDDATA_TYPE)
		if cc then
			local dif=cc-ca
			local real=0
			if dif>-10 and dif<10 then
				real=ca
			else
				real=cc
			end
			if ctype&TYPE_TOKEN==0 then
				ac=real
			end
		end
	end
	return ac
end