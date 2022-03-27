local m=53799240
local cm=_G["c"..m]
cm.name="再思"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end)
	e0:SetValue(cm.zones)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.settg)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)
end
function cm.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		if tc:IsLocation(LOCATION_MZONE) then seq=aux.MZoneSequence(seq) end
		if seq<5 then zone=zone|1<<(4-seq) end
	end
	return zone
end
function cm.setfilter(c,check)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and (check or c:IsCode(m))
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,3,nil,m)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil,check) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local check=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,3,nil,m)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	if #g>0 and Duel.SSet(tp,g)~=0 and not g:GetFirst():IsCode(m) then
		Duel.BreakEffect()
		Duel.SendtoDeck(Duel.GetMatchingGroup(function(c)return c:IsFaceup() and c:IsCode(m)end,tp,LOCATION_ONFIELD,0,nil,m),nil,2,REASON_EFFECT)
	end
end
