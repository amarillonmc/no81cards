--祸事罪秽 神阶利布
function c75081017.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x75c),6,2,c75081017.ovfilter,aux.Stringid(75081017,0),2,c75081017.xyzop)
	c:EnableReviveLimit()   
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75081017,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,75081017)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c75081017.cost)
	e2:SetTarget(c75081017.distg)
	e2:SetOperation(c75081017.disop)
	c:RegisterEffect(e2)
end
function c75081017.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x75c) and c:IsRank(6)
end
function c75081017.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,75081017)==0 end
	Duel.RegisterFlagEffect(tp,75081017,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
--
function c75081017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	e:SetLabel(ct)
	if chk==0 then return c:IsAbleToRemoveAsCost() and ct>0 end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==75081017 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetLabel(ct)
		e1:SetOperation(c75081017.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75081017.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c75081017.disop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
--
function c75081017.thfilter(c)
	return c:IsSetCard(0x75c) and c:IsAbleToDeck()
end
function c75081017.retop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	--Debug.Message(ct)
	if Duel.ReturnToField(e:GetLabelObject())~=0 and Duel.IsExistingMatchingCard(c75081017.thfilter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75081017.thfilter),tp,LOCATION_GRAVE,0,1,ct,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end

