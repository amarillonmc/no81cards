--黄泉之歌
function c67200625.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1) 
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,67200625)
	--e5:SetCondition(c67200625.tscon)
	e5:SetTarget(c67200625.tgtg)
	e5:SetOperation(c67200625.tgop)
	c:RegisterEffect(e5)  
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c67200625.handcon)
	c:RegisterEffect(e2)	  
end
--

function c67200625.costfilter(c)
	return c:IsSetCard(0x567b) and c:GetType()==TYPE_TRAP and c:IsAbleToHandAsCost() and c:IsFaceupEx()
end
function c67200625.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c67200625.costfilter,tp,LOCATION_ONFIELD,0,1,c) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(c67200625.costfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
	if chk==0 then return b1 or b2 end
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c67200625.costfilter,tp,LOCATION_ONFIELD,0,c)
	local g2=Duel.GetMatchingGroup(c67200625.costfilter,tp,LOCATION_GRAVE,0,nil)
	if b1 then
		g:Merge(g1)
	end
	if b2 then
		g:Merge(g2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_ONFIELD) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	end
	if tc:IsLocation(LOCATION_GRAVE) then
		e:SetLabel(2)
		e:SetCategory(0)
	end
	Duel.SendtoHand(tc,nil,REASON_COST)
end
function c67200625.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if not c:IsRelateToEffect(e) then return end
	local label=e:GetLabel()
	if label==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
	if label==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local gg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		if gg:GetCount()>0 then
			Duel.Remove(gg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
--
function c67200625.handcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetTurnPlayer()==tp
end