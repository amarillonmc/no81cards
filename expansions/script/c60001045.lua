--灵刀术式 复战双裂
function c60001045.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60001045,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c60001045.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001045,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60001045)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60001045.settg)
	e2:SetOperation(c60001045.setop)
	c:RegisterEffect(e2)
end
function c60001045.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c60001045.drcon1)
	e1:SetOperation(c60001045.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c60001045.regcon)
	e2:SetOperation(c60001045.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c60001045.drcon2)
	e3:SetOperation(c60001045.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c60001045.cfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD)
end
function c60001045.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001045.cfilter,1,nil,tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c60001045.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60001045)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c60001045.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001045.cfilter,1,nil,tp) and Duel.GetFlagEffect(tp,60001045)==0
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c60001045.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,60001045,RESET_CHAIN,0,1)
end
function c60001045.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,60001045)>0
end
function c60001045.drop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,60001045)
	Duel.Hint(HINT_CARD,0,60001045)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c60001045.stfilter(c)
	return c:IsSetCard(0x624) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c60001045.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c60001045.stfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function c60001045.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c60001045.stfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end