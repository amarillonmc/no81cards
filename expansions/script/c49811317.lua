local cm,m = GetID()
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg2)
	e3:SetOperation(cm.op2)
	c:RegisterEffect(e3)
end
function cm.f(c)
	return c:IsCode(21507589,32703716) and c:IsSSetable()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.f,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.f,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_ONFIELD)==0 and rp~=tp
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	 local g=Duel.GetMatchingGroup(cm.ff,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp),Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_REMOVED,0,nil,m)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.ff(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(23771716)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g1,g2=Duel.GetMatchingGroup(cm.ff,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp),Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_REMOVED,0,nil,m)
	local ct = #g2
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct then ct = Duel.GetLocationCount(tp,LOCATION_MZONE) end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or #g1<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g = g1:Select(tp,1,ct,nil)
	if #g==0 then return false end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end