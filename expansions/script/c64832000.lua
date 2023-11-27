--星光歌剧 爱城华恋
function c64832000.initial_effect(c)
	--summon proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(64832000,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c64832000.sumcon)
	e0:SetOperation(c64832000.sumop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,64832000)
	e1:SetCost(c64832000.cost)
	e1:SetTarget(c64832000.tg)
	e1:SetOperation(c64832000.op)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c64832000.disop)
	c:RegisterEffect(e2)
end
function c64832000.refil(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x6410)
end
function c64832000.sumcon(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c64832000.refil,tp,LOCATION_EXTRA,0,1,nil)
end
function c64832000.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c64832000.refil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c64832000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable(REASON_COST) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c64832000.thfil(c)
	return c:IsCode(64832001) and c:IsAbleToHand()
end
function c64832000.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64832000.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c64832000.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c64832000.thfil,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c64832000.disop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c64832000.didisop)
	Duel.RegisterEffect(e1,tp)
end
function c64832000.cfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c64832000.didisop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if tg and tg:IsExists(c64832000.cfilter,1,nil,tp) then
		Duel.NegateEffect(ev)
	end
end