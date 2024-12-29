--马戏团团长 希拉斯·暗月
function c51924026.initial_effect(c)
	--pendulum summon reg
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c51924026.regcon)
	e3:SetOperation(c51924026.regop)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(TIMING_MAIN_END)
	e4:SetCountLimit(1,51924027)
	e4:SetCondition(c51924026.setcon)
	e4:SetTarget(c51924026.settg)
	e4:SetOperation(c51924026.setop)
	c:RegisterEffect(e4)
end
function c51924026.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c51924026.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e:GetHandler():RegisterFlagEffect(51924026,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1,0,1)
	elseif Duel.GetCurrentPhase()==PHASE_MAIN2 then
		e:GetHandler():RegisterFlagEffect(51924026,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN2,0,1)
	end
end
function c51924026.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(51924026)~=0
end
function c51924026.setfilter(c)
	return c:IsSetCard(0x3256) and c:IsSSetable()
end
function c51924026.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51924026.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c51924026.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,c51924026.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc then Duel.SSet(tp,sc) end
end
