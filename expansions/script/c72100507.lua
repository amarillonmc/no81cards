--渴望母爱的少女 崔斯坦
local m=72100507
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,1))
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCountLimit(1,m)
	e8:SetCost(cm.descost)
	e8:SetTarget(cm.thtg)
	e8:SetOperation(cm.thop)
	c:RegisterEffect(e8)
	local e2=e8:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e8:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,1))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetRange(LOCATION_HAND)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCountLimit(1,m+1000)
	e9:SetCost(cm.spcost)
	e9:SetOperation(cm.activate)
	c:RegisterEffect(e9)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function cm.filter(c)
	return c:IsSetCard(0x9a2) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local g1=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.BreakEffect()
		Duel.HintSelection(g1)
		Duel.Destroy(g1,REASON_EFFECT)
	end
end
--------
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0xff,0xff)
	e2:SetTarget(cm.retg)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.retg(e,c)
	return not c:IsSetCard(0x9a2)
end
function cm.cffilter(c)
	return c:IsSetCard(0x9a2) and not c:IsPublic()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cffilter,tp,LOCATION_HAND,0,2,c)
		and c:GetFlagEffect(m)==0 and not e:GetHandler():IsPublic() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cffilter,tp,LOCATION_HAND,0,2,2,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end