--AK-记录者稀音
function c82568072.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c82568072.pcon)
	e2:SetTarget(c82568072.splimit2)
	c:RegisterEffect(e2)
	--sumlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(c82568072.excon)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c82568072.splimit)
	c:RegisterEffect(e3)
	--Cage Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82568072,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,82568072)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c82568072.sptg)
	e4:SetOperation(c82568072.spop)
	c:RegisterEffect(e4)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82568072,1))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,82568172)
	e6:SetCondition(c82568072.dwcon)
	e6:SetCost(c82568072.dwcost)
	e6:SetTarget(c82568072.dwtg)
	e6:SetOperation(c82568072.dwop)
	c:RegisterEffect(e6)
end
function c82568072.splimit2(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82568072.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0
end
function c82568072.excon(e)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==e:GetHandler():GetOwner() and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c82568072.splimit(e,se,sp,st,spos,tgp)
	return not (Duel.GetTurnPlayer()==e:GetHandler():GetOwner() and Duel.GetCurrentPhase()==PHASE_MAIN1)
end
function c82568072.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp)
  then  tc:AddCounter(0x5825,2)
	end
end
function c82568072.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82568073,0,0x4011,1000,900,2,RACE_MACHINE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c82568072.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,82568073,0,0x4011,1000,900,2,RACE_FIEND,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,82568073)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local g=Duel.GetOperatedGroup()
	local lz=g:GetFirst()
	local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_UNRELEASABLE_SUM)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetValue(1)
		lz:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		lz:RegisterEffect(e5)
		local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetCondition(c82568072.sdcon)
	lz:RegisterEffect(e6)
end
function c82568072.sdcon(e)
	return not Duel.IsExistingMatchingCard(c82568072.scfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c82568072.scfilter(c)
	return c:IsCode(82568072) and c:IsFaceup()
end
function c82568072.tkfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function c82568072.dwcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82568072.tkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c82568072.dwcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568072.dwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dwc=Duel.GetMatchingGroupCount(c82568072.tkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,dwc) end
	
	Duel.SetTargetPlayer(tp)
	if dwc<3 then
	Duel.SetTargetParam(dwc)
	else 
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dwc)
end
end
function c82568072.dwop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end