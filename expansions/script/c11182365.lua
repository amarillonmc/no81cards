--至高主宰·沃茨
function c11182365.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--immune effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetValue(c11182365.immunefilter)
	c:RegisterEffect(e0)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11182365,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,11182365)
	e1:SetCost(c11182365.pccost)
	e1:SetTarget(c11182365.pctg)
	e1:SetOperation(c11182365.pcop)
	c:RegisterEffect(e1)
	--
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(11182365,3))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_PZONE)
	e11:SetCountLimit(1,11182365)
	e11:SetCost(c11182365.spcost)
	e11:SetTarget(c11182365.sptg)
	e11:SetOperation(c11182365.spop)
	c:RegisterEffect(e11)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11182365+1)
	e2:SetCost(c11182365.DisCardCost)
	e2:SetTarget(c11182365.thtg)
	e2:SetOperation(c11182365.thop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,11182365+1)
	e3:SetCondition(c11182365.tdcon)
	e3:SetTarget(c11182365.tdtg)
	e3:SetOperation(c11182365.tdop)
	c:RegisterEffect(e3)
	local e33=e3:Clone()
	e33:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e33)
end
function c11182365.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc
	if c:IsReason(REASON_BATTLE) then tc=c:GetBattleTarget() end
	if c:IsReason(REASON_EFFECT+REASON_COST) then tc=re:GetHandler() end
	return tc and tc:IsSetCard(0x6454)
end
function c11182365.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0x30,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x30,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c11182365.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0x30,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0
			and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,0x30,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(11182365,6)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,0x30,1,1,nil)
			if #g2>0 then
				Duel.BreakEffect()
				Duel.HintSelection(g2)
				Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
			end
		end
	end
end
function c11182365.DisCardCostFilter(c,tp)
	return c:IsAbleToDeckAsCost() and c:IsHasEffect(11182305,tp)
end
function c11182365.DisCardCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c11182365.DisCardCostFilter,tp,0x30,0,nil,tp)
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
function c11182365.thfilter(c)
	return c:IsSetCard(0x6454) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c11182365.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182365.thfilter,tp,0x30,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x30)
end
function c11182365.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11182365.thfilter),tp,0x30,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c11182365.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g3=Duel.GetMatchingGroup(c11182365.CostFilter1,tp,0xe,0,nil,0x6)
	local g4=Duel.GetMatchingGroup(c11182365.CostFilter2,tp,0xe,0,nil,0x6)
	if chk==0 then return #g3>0 or #g4>0 end
	local op=aux.SelectFromOptions(tp,{#g3>0,aux.Stringid(11182365,0)},{#g4>0,aux.Stringid(11182365,1)})
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
function c11182365.spfilter(c,e,tp)
	return c:IsSetCard(0x6454) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c11182365.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11182365.spfilter,tp,0x30,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x30)
end
function c11182365.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11182365.spfilter),tp,0x30,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,0x40)
				and Duel.SelectYesNo(tp,aux.Stringid(11182365,4)) then
				if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 
					and Duel.GetMZoneCount(tp)>0 and c:IsRelateToChain()
					and Duel.SelectYesNo(tp,aux.Stringid(11182365,5)) then
					Duel.SpecialSummon(c,0,tp,tp,false,false,0x5)
				end
			end
		end
	end
end
function c11182365.CostFilter1(c,type)
	return c:IsAbleToGraveAsCost() and c:IsType(type)
end
function c11182365.CostFilter2(c,type)
	return c:IsAbleToRemoveAsCost() and c:IsType(type)
end
function c11182365.pccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g3=Duel.GetMatchingGroup(c11182365.CostFilter1,tp,0xe,0,nil,0x1)
	local g4=Duel.GetMatchingGroup(c11182365.CostFilter2,tp,0xe,0,nil,0x1)
	if chk==0 then return #g3>0 or #g4>0 end
	local op=aux.SelectFromOptions(tp,{#g3>0,aux.Stringid(11182365,0)},{#g4>0,aux.Stringid(11182365,1)})
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
function c11182365.pcfilter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x6454)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c11182365.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c11182365.pcfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c11182365.pcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c11182365.pcfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function c11182365.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttribute(ATTRIBUTE_EARTH)
end