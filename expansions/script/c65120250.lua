--红包
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SSET_COST)
	e0:SetOperation(s.costop)
	c:RegisterEffect(e0)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.rectg)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetParam(0)
	local count=e:GetHandler():GetFlagEffectLabel(id)
	if count then Duel.SetTargetParam(count) end
	Duel.SetTargetPlayer(tp)	
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,count)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)>0 and KOISHI_CHECK then
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(id,2))
		local code=c:GetOriginalCode()
		Duel.ResetTimeLimit(tp,888)
		Duel.ResetTimeLimit(1-tp,888)
		for i=0,80 do
			c:SetCardData(CARDDATA_CODE,65120200+i)
		end
		c:SetCardData(CARDDATA_CODE,code)   
		Duel.ResetTimeLimit(tp,888)
		Duel.ResetTimeLimit(1-tp,888)
	end
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100,true) end
	local lp=Duel.GetLP(tp)
	local t={}
	local f=math.floor((lp)/100)
	local l=1
	while l<=f and l<=255 do
		t[l]=l*100
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,announce,true)
	e:SetLabel(announce)
	e:GetHandler():SetHint(CHINT_NUMBER,announce)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable(true) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		for i=0,4 do
			if Duel.CheckLocation(1-tp,LOCATION_SZONE,i) then
				Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true,2^i)
				break
			end
		end
		local fc=Duel.GetFieldCard(1-tp,LOCATION_FZONE,0)
		if fc then Duel.SendtoGrave(fc,REASON_RULE) end
		Duel.MoveSequence(c,5)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,aux.Stringid(id,1),1,e:GetLabel())
	end
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for i=0,4 do
		if Duel.CheckLocation(tp,LOCATION_SZONE,i) then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true,2^i)
			break
		end
	end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then Duel.SendtoGrave(fc,REASON_RULE) end
	Duel.MoveSequence(c,5)
end
