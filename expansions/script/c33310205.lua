--空想生物 雪鬓＆羽
function c33310205.initial_effect(c)
	 --recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33310205,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33310205.cost)
	e1:SetCondition(c33310205.countcon1)
	e1:SetTarget(c33310205.target)
	e1:SetOperation(c33310205.activate)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCountLimit(1,33310206)
	e4:SetCondition(c33310205.countcon2)
	c:RegisterEffect(e4)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,33310205)
	e2:SetTarget(c33310205.tg)
	e2:SetOperation(c33310205.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCondition(c33310205.con)
	c:RegisterEffect(e3)
end
function c33310205.countcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c33310205.countcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c33310205.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c33310205.tgfilter(c)
	return c:IsSetCard(0x551) and c:IsAbleToGrave()
end
function c33310205.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310205.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c33310205.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33310205.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c33310205.costfil(c)
	return c:IsPublic() and c:IsAbleToDeckAsCost()
end
function c33310205.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.IsExistingMatchingCard(c33310205.costfil,tp,LOCATION_HAND,0,1,nil) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33310205,1))
	local g=Duel.SelectMatchingCard(tp,c33310205.costfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
end
function c33310205.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c33310205.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local num=Duel.Destroy(g,REASON_EFFECT)
		local sg=Duel.GetOperatedGroup()
		if num==0 or sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==0 and Duel.SelectYesNo(tp,aux.Stringid(33310205,0)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end