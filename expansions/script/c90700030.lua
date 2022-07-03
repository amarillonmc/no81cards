local m=90700030
local cm=_G["c"..m]
cm.name="阻断药"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetOperation(cm.antisumop)
	c:RegisterEffect(e1)
	local e2=Effect.Clone(e1)
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=Effect.Clone(e1)
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetOperation(cm.changeop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetCode(EVENT_TURN_END)
	e5:SetOperation(cm.recycleop)
	c:RegisterEffect(e5)
end
function cm.antisumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 then return end
	Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESET_CHAIN,0,1)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,m)
	if g:GetCount()==0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Remove(g:Select(tp,1,1,nil),POS_FACEUP,REASON_RULE)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Remove(eg,POS_FACEDOWN,REASON_RULE)
end
function cm.changeop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(re:GetCategory(),CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)==0 then return end
	if Duel.GetFlagEffect(tp,m)>0 then return end
	Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESET_CHAIN,0,1)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,m)
	if g:GetCount()==0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Remove(g:Select(tp,1,1,nil),POS_FACEUP,REASON_RULE)
	Duel.Hint(HINT_CARD,0,m)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,function() return end)
end
function cm.recycleop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_REMOVED,0,nil,m)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_RULE)
end