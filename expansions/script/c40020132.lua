--辉翼之魔术师
local m=40020132
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) 
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.penfilter(c)
	return (c:IsSetCard(0x2016) or c:IsSetCard(0x98)) and c:IsType(TYPE_PENDULUM)  and not c:IsCode(m) and not c:IsForbidden()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.BreakEffect()
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function cm.tgfilter(c)
	return ((c:IsSetCard(0x2016) and c:IsType(TYPE_TUNER)) or c:IsType(TYPE_SYNCHRO))
		 and c:IsAbleToGrave() and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(82044279) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end