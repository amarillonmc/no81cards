--帝尊格位
function c11182345.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,2547034)
	e1:SetCondition(c11182345.discon)
	e1:SetCost(c11182345.DisCardCost2)
	e1:SetTarget(c11182345.distg)
	e1:SetOperation(c11182345.disop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,11182345+1)
	e2:SetCondition(c11182345.ctrcon)
	e2:SetTarget(c11182345.ctrtg)
	e2:SetOperation(c11182345.ctrop)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e22)
end
function c11182345.ctrcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc
	if c:IsReason(REASON_BATTLE) then tc=c:GetBattleTarget() end
	if c:IsReason(REASON_EFFECT+REASON_COST) then tc=re:GetHandler() end
	return tc and tc:IsSetCard(0x6454)
end
function c11182345.ctrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsControlerCanBeChanged,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c11182345.ctrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.GetControl(g:GetFirst(),tp,PHASE_END+RESET_SELF_TURN,1)
	end
end
function c11182345.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c11182345.DisCardCostFilter(c,tp)
	return c:IsAbleToDeckAsCost() and c:IsHasEffect(11182305,tp)
end
function c11182345.CostFilter1(c)
	return c:IsAbleToGraveAsCost()
end
function c11182345.CostFilter2(c)
	return c:IsAbleToRemoveAsCost()
end
function c11182345.DisCardCost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c11182345.DisCardCostFilter,tp,0x30,0,nil,tp)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(c11182345.CostFilter1,tp,0xc,0,nil)
	local g4=Duel.GetMatchingGroup(c11182345.CostFilter2,tp,0xc,0,nil)
	if chk==0 then return g1:GetCount()>0 or #g3>0 or #g4>0 end
	local op=aux.SelectFromOptions(tp,{#g1>0,aux.Stringid(11182345,0)},{#g3>0,aux.Stringid(11182345,1)},{#g4>0,aux.Stringid(11182345,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		local te=c:IsHasEffect(11182305,tp)
		if te then
			te:UseCountLimit(tp)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT+REASON_REPLACE)
		else
			Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g3:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,0x80)
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g4:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,0x80)
	end
end
function c11182345.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11182345.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end