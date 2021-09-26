--击退者 怒态龙
local m=40010048
local cm=_G["c"..m]
cm.named_with_Revenger=1
function cm.Revenger(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Revenger
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1) 
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.condition)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)   
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function cm.spfilter(c,e,tp)
	return cm.Revenger(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=LOCATION_MZONE+LOCATION_HAND 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then loc=LOCATION_MZONE end
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,loc,0,1,e:GetHandler())
			and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_MZONE+LOCATION_HAND 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then loc=LOCATION_MZONE end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,loc,0,1,1,e:GetHandler())
	if g:GetCount()>0 and Duel.Release(g,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function cm.cfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function cm.spfilter2(c,e,tp)
	return cm.Revenger(c) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=LOCATION_MZONE 
		return Duel.IsExistingMatchingCard(cm.cfilter2,tp,loc,0,3,nil)
			and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_MZONE 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,loc,0,3,3,nil)
	if g:GetCount()>0 and Duel.Release(g,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=sg:GetFirst()
		if tc then
			tc:SetMaterial(nil)
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end