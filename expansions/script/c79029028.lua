--莱茵生命·医疗干员-赫默
function c79029028.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029028.splimit)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c79029028.reop)
	e3:SetCondition(c79029028.recon)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,79029028)
	e4:SetCost(c79029028.tocost)
	e4:SetTarget(c79029028.totg)
	e4:SetOperation(c79029028.toop)
	c:RegisterEffect(e4)
	--token 2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c79029028.condition)
	e5:SetCountLimit(1,790290289999999999999999999)
	e5:SetTarget(c79029028.target)
	e5:SetOperation(c79029028.operation)
	c:RegisterEffect(e5)
end
function c79029028.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029028.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c79029028.reop(e,tp,eg,ep,ev,re,r,rp)  
		Duel.Recover(tp,Duel.GetCounter(tp,LOCATION_ONFIELD,nil,0x1099)*100,REASON_EFFECT)
end
function c79029028.tocost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,5,REASON_COST)
end
function c79029028.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,79029029,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029028.toop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029029,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,79029029)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c79029028.reop(e,tp,eg,ep,ev,re,r,rp)  
		Duel.Recover(tp,Duel.GetCounter(tp,LOCATION_ONFIELD,nil,0x1099)*100,REASON_EFFECT)
end
function c79029028.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c79029028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,79029029,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029028.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029029,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,79029029)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end