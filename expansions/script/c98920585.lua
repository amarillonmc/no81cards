--星守士 河鼓二·星圣
function c98920585.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c98920585.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--horn of heaven search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,98920585)
	e2:SetTarget(c98920585.thtg2)
	e2:SetOperation(c98920585.thop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c98920585.thcon)
	c:RegisterEffect(e3)
	c98920585.star_knight_summon_effect=e2
	--xyz summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,98930585)
	e4:SetCost(c98920585.cost)
	e4:SetTarget(c98920585.target)
	e4:SetOperation(c98920585.activate)
	c:RegisterEffect(e4)
end
function c98920585.indtg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c~=e:GetHandler()
end
function c98920585.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c98920585.sfilter1(c,tp)
	return c:IsSetCard(0x9c) and c:IsType(TYPE_MONSTER) and not c:IsCode(98920585) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c98920585.sfilter2,tp,LOCATION_DECK,0,1,c)
end
function c98920585.sfilter2(c)
	return c:IsSetCard(0x53) and c:IsType(TYPE_MONSTER) and not c:IsCode(98920585) and c:IsAbleToHand()
end
function c98920585.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920585.sfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c98920585.thop2(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c98920585.sfilter1,tp,LOCATION_DECK,0,nil,tp)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=Duel.SelectMatchingCard(tp,c98920585.sfilter2,tp,LOCATION_DECK,0,1,1,sg1:GetFirst())
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsNonAttribute,ATTRIBUTE_LIGHT))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98920585.filter(c,e,tp)
	return c:IsSetCard(0x9c,0x53) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920585.xyzfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,2,ct) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c98920585.fgoal(sg,exg)
	return aux.dncheck(sg) and exg:IsExists(Card.IsXyzSummonable,1,nil,sg,#sg,#sg)
end
function c98920585.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c98920585.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c98920585.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local exg=Duel.GetMatchingGroup(c98920585.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,ct)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct>1 and mg:CheckSubGroup(c98920585.fgoal,2,ct,exg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:SelectSubGroup(tp,c98920585.fgoal,false,2,ct,exg)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,sg1:GetCount(),0,0)
end
function c98920585.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920585.spfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,ct,ct) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c98920585.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c98920585.filter2,nil,e,tp)
	local ct=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.AdjustAll()
	if g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<ct then return end
	local xyzg=Duel.GetMatchingGroup(c98920585.spfilter,tp,LOCATION_EXTRA,0,nil,g,ct)
	if ct>=2 and xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsNonAttribute,ATTRIBUTE_LIGHT))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end