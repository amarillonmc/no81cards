--左翼神威骑士长
function c24501006.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c24501006.setcon)
	e1:SetTarget(c24501006.settg)
	e1:SetOperation(c24501006.setop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c24501006.cost)
	e2:SetTarget(c24501006.damtg)
	e2:SetOperation(c24501006.damop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c24501006.sptg)
	e3:SetOperation(c24501006.spop)
	c:RegisterEffect(e3)
end
function c24501006.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c24501006.setfilter(c,tp)
	return c:IsCode(24501035) and not c:IsForbidden() or Duel.GetFieldGroupCount(tp,LOCATION_FZONE,0)>0 and c:IsSetCard(0x501) and not c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsLocation(LOCATION_GRAVE)
end
function c24501006.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501006.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c24501006.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c24501006.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c24501006.tdfilter(c)
	return c:IsSetCard(0x501) and c:IsAbleToDeckAsCost()
end
function c24501006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501006.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c24501006.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function c24501006.chkfilter(c)
	return c:IsSetCard(0x501) and c:IsFaceup()
end
function c24501006.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c24501006.chkfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.GetFlagEffect(tp,24501006)<ct end
	Duel.RegisterFlagEffect(tp,24501006,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,700)
end
function c24501006.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,700,REASON_EFFECT)
end
function c24501006.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24501006.gcheck(sg,lv)
	return sg:FilterCount(Card.IsType,nil,TYPE_TUNER)==1 and sg:GetSum(Card.GetLevel)==lv
end
function c24501006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetMZoneCount(tp)
	local g=Duel.GetMatchingGroup(c24501006.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>=2
		and #g>0 and g:CheckSubGroup(c24501006.gcheck,2,ft,e:GetHandler():GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c24501006.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	if not e:GetHandler():IsRelateToEffect(e) or ft<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(c24501006.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c24501006.gcheck,false,2,ft,e:GetHandler():GetLevel())
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
