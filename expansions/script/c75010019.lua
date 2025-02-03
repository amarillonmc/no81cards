--咒怨之甲
function c75010019.initial_effect(c)
	--spsummon-other
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75010019+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75010019.target)
	e1:SetOperation(c75010019.activate)
	c:RegisterEffect(e1)
	--select
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c75010019.slcon)
	e2:SetTarget(c75010019.sltg)
	e2:SetOperation(c75010019.slop)
	c:RegisterEffect(e2)
end
function c75010019.rmfilter(c,e,chk)
	return c:IsAbleToRemove() and (chk==0 or not c:IsImmuneToEffect(e))
end
function c75010019.gcheck(sg,tp)
	return Duel.GetMZoneCount(tp,sg)>0
end
function c75010019.rsfilter(c,e,tp,chk)
	local g=Group.FromCards(c,e:GetHandler())
	local rg=Duel.GetMatchingGroup(c75010019.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,g,e,chk)
	local lv=c:GetLevel()
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:IsType(TYPE_RITUAL) and rg:CheckSubGroup(c75010019.gcheck,lv,lv,tp)
end
function c75010019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75010019.rsfilter,tp,0x13,0,1,nil,e,tp,0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c75010019.activate(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75010019.rsfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,1):GetFirst()
	if not sc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(c75010019.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,Group.FromCards(sc,e:GetHandler()),e,1)
	local sg=g:SelectSubGroup(tp,c75010019.gcheck,false,sc:GetLevel(),sc:GetLevel(),tp)
	Duel.HintSelection(sg)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
	Duel.BreakEffect()
	local og=Duel.GetOperatedGroup()
	sc:SetMaterial(og)
	Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	sc:CompleteProcedure()
	--effect
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c75010019.atkval)
	sc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	sc:RegisterEffect(e3)
end
function c75010019.eqlimit(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_RITUAL)
end
function c75010019.atkval(e,c)
	return c:GetBaseAttack()
end
function c75010019.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function c75010019.slcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c75010019.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToGrave()
end
function c75010019.sltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:GetHandler():IsAbleToHand() and Duel.GetFlagEffect(tp,75010019)==0
	local b2=Duel.IsExistingMatchingCard(c75010019.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,75010020)==0
	if chk==0 then return b1 or b2 end
end
function c75010019.slop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsRelateToEffect(e) and c:IsAbleToHand() and Duel.GetFlagEffect(tp,75010019)==0
	local b2=Duel.IsExistingMatchingCard(c75010019.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,75010020)==0
	local op=aux.SelectFromOptions(tp,
		{b1,1190},
		{b2,1191})
	if op==1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		Duel.RegisterFlagEffect(tp,75010019,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c75010019.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,75010020,RESET_PHASE+PHASE_END,0,1)
	end
end
