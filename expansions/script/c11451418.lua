--march of dragon palace
local m=11451418
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Ad
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.cfilter(c)
	return c:IsRace(RACE_SEASERPENT) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.drfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(0x6978) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local gt=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return ft>0 and gt>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local gt=Duel.GetMatchingGroupCount(aux.NecroValleyFilter(cm.cfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	ft=math.min(ft,gt)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft<=0 or not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,ft,nil,e,tp)
	local r=g2:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.cfilter),tp,LOCATION_GRAVE,0,r,r,nil)
	tc=g2:GetFirst()
	while tc do
		tc:SetMaterial(g1)
		tc=g2:GetNext()
	end
	Duel.SendtoDeck(g1,tp,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
	Duel.BreakEffect()
	tc=g2:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		tc=g2:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	local sg=Group.CreateGroup()
	sg:AddCard(a)
	if b~=nil then sg:AddCard(b) end
	return sg:FilterCount(cm.drfilter,nil)~=0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	local sg=Group.CreateGroup()
	sg:AddCard(a)
	if b~=nil then sg:AddCard(b) end
	sg=sg:Filter(cm.drfilter,nil)
	if sg:GetCount()>0 then
		if sg:GetCount()>1 then sg=sg:Select(tp,1,1,nil) end
		local tc=sg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(tc:GetDefense()*2)
		tc:RegisterEffect(e2)
	end
end