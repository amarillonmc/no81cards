--时型镜·世界线
local m=11630215
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)  
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.addcount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.resetcount)
		Duel.RegisterEffect(ge2,0)
	end 
end
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local p=tc:GetSummonPlayer()
		cm[p]=cm[p]+1
		tc=eg:GetNext()
	end
end
--
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function cm.filter(g,f,nc,...)
	if aux.GetValueType(f)=="function" then return g:Filter(f,nc,...) end
	local ng=g:Clone()
	if aux.GetValueType(nc)=="Card" then ng:RemoveCard(nc) end
	if aux.GetValueType(nc)=="Group" then ng:Sub(nc) end
	return ng
end
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
--
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.drop)
	Duel.RegisterEffect(e1,tp)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	local num=cm[1-tp]
	Debug.Message(num)
	if num<1 then return end
	if num>=2 then
		ct=math.floor(num/2)
	end
	Duel.Hint(HINT_CARD,0,m)
	--
	if not cm.r then
		cm.r=Duel.GetFieldGroup(0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_EXTRA):GetSum(Card.GetCode)
	end
	local g1=Group.CreateGroup()
	local ng1=Group.CreateGroup()
	local ac=nil
	local _TGetID=m
	if num>0 then
		local tab1={}
		for i=1,num do
			while not ac do
				local int=cm.roll(1,132000015)
				--continuously updated
				if int>132000000 and int<132000014 then int=int+739100000 end
				if int==132000014 then int=460524290 end
				if int==132000015 then int=978210027 end
				if KOISHI_CHECK then
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
				else
					if not _G["c"..int] then
						_G["c"..int]={}
						_G["c"..int].__index=_G["c"..int]
					end
					m=function()
						return _G["c"..int],int
					end
					if pcall(function() require("expansions/script/c"..int) end) or pcall(function() require("script/c"..int) end) then
						_G["c"..int]=nil
						local bool,token=pcall(Duel.CreateToken,tp,int)
						if bool and not token:IsType(TYPE_TOKEN) then
							ac=token:GetCode()
						end
					end
				end
			end
			table.insert(tab1,ac)
			ac=nil
		end
		for i=1,num do
			g1:AddCard(Duel.CreateToken(tp,tab1[i]))
		end
		if #g1>0 then
			--if KOISHI_CHECK then Duel.ConfirmCards(tp,g1) end
			local codes={}
			for tc in aux.Next(g1) do
				local code=tc:GetCode()
				table.insert(codes,code)
			end
			table.sort(codes)
			local afilter={codes[1],OPCODE_ISCODE}
			if #codes>1 then
				for i=2,#codes do
					table.insert(afilter,codes[i])
					table.insert(afilter,OPCODE_ISCODE)
					table.insert(afilter,OPCODE_OR)
				end
			end
		local xcodes={}
		for i=1,ct do
			if #xcodes>0 then 
				for i=1,#xcodes do 
				table.insert(afilter,xcodes[i])
				table.insert(afilter,OPCODE_ISCODE)
				table.insert(afilter,OPCODE_NOT)
				table.insert(afilter,OPCODE_AND)
				end 
			end 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
			local ac=Duel.AnnounceCard(tp,table.unpack(afilter)) 
			ng1=g1:Filter(Card.IsCode,nil,ac)
			g1:Sub(ng1)
			Duel.SendtoHand(ng1,tp,REASON_EFFECT) 
			local code=ng1:GetFirst():GetCode()
			table.insert(xcodes,code) 
		end 
		Duel.SendtoDeck(g1,tp,2,REASON_EFFECT)
		end
	end
	-- 
end
--
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end