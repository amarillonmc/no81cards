--护王之魔棋阵
function c51931002.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,51931002)
	e1:SetCondition(c51931002.discon)
	e1:SetCost(c51931002.discost)
	e1:SetOperation(c51931002.disop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,51931003)
	e2:SetCost(c51931002.setcost)
	e2:SetTarget(c51931002.settg)
	e2:SetOperation(c51931002.setop)
	c:RegisterEffect(e2)
end
function c51931002.confilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x6258)
end
function c51931002.cfilter(c,tp)
	return c:IsSetCard(0x6258) and c:GetControler()==tp
end
function c51931002.discon(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg and tg:IsExists(c51931002.cfilter,1,nil,tp)
		and Duel.IsChainDisablable(ev) and rp==1-tp
end
function c51931002.costfilter(c)
	return c:IsSetCard(0x6258) and c:IsAbleToGraveAsCost()
end
function c51931002.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51931002.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c51931002.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c51931002.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev,true)
end
function c51931002.rmfilter(c)
	return c:IsSetCard(0x6258) and c:IsAbleToRemoveAsCost()
end
function c51931002.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51931002.rmfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c51931002.rmfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	sg:AddCard(e:GetHandler())
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c51931002.setfilter(c,tp)
	return c:IsSetCard(0x6258) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c51931002.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c51931002.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c51931002.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c51931002.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
