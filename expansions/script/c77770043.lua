--灶门炭治郎(注：狸子DIY)
function c77770043.initial_effect(c)	
	--summon with no tribute/special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77770043,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c77770043.con)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c77770043.con)
	c:RegisterEffect(e2)
	--act qp in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x34a1,0x34a2))
	e3:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e3)
	--immune(无法变更种族)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c77770043.efilter)
	c:RegisterEffect(e4)
	--race
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(0,LOCATION_GRAVE)
	e5:SetCode(EFFECT_CHANGE_RACE)
	e5:SetCondition(c77770043.condition)
	e5:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e5)
		--boost
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77770043,0))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,77770043)
	e6:SetCondition(c77770043.atcon)
	e6:SetCost(c77770043.atcost)
	e6:SetTarget(c77770043.attg)
	e6:SetOperation(c77770043.atop)
	c:RegisterEffect(e6)
end
function c77770043.filter(c)
	return c:IsFaceup() and c:IsCode(77770040)
end
function c77770043.con(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c77770043.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c77770043.efilter(e,te)
	return te:GetHandler():IsCode(4064256,34989413,74701381)
end
function c77770043.condition(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY) 
end
function c77770043.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c77770043.cfilter(c)
	return c:IsSetCard(0x34a1,0x34a2) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToGraveAsCost()
end
function c77770043.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77770043.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c77770043.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c77770043.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77770043.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77770043.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77770043.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77770043.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)		
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(c77770043.efilter2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetOwnerPlayer(tp)
		tc:RegisterEffect(e2)
	end
end
function c77770043.efilter2(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end