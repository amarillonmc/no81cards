local m=31400113
local cm=_G["c"..m]
cm.name="真龙呼相争"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0xf9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.kingfilter(c)
	return c:IsLevel(9) and c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND)
end
function cm.dracofilter(c)
	return not cm.kingfilter(c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:FilterCount(cm.kingfilter,nil)>0 and g:FilterCount(cm.dracofilter,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:FilterCount(cm.kingfilter,nil)==0 or g:FilterCount(cm.dracofilter,nil)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:Filter(cm.kingfilter,nil):Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	sg:Merge(g:Filter(cm.dracofilter,nil):Select(tp,1,1,nil))
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleDeck(tp)
	local tc=sg:RandomSelect(1-tp,1):GetFirst()
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	sg:RemoveCard(tc)
	Duel.Destroy(sg,REASON_EFFECT)
end
function cm.handcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end