local m=53757014
local cm=_G["c"..m]
cm.name="无穷界构"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and (c:IsRace(RACE_DRAGON) or c:IsType(TYPE_FIELD)) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,Group.FromCards(c))
end
function cm.IsCodeListed1(c,g)
	for tc in aux.Next(g) do if aux.IsCodeListed(c,tc:GetCode()) then return true end end
	return false
end
function cm.IsCodeListed2(c,g)
	for tc in aux.Next(g) do if aux.IsCodeListed(tc,c:GetCode()) then return true end end
	return false
end
function cm.thfilter(c,g)
	return (cm.IsCodeListed1(c,g) or cm.IsCodeListed2(c,g)) and c:IsAbleToHand()
end
function cm.fselect1(g)
	if #g==1 then return true end
	return aux.gffcheck(g,Card.IsRace,RACE_DRAGON,Card.IsType,TYPE_FIELD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.fselect2(g,sg)
	if #g==1 then return true end
	return aux.gffcheck(g,cm.IsCodeListed1,sg,cm.IsCodeListed2,sg)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
	if #g1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg1=g1:SelectSubGroup(tp,cm.fselect1,false,1,2)
	Duel.ConfirmCards(1-tp,sg1:Filter(Card.IsFacedown,nil))
	local g2=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,sg1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg2=g2:SelectSubGroup(tp,cm.fselect2,false,1,2,sg1)
	Duel.SendtoHand(sg2,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg2)
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsType(TYPE_SPELL) and Group.__band(c:GetColumnGroup(),Duel.GetMatchingGroup(cm.repcfilter,tp,LOCATION_MZONE,0,nil)):GetCount()>0
end
function cm.repcfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and re:IsActivated() and rp~=tp and eg:IsExists(cm.repfilter,1,nil,tp) and e:GetHandler():IsAbleToHand() end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,0))
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,POS_FACEUP,REASON_EFFECT)
end
