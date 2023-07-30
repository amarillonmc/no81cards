--超古代的启示录
function c98930025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98930025)
	e1:SetCost(c98930025.cost)
	e1:SetTarget(c98930025.target)
	e1:SetOperation(c98930025.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c98930025.regcon)
	e2:SetOperation(c98930025.regop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98930025,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c98930025.setcon)
	e3:SetTarget(c98930025.settg)
	e3:SetOperation(c98930025.setop)
	c:RegisterEffect(e3)
end
function c98930025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c98930025.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xad0) and c:IsLevel(4) and c:IsAbleToHand()
end
function c98930025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c98930025.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98930025.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c98930025.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c98930025.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		local b1=Duel.IsExistingMatchingCard(c98930025.dcfilter,tp,LOCATION_HAND,0,1,nil,e)
		local b2=Duel.IsExistingMatchingCard(c98930025.dcfilter1,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
		local b3=Duel.IsExistingMatchingCard(c98930025.dcfilter2,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c98930025.ttfilter,tp,0,LOCATION_MZONE,1,nil)
		if not b1 and not b2 and not b3 then return end
		local off=1
		local ops={}
		local opval={}
		if b1 then
		   ops[off]=aux.Stringid(98930025,2)
		   opval[off]=0
		   off=off+1
		end
		if b2 then
		   ops[off]=aux.Stringid(98930025,3)
		   opval[off]=1
		   off=off+1
		end
		if b3 then
		   ops[off]=aux.Stringid(98930025,4)
		   opval[off]=2
		   off=off+1
		end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98930025.dcfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
		   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		   local lp=Duel.GetLP(tp)
		   Duel.SetLP(tp,lp-1000)
		end
	elseif sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c98930025.dcfilter1,tp,LOCATION_HAND,0,1,1,nil)
		if g1:GetCount()>0 and Duel.SendtoGrave(g1,REASON_EFFECT)~=0 and g1:GetFirst():IsLocation(LOCATION_GRAVE) then
		   Duel.Draw(tp,1,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,c98930025.dcfilter2,tp,LOCATION_HAND,0,1,1,nil)
		if g2:GetCount()>0 and Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		   local g3=Duel.SelectMatchingCard(tp,c98930025.ttfilter,tp,0,LOCATION_MZONE,1,1,nil)
		   if g3:GetCount()>0 then
			   Duel.HintSelection(g3)
			   Duel.SendtoGrave(g3,REASON_EFFECT)
			   Duel.BreakEffect()
			   Duel.Destroy(c,REASON_EFFECT)
			end
		end
	end
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c98930025.dcfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xad0)
end
function c98930025.dcfilter1(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xad0) and c:IsType(TYPE_MONSTER)
end
function c98930025.dcfilter2(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xad0) and c:IsType(TYPE_MONSTER)
end
function c98930025.ttfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c98930025.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND)
end
function c98930025.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(98930025,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c98930025.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98930025)>0
end
function c98930025.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c98930025.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end