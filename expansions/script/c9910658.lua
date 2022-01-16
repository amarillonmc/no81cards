--超界星暴
function c9910658.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c9910658.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c9910658.tdtg)
	e2:SetOperation(c9910658.tdop)
	c:RegisterEffect(e2)
end
function c9910658.cfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToRemove()
end
function c9910658.setfilter(c)
	return c:IsSetCard(0x956) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(9910658)
end
function c9910658.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetOverlayGroup(tp,1,0)
	if g1:GetCount()>0 then g:Merge(g1) end
	if g2:GetCount()>0 then g:Merge(g2) end
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		and g:IsExists(c9910658.cfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910658,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:FilterSelect(tp,c9910658.cfilter,1,1,nil):GetFirst()
		if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
		end
	end
end
function c9910658.check(c,tp)
	return c and c:IsControler(tp) and c:IsRace(RACE_MACHINE)
end
function c9910658.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=nil
	if c9910658.check(Duel.GetAttacker(),tp) then
		tc=Duel.GetAttackTarget()
	elseif c9910658.check(Duel.GetAttackTarget(),tp) then
		tc=Duel.GetAttacker()
	end
	if chk==0 then return Duel.GetAttackTarget()~=nil and tc and tc:IsAbleToDeck() end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
end
function c9910658.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAttack(0) and c:IsDefense(3000)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910658.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910658.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and c:IsRelateToEffect(e) and c:IsAbleToGrave()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and tg:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(9910658,1)) then
		Duel.BreakEffect()
		if Duel.SendtoGrave(c,REASON_EFFECT)==0 or not c:IsLocation(LOCATION_GRAVE) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
