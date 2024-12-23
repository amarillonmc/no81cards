--杏花宵
--23.09.08
local m=11410000
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetOperation(cm.op)
	Duel.RegisterEffect(e0,0)
end
--[[function aux.GetMustMaterialGroup(tp,code)
	local g=Group.CreateGroup()
	local ce={Duel.IsPlayerAffectedByEffect(tp,code)}
	for _,te in ipairs(ce) do
		local tc=te:GetHandler()
		if tc then g:AddCard(tc) end
	end
	return g
end--]]
local KOISHI_CHECK=false
if Duel.Exile then KOISHI_CHECK=true end
local A=1103515245
local B=12345
local M=32767
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
--if Duel.GetRandomNumber then cm.roll=Duel.GetRandomNumber end
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			pcall(require_list[str])
			return require_list[str]
		end
		return require_list[str]
	end
	local _dofile=dofile
	local _loadfile=loadfile
	function dofile(str)
		if string.find(str,"%.") then
			return _dofile(str)
		else
			return _dofile(str..".lua")
		end
	end
	function loadfile(str)
		if string.find(str,"%.") then
			return _loadfile(str)
		else
			return _loadfile(str..".lua")
		end
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
if not Duel.LoadScript and loadfile then
	function Duel.LoadScript(str)
		require_list=require_list or {}
		str="expansions/script/"..str
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			pcall(require_list[str])
		end
		return require_list[str]
	end
end
function cm.nnfilter(c,ec)
	if c:GetOriginalType()==0x11 or c:GetOriginalType()==0x1011 then return false end
	if not c.initial_effect then return true end
	return false
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	--if apricot_nightfall_adjust then return end
	apricot_nightfall_adjust=true
	e:Reset()
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	if c:IsLocation(LOCATION_DECK) and #g>=36 then
		Duel.DisableShuffleCheck()
		if KOISHI_CHECK then
			Duel.Exile(c,0)
		else
			Duel.Remove(c,POS_FACEDOWN,REASON_RULE)
		end
	elseif c:IsLocation(LOCATION_HAND) and #g>=36 then
		if not cm.r then
			cm.r=Duel.GetFieldGroup(0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_EXTRA):GetSum(Card.GetCode)
		end
		local ct=cm.roll(1,#g)-1
		local tc=g:Filter(function(c) return c:GetSequence()==ct end,nil):GetFirst()
		if KOISHI_CHECK then
			c:SetEntityCode(tc:GetOriginalCode())
			local ini=cm.initial_effect
			cm.initial_effect=function() end
			c:ReplaceEffect(m,0)
			c:SetStatus(STATUS_EFFECT_REPLACED,false)
			cm.initial_effect=ini
			if tc.initial_effect then tc.initial_effect(c) end
			Duel.DisableShuffleCheck()
			Duel.Exile(tc,0)
		else
			Duel.Remove(c,POS_FACEDOWN,REASON_RULE)
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_RULE)
		end
	end
	if KOISHI_CHECK then
		--Duel.ResetTimeLimit(0,999)
		--Duel.ResetTimeLimit(1,999)
		local e0=Effect.CreateEffect(c) 
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e0:SetCountLimit(1)
		e0:SetOperation(function() Duel.ResetTimeLimit(0,999) Duel.ResetTimeLimit(1,999) end)
		--Duel.RegisterEffect(e0,0)
	end
	local ag=Duel.GetMatchingGroup(cm.nnfilter,0,0xff,0xff,nil)
	local _TGetID=GetID
	local stack={}
	for ac in aux.Next(ag) do
		local int=ac:GetOriginalCode()
		local ini=ac.initial_effect
		if ini then
			--ac.initial_effect(ac)
			stack[#stack+1]=ac
		else
			if not _G["c"..int] then
				_G["c"..int]={}
				_G["c"..int].__index=_G["c"..int]
			end
			GetID=function()
				return _G["c"..int],int,int<100000000 and 1 or 100
			end
			require("expansions/script/c"..int)
			local ini=ac.initial_effect
			if ini then stack[#stack+1]=ac end
		end
	end
	GetID=_TGetID
	if #stack>0 then
		for i=#stack,1,-1 do
			local ac=stack[i]
			local ini=ac.initial_effect
			if ini then ac.initial_effect(ac) end
		end
	end
end
if not apricot_nightfall_preload then
	apricot_nightfall_preload=true
	pcall(dofile,"expansions/script/special.lua")
	if Auxiliary.PreloadUds and not PreloadUds_Done then Auxiliary.PreloadUds() end
	--Debug.Message("Protocol Request Complete. 杏花宵®漏洞解决方案已上线。")
end