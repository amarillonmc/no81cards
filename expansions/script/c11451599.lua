--创界王 志那都
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.adcon)
	e1:SetCost(cm.adcost)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--barrier
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.sccon)
	--e2:SetCost(cm.sccost)
	e2:SetTarget(cm.sctg)
	e2:SetOperation(cm.scop)
	c:RegisterEffect(e2)
end
function cm.filter(c,tp)
	return c:IsControler(tp)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
function cm.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.cfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function cm.mfilter(c,ac,bc,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ac:GetAttribute()) and c:IsAttribute(bc:GetAttribute())
end
function cm.sfilter(c,ac,bc,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetAttribute()~=ac:GetAttribute() and c:GetAttribute()~=bc:GetAttribute()
end
function cm.sabcheck(g,e,tp)
	return g:GetFirst():GetAttribute()&g:GetNext():GetAttribute()>0 and Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_DECK,0,1,nil,g:GetFirst(),g:GetNext(),e,tp)
end
function cm.dabcheck(g,e,tp)
	return aux.dabcheck(g) and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_GRAVE,0,1,nil,g:GetFirst(),g:GetNext(),e,tp)
end
function cm.fselect(g,e,tp)
	return cm.sabcheck(g,e,tp) or cm.dabcheck(g,e,tp)
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_MZONE,nil,e)
	if chkc then return false end
	if chk==0 then return (g:CheckSubGroup(cm.sabcheck,2,2,e,tp) or g:CheckSubGroup(cm.dabcheck,2,2,e,tp)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,e,tp)
	Duel.SetTargetCard(sg)
	local loc=LOCATION_DECK
	if cm.sabcheck(sg,e,tp) and cm.dabcheck(sg,e,tp) then
		loc=LOCATION_DECK+LOCATION_GRAVE
	elseif cm.dabcheck(sg,e,tp) then
		loc=LOCATION_GRAVE
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function cm.tfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.tfilter,nil,e)
	if #g<2 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ac=g:GetFirst()
	local bc=g:GetNext()
	local b1=Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_DECK,0,1,nil,g:GetFirst(),g:GetNext(),e,tp)
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.sfilter),tp,LOCATION_GRAVE,0,1,nil,g:GetFirst(),g:GetNext(),e,tp)
	if ac:IsAttribute(bc:GetAttribute()) and (ac:GetAttribute()==bc:GetAttribute() or ((b1 or not b2) and Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))==0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.mfilter,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst(),g:GetNext(),e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.sfilter),tp,LOCATION_GRAVE,0,1,1,nil,g:GetFirst(),g:GetNext(),e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end