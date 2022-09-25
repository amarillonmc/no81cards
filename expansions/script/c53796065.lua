local m=53796065
local cm=_G["c"..m]
cm.name="门醒之都 德兹鲁索"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(cm.value)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.atkfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:GetRace()~=0 and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.value(e,c)
	local p,tp=c:GetControler(),e:GetHandlerPlayer()
	local g1,g2=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil),Duel.GetMatchingGroup(cm.atkfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
	local ct1,ct2=g1:GetClassCount(Card.GetRace),g2:GetClassCount(Card.GetRace)
	if p==tp then return (ct1-ct2)*200 else return (ct2-ct1)*200 end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	return #g>0 and g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)==#g
end
function cm.spfilter(c,e,tp,atk)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAttackBelow(atk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local g=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		local ct=g:GetClassCount(Card.GetRace)*500
		return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,ct)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetRace)*500
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp,ct)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
