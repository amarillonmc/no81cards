--尤格·萨隆
local cm,m,o=GetID()
function cm.initial_effect(c)
	Yogg_g=Group.CreateGroup()
	Yogg_g:KeepAlive()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(cm.rmcon)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
local A=1103515245
local B=12345
local M=32767
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
cm.blacklist={}
local _SelectMatchingCard=Duel.SelectMatchingCard
local _SelectReleaseGroup=Duel.SelectReleaseGroup
local _SelectReleaseGroupEx=Duel.SelectReleaseGroupEx
local _SelectTarget=Duel.SelectTarget
local _SelectTribute=Duel.SelectTribute
local _DiscardHand=Duel.DiscardHand
local _DRemoveOverlayCard=Duel.RemoveOverlayCard
local _CRemoveOverlayCard=Card.RemoveOverlayCard
local _FilterSelect=Group.FilterSelect
local _Select=Group.Select
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
function cm.list(code)
	for _,codes in pairs(cm.blacklist) do
		if codes==code then return true end
	end
	return false
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	if not cm.r then
		cm.r=Duel.GetFieldGroup(0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_EXTRA):GetSum(Card.GetCode)
	end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local ng1=Group.CreateGroup()
	local ng2=Group.CreateGroup()
	local ac=nil
	local _TGetID=GetID
	if Yogg_g:GetCount()>0 then
		ct1=math.min(Yogg_g:GetCount(),85)
		local tab1={}
		for i=1,ct1 do
			while not ac do
				local int=cm.roll(1,132000016)
				--continuously updated
				if int>132000000 and int<132000014 then int=int+739100000 end
				if int==132000014 then int=460524290 end
				if int==132000015 then int=978210027 end
				if int==132000016 then int=250000000 end
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
						local prec=Duel.CreateToken(tp,real)
						if ctype&TYPE_TOKEN==0 and not cm.list(real) and (ctype&TYPE_SPELL~=0 or ctype&TYPE_TRAP~=0) and prec:CheckActivateEffect(false,false,false)~=nil then
							ac=real
						end
					end
				else
					if not _G["c"..int] then
						_G["c"..int]={}
						_G["c"..int].__index=_G["c"..int]
					end
					GetID=function()
						return _G["c"..int],int
					end
					if pcall(function() require("expansions/script/c"..int) end) or pcall(function() require("script/c"..int) end) then
						_G["c"..int]=nil
						local bool,token=pcall(Duel.CreateToken,tp,int)
						if bool and not token:IsType(TYPE_TOKEN) and (token:IsType(TYPE_SPELL) or token:IsType(TYPE_SPELL)) and token:CheckActivateEffect(false,false,false)~=nil then
							ac=token:GetCode()
						end
					end
				end
			end
			table.insert(tab1,ac)
			table.insert(cm.blacklist,ac)
			ac=nil
		end
		for i=1,ct1 do
			g1:AddCard(Duel.CreateToken(tp,tab1[i]))
		end
		if #g1>0 then
			local codes={}
			for tc in aux.Next(g1) do
				local code=tc:GetCode()
				table.insert(codes,code)
			end
			table.sort(codes)
			if aux.GetValueType(codes[1])=="number" then
				local afilter={codes[1],OPCODE_ISCODE}
				if #codes>1 then
					for i=2,#codes do
						table.insert(afilter,codes[i])
						table.insert(afilter,OPCODE_ISCODE)
						table.insert(afilter,OPCODE_OR)
					end
				end
				local ac=g1:GetFirst()
				while ac do
					if ac:IsType(TYPE_FIELD) then
						Duel.MoveToField(ac,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
						Duel.RaiseEvent(ac,4179255,te,0,tp,tp,Duel.GetCurrentChain())
					else
						Duel.MoveToField(ac,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					end
					local te=ac:GetActivateEffect()
					te:UseCountLimit(tp,1,true)
					cm.ActivateCard(ac,tp,e)
					if not (ac:IsType(TYPE_CONTINUOUS) or ac:IsType(TYPE_FIELD) or ac:IsType(TYPE_EQUIP)) then
						Duel.SendtoGrave(ac,REASON_RULE)
					end
					ac=g1:GetNext()
				end
			end
		end
	end
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Yogg_g:AddCard(re:GetHandler())
end  
function cm.ActivateCard(c,tp,oe)
	local e=c:GetActivateEffect()
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		Duel.Hint(HINT_CARD,1-tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(e)
				tg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(e)
				tg=g:GetNext()
			end
		end
	end
end




