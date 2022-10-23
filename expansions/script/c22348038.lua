--机 神 整 列
local m=22348038
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--dangzuomoxian
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348038,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,22348038)
	e2:SetTarget(c22348038.datg)
	e2:SetOperation(c22348038.daop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c22348038.dacon)
	c:RegisterEffect(e3)
	--change effect type
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(22348038)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c22348038.dacon)
	c:RegisterEffect(e5)
end
function c22348038.dacon(e)
	local c=e:GetHandler()
	return c:IsPublic()
end

function c22348038.dafilter(c)
	return c:IsSetCard(0x700) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c22348038.dafilter2(c)
	return c:IsSetCard(0x700) and c:IsAbleToHand()
end
function c22348038.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348038.dafilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c22348038.dafilter2,tp,LOCATION_DECK,0,1,nil) end
end
function c22348038.daop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c22348038.dafilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		if tc then
		   Duel.BreakEffect()
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		   local g1=Duel.SelectMatchingCard(tp,c22348038.dafilter2,tp,LOCATION_DECK,0,1,1,nil)
		   if g1:GetCount()>0 then
			  Duel.SendtoHand(g1,nil,REASON_EFFECT)
			  Duel.ConfirmCards(1-tp,g1)
		   end
		end
	end
end






