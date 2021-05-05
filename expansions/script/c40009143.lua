--踏浪行军
function c40009143.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(40009143,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,40009143)
	e6:SetCondition(c40009143.condition3)
	e6:SetTarget(c40009143.sptg)
	e6:SetOperation(c40009143.spop)
	c:RegisterEffect(e6)
   --can not chain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c40009143.discon)
	e3:SetOperation(c40009143.ccop)
	c:RegisterEffect(e3)

end
function c40009143.condition3(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c40009143.spfilter(c,e,tp)
	return c:IsSetCard(0x6f1d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009143.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40009143.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c40009143.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009143.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(HALF_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c40009143.ccop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if ep==tp and re:IsActiveType(TYPE_MONSTER) and tc:IsType(TYPE_SYNCHRO) and tc:IsOriginalSetCard(0x6f1d,0x7f1d) then
		Duel.SetChainLimit(c40009143.chainlm)
	end
end
function c40009143.chainlm(e,rp,tp)
	return tp==rp
end
function c40009143.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6f1d) and c:IsType(TYPE_MONSTER)
end
function c40009143.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and Duel.IsExistingMatchingCard(c40009143.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
