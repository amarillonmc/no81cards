--杏花宵
--23.09.08
local cm,m=GetID()
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetOperation(cm.op)
	Duel.RegisterEffect(e0,0)
end
if not aux.GetMustMaterialGroup then
	aux.GetMustMaterialGroup=Duel.GetMustMaterial
	--[[function aux.GetMustMaterialGroup(tp,code)
		local g=Group.CreateGroup()
		local ce={Duel.IsPlayerAffectedByEffect(tp,code)}
		for _,te in ipairs(ce) do
			local tc=te:GetHandler()
			if tc then g:AddCard(tc) end
		end
		return g
	end--]]
end
local _IsTuner=Card.IsTuner
function Card.IsTuner(c,...)
	local ext_params={...}
	if #ext_params==0 then return true end
	return _IsTuner(c,...)
end
local _IsCanBeSynchroMaterial=Card.IsCanBeSynchroMaterial
function Card.IsCanBeSynchroMaterial(c,...)
	local ext_params={...}
	if #ext_params==0 then return _IsCanBeSynchroMaterial(c,...) end
	local sc=ext_params[1]
	local tp=sc:GetControler()
	if c:IsLocation(LOCATION_MZONE) and not c:IsControler(tp) then
		local mg=Duel.GetSynchroMaterial(tp)
		return mg:IsContains(c) and _IsCanBeSynchroMaterial(c,sc,...)
	end
	return _IsCanBeSynchroMaterial(c,...)
end
function cm.nfilter(c,g)
	return g:FilterCount(cm.sfilter,nil,c)<3
end
function cm.sfilter(c,sc)
	return c:GetOriginalCode()==sc:GetOriginalCode()
end
local KOISHI_CHECK=false
if Duel.Exile then KOISHI_CHECK=true end
local A=1103515245
local B=12345
local M=1073741824
function cm.roll(min,max)
	min=tonumber(min)
	max=tonumber(max)
	cm.r=((cm.r*A+B)%M)/M
	if min~=nil then
		if max==nil then
			return math.floor(cm.r*min)+1
		else
			max=max-min+1
			return math.floor(cm.r*max+min)
		end
	end
	return cm.r
end
if Duel.GetRandomNumber then cm.roll=Duel.GetRandomNumber end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	if not KOISHI_CHECK or #g<36 then e:Reset() return end
	local c=e:GetHandler()
	local tp=c:GetControler()
	if c:IsLocation(LOCATION_DECK) then
		Duel.DisableShuffleCheck()
		Duel.Exile(c,0)
	elseif c:IsLocation(LOCATION_HAND) then
		if not cm.r then
			cm.r=Duel.GetFieldGroup(0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_EXTRA):GetSum(Card.GetCode)
		end
		local ct=cm.roll(1,#g)-1
		local tc=g:Filter(function(c) return c:GetSequence()==ct end,nil):GetFirst()
		c:SetEntityCode(tc:GetOriginalCode())
		local ini=cm.initial_effect
		cm.initial_effect=function() end
		c:ReplaceEffect(m,0)
		cm.initial_effect=ini
		if tc.initial_effect then tc.initial_effect(c) end
		Duel.DisableShuffleCheck()
		Duel.Exile(tc,0)
	end
	e:Reset()
end
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
if not require and Duel.LoadScript then
	function require(str)
		require_list=require_list or {}
		local name=str
		for word in string.gmatch(str,"%w+") do
			name=word
		end
		if not require_list[str] then
			require_list[str]=Duel.LoadScript(name..".lua")
		end
		return require_list[str]
	end
end