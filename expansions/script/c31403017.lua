local m=31403017
local cm=_G["c"..m]
cm.name="本我龙-影龙"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.hspcost)
	e2:SetTarget(cm.hsptg)
	e2:SetOperation(cm.hspop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.discost)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
function cm.tgfilter(e,c)
	return c:IsSetCard(0xc311) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function cm.efilter(e,te,rp)
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.tgfilter)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,e:GetHandlerPlayer())
	local e2=e1:Clone()
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(cm.efilter)
	Duel.RegisterEffect(e2,e:GetHandlerPlayer())
end
function cm.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM+TYPE_RITUAL) and c:IsAbleToRemoveAsCost()
end
function cm.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc311) and c:IsDiscardable()
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
	return c:IsSetCard(0xc311) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.GetMatchingGroupCount(nil,tp,LOCATION_DECK,0,nil)>=2 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.BreakEffect()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end