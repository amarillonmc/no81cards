--暴风猫
function c64800111.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c64800111.txtcon)
	e0:SetOperation(c64800111.txtop)
	c:RegisterEffect(e0)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(c64800111.spcon)
	e1:SetOperation(c64800111.spop)
	c:RegisterEffect(e1)
	--Activate(summon)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,64800111)
	e2:SetCondition(c64800111.rmcon)
	e2:SetTarget(c64800111.rmtg)
	e2:SetOperation(c64800111.rmop)
	c:RegisterEffect(e2)
end

function c64800111.txtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c64800111.txtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(64800111,4))
	Duel.Hint(24,0,aux.Stringid(64800111,5))
	Duel.Hint(24,0,aux.Stringid(64800111,6))
end

--e1
function c64800111.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,c)
end
function c64800111.spop(e,tp,eg,ep,ev,re,r,rp)
	--atk 0
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

--e2
function c64800111.rmfilter(c)
	local smp=c:GetControler()
	return c:IsAbleToRemove() and Duel.GetMZoneCount(smp,c)>0
end
function c64800111.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function c64800111.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c64800111.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanSpecialSummonMonster(tp,64800112,0,0x4011,3000,0,8,RACE_WARRIOR,ATTRIBUTE_WIND,POS_FACEUP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c64800111.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c64800111.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local smp=tc:GetControler()
	if tc:IsRelateToEffect(e) and Duel.GetMZoneCount(smp,tc)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,64800112,0,0x4011,3000,0,8,RACE_WARRIOR,ATTRIBUTE_WIND,POS_FACEUP) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local token=Duel.CreateToken(tp,64800112)
		Duel.SpecialSummon(token,0,tp,smp,false,false,POS_FACEUP)
	end
end