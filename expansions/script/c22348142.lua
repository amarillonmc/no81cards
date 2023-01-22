--万 魔 殿 -恶 魔 的 家 园-
local m=22348142
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348142+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c22348142.activate)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348142,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_PAY_LPCOST)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,22349142)
	e2:SetCondition(c22348142.atcon)
	e2:SetTarget(c22348142.attg)
	e2:SetOperation(c22348142.atop)
	c:RegisterEffect(e2)
	--apply effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348142,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c22348142.effcon)
	e3:SetCountLimit(1,22350142)
	e3:SetTarget(c22348142.efftg)
	e3:SetOperation(c22348142.effop)
	c:RegisterEffect(e3)
end
function c22348142.effcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler().SetCard_diyuemo
end
function c22348142.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c.SetCard_diyuemo and c:IsAbleToHand()
end
function c22348142.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22348142.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22348142,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c22348142.atcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c22348142.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x45)
end
function c22348142.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348142.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c22348142.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22348142.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ev)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c22348142.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c.SetCard_diyuemo and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove())
	then return false end
	local te=c.onfield_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c22348142.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if chk==0 then return (not (g:GetCount()==1 and g:GetFirst():IsCode(22348136)) and
	Duel.IsExistingMatchingCard(c22348142.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp))
	or((g:GetCount()==1 and g:GetFirst():IsCode(22348136)) and
	Duel.IsExistingMatchingCard(c22348142.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,g,e,tp,eg,ep,ev,re,r,rp))
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_MZONE)
end
function c22348142.effop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if g:GetCount()==1 and g:GetFirst():IsCode(22348136) then
	local tg=Duel.SelectMatchingCard(tp,c22348142.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,g,e,tp)
	local tc=tg:GetFirst()
	local te=tc.onfield_effect
	local op=te:GetOperation()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and op then op(e,tp,eg,ep,ev,re,r,rp) end
	else
	local tg=Duel.SelectMatchingCard(tp,c22348142.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=tg:GetFirst()
	local te=tc.onfield_effect
	local op=te:GetOperation()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end


