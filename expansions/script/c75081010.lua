--罪秽歹斩 魔器利布
function c75081010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x75c),6,2,c75081010.ovfilter,aux.Stringid(75081010,0),2,c75081010.xyzop)
	c:EnableReviveLimit()   
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75081010,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,75081010)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c75081010.cost)
	e2:SetTarget(c75081010.distg)
	e2:SetOperation(c75081010.disop)
	c:RegisterEffect(e2)
end
function c75081010.ovfilter(c)
	return c:IsFaceup() and c:IsCode(75081001)
end
function c75081010.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,75081010)==0 end
	Duel.RegisterFlagEffect(tp,75081010,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
--
function c75081010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	e:SetLabel(ct)
	if chk==0 then return c:IsAbleToRemoveAsCost() and ct>0 end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==75081010 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetLabel(ct)
		e1:SetOperation(c75081010.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75081010.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c75081010.disop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-ct*300)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
--
function c75081010.thfilter(c)
	return c:IsSetCard(0x75c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c75081010.retop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local tc=e:GetLabelObject()
	if Duel.ReturnToField(e:GetLabelObject())~=0 and tc:IsLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(c75081010.thfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c75081010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

