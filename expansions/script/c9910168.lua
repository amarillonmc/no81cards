--战车道装甲·巡洋十字军
Duel.LoadScript("c9910100.lua")
function c9910168.initial_effect(c)
	--xyz summon
	QutryZcd.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),3,2,c9910168.xyzfilter,99)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910168,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910168)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9910168.thcost)
	e1:SetTarget(c9910168.thtg)
	e1:SetOperation(c9910168.thop)
	c:RegisterEffect(e1)
end
function c9910168.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9958) and c:IsFaceup()))
		and c:IsRace(RACE_MACHINE)
end
function c9910168.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910168.thfilter(c,tp,e)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c9910168.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910168.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
function c9910168.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910168.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND)
		and c:IsRelateToChain() and c:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(9910168,2)) then
		Duel.BreakEffect()
		local fid=c:GetFieldID()
		if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)==0 or c:IsReason(REASON_REDIRECT) then return end
		c:RegisterFlagEffect(9910168,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(fid,Duel.GetTurnCount())
		e1:SetLabelObject(c)
		e1:SetCondition(c9910168.retcon)
		e1:SetOperation(c9910168.retop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910168.retcon(e,tp,eg,ep,ev,re,r,rp)
	local laba,labb=e:GetLabel()
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(9910168)==laba then
		return Duel.GetTurnCount()>labb
	else
		e:Reset()
		return false
	end
end
function c9910168.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
	e:Reset()
end
