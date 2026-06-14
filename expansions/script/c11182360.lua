--至高主宰·炎剠
function c11182360.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--immune effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetValue(c11182360.immunefilter)
	c:RegisterEffect(e0)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11182360,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,11182360)
	e1:SetCost(c11182360.pccost)
	e1:SetTarget(c11182360.pctg)
	e1:SetOperation(c11182360.pcop)
	c:RegisterEffect(e1)
	--
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(11182360,3))
	e11:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_PZONE)
	e11:SetCountLimit(1,11182360)
	e11:SetCost(c11182360.rmcost)
	e11:SetTarget(c11182360.rmtg)
	e11:SetOperation(c11182360.rmop)
	c:RegisterEffect(e11)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11182360+1)
	e2:SetCost(c11182360.DisCardCost)
	e2:SetTarget(c11182360.thtg)
	e2:SetOperation(c11182360.thop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,11182360+1)
	e3:SetCondition(c11182360.descon)
	e3:SetTarget(c11182360.destg)
	e3:SetOperation(c11182360.desop)
	c:RegisterEffect(e3)
	local e33=e3:Clone()
	e33:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e33)
end
function c11182360.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc
	if c:IsReason(REASON_BATTLE) then tc=c:GetBattleTarget() end
	if c:IsReason(REASON_EFFECT+REASON_COST) then tc=re:GetHandler() end
	return tc and tc:IsSetCard(0x6454)
end
function c11182360.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c11182360.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c11182360.DisCardCostFilter(c,tp)
	return c:IsAbleToDeckAsCost() and c:IsHasEffect(11182305,tp)
end
function c11182360.DisCardCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c11182360.DisCardCostFilter,tp,0x30,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return g1:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	local te=tc:IsHasEffect(11182305,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT+REASON_REPLACE)
	else
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end
function c11182360.thfilter(c)
	return c:IsSetCard(0x6454) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c11182360.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182360.thfilter,tp,0x30,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x30)
end
function c11182360.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11182360.thfilter),tp,0x30,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c11182360.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g3=Duel.GetMatchingGroup(c11182360.CostFilter1,tp,0xe,0,nil,0x6)
	local g4=Duel.GetMatchingGroup(c11182360.CostFilter2,tp,0xe,0,nil,0x6)
	if chk==0 then return #g3>0 or #g4>0 end
	local op=aux.SelectFromOptions(tp,{#g3>0,aux.Stringid(11182360,0)},{#g4>0,aux.Stringid(11182360,1)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g3:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,0x80)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g4:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,0x80)
	end
end
function c11182360.rmfilter(c)
	return c:IsSetCard(0x6454) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c11182360.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182360.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c11182360.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c11182360.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c11182360.CostFilter1(c,type)
	return c:IsAbleToGraveAsCost() and c:IsType(type)
end
function c11182360.CostFilter2(c,type)
	return c:IsAbleToRemoveAsCost() and c:IsType(type)
end
function c11182360.pccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g3=Duel.GetMatchingGroup(c11182360.CostFilter1,tp,0xe,0,nil,0x1)
	local g4=Duel.GetMatchingGroup(c11182360.CostFilter2,tp,0xe,0,nil,0x1)
	if chk==0 then return #g3>0 or #g4>0 end
	local op=aux.SelectFromOptions(tp,{#g3>0,aux.Stringid(11182360,0)},{#g4>0,aux.Stringid(11182360,1)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g3:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,0x80)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g4:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,0x80)
	end
end
function c11182360.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsSetCard(0x6454)
end
function c11182360.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c11182360.pcfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11182360.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c11182360.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c11182360.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
end