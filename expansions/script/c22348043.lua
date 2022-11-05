--机 神 发 掘
local m=22348043
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348043,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348043,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,22348043)
	e2:SetTarget(c22348043.datg)
	e2:SetOperation(c22348043.daop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c22348043.dacon)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c22348043.sprcon)
	e4:SetOperation(c22348043.sprop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_SZONE,0)
	e5:SetTarget(c22348043.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c22348043.dacon)
	c:RegisterEffect(e6)


	
end
function c22348043.dacon(e)
	local c=e:GetHandler()
	return c:IsPublic()
end
function c22348043.dafilter(c)
	return c:IsSetCard(0x700) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c22348043.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c22348043.dafilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c22348043.daop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348043.dafilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_GRAVE) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	elseif tc:IsLocation(LOCATION_MZONE) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	   local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_SZONE)
	   if ct==1 then
		  Duel.BreakEffect()
		  Duel.Draw(tp,1,REASON_EFFECT)
	   end
	end
end
function c22348043.eftg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_CONTINUOUS) and c:IsSetCard(0x700)
end
function c22348043.filter(c)
	return not c:IsPublic()
end
function c22348043.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and (Duel.IsExistingMatchingCard(c22348043.filter,tp,LOCATION_HAND,0,2,c) or (Duel.IsPlayerCanDiscardDeckAsCost(tp,2) and Duel.IsPlayerAffectedByEffect(tp,22348041)))
end
function c22348043.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local fe=Duel.IsPlayerAffectedByEffect(tp,22348041)
	if Duel.IsPlayerAffectedByEffect(tp,22348041) and not Duel.IsPlayerCanDiscardDeckAsCost(tp,2) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c22348043.filter,tp,LOCATION_HAND,0,2,2,c)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(22348030,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	elseif Duel.IsPlayerAffectedByEffect(tp,22348041) and not Duel.IsExistingMatchingCard(c22348043.filter,tp,LOCATION_HAND,0,2,c) then
	Duel.Hint(HINT_CARD,0,22348041)
	fe:UseCountLimit(tp)
	Duel.DiscardDeck(tp,2,REASON_COST)
	elseif Duel.IsPlayerAffectedByEffect(tp,22348041) and Duel.SelectYesNo(tp,aux.Stringid(22348041,4)) then
		Duel.Hint(HINT_CARD,0,22348041)
		fe:UseCountLimit(tp)
		Duel.DiscardDeck(tp,2,REASON_COST)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c22348043.filter,tp,LOCATION_HAND,0,2,2,c)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(22348030,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
end

















