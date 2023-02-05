local m=53796096
local cm=_G["c"..m]
cm.name="惑星探求"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(cm.setcost)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
end
cm.counter_add_list={0x100e}
function cm.tgfilter(c)
	return c:IsCode(14729426) and c:IsAbleToGrave()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x100e,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,99,nil)
	if #sg==0 then return end
	Duel.SendtoGrave(sg,REASON_EFFECT)
	local ct=sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x100e,1)
	if ct==0 or g:GetCount()==0 then return end
	for i=1,ct*2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local sg=g:Select(tp,1,1,nil)
		sg:GetFirst():AddCounter(0x100e,1)
	end
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:GetCounter(0x100e)>0
end
function cm.spfilter(c,e,tp)
	return c:IsCode(14729426) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.ctfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.ctfilter,tp,0,LOCATION_MZONE,nil)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,0x13,0,nil,e,tp)
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),g:GetCount(),ct)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,ft,nil)
	for tc in aux.Next(sg) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e0:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e0:SetValue(LOCATION_DECKSHF)
		tc:RegisterEffect(e0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetCondition(cm.atkcon)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOwnerPlayer(tp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function cm.atkcon(e)
	return e:GetHandler():IsControler(e:GetOwnerPlayer())
end
function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(function(c,tp)return c:GetOwner()~=tp end,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return #g>0 and g:FilterCount(Card.IsReleasable,nil)==#g end
	Duel.Release(g,REASON_COST)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
end
