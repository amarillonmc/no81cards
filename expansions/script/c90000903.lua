--被诱惑的施法者
function c90000903.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c90000903.lptg)
	e1:SetOperation(c90000903.lpop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90000903,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c90000903.tgcon)
	e3:SetTarget(c90000903.tgtg)
	e3:SetOperation(c90000903.tgop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	c:RegisterEffect(e4)
	--immune spell
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c90000903.efilter)
	c:RegisterEffect(e5)
end
function c90000903.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)~=16000 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCountLimit(1)
	e1:SetOperation(c90000903.regop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c90000903.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,16000)
end
function c90000903.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,90000903)
	Duel.SetLP(tp,4000)
end
function c90000903.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
end
function c90000903.tgfilter(c)
	return (c:IsAttackBelow(val) or c:IsDefenseBelow(val)) and c:IsAbleToGrave()
end
function c90000903.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	if chk==0 then return Duel.IsExistingMatchingCard(c90000903.tgfilter,tp,LOCATION_DECK,0,1,nil,val-1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c90000903.tgop(e,tp,eg,ep,ev,re,r,rp)
	local val=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c90000903.tgfilter,tp,LOCATION_DECK,0,1,1,nil,val-1)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c90000903.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
