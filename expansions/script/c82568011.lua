--方舟骑士·怪谈之子 巫恋
function c82568011.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	  --plimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c82568011.pcon)
	e1:SetTarget(c82568011.splimit)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82568011,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c82568011.ctcon)
	e2:SetCost(c82568011.ctcost)
	e2:SetTarget(c82568011.cttg)
	e2:SetOperation(c82568011.ctop)
	c:RegisterEffect(e2)
	--M3 Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82568011,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,82568011)
	e3:SetTarget(c82568011.sptg)
	e3:SetCost(c82568011.spcost)
	e3:SetOperation(c82568011.spop)
	c:RegisterEffect(e3)
	--def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsPosition,POS_FACEUP))
	e4:SetValue(c82568011.val)
	c:RegisterEffect(e4)	
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e5)
end
function c82568011.CDfilter(c)
	return c:IsCode(82568012) and c:IsFaceup()
end
function c82568011.MSfilter(c)
	return c:IsCode(82568011) and c:IsFaceup()
end
function c82568011.splimit(e,c,tp,sumtp,sumpos,re)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end
function c82568011.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0 
end
function c82568011.penfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c82568011.costfilter(c)
	return c:IsDiscardable()
end
function c82568011.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82568011.penfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler())
end
function c82568011.infilter(c)
	return c:IsCode(82567785)  and c:IsAbleToHand() 
end
function c82568011.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568011.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c82568011.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c82568011.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568011.infilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c82568011.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82568011.infilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c82568011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) and not Duel.IsExistingMatchingCard(c82568011.CDfilter,tp,LOCATION_MZONE,0,2,nil) 
	and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82568012,0,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c82568011.spop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,82568012,0,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) or not e:GetHandler():IsRelateToEffect(e) then return end
	local token=Duel.CreateToken(tp,82568012)
	if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)~=0 then
	local g=Duel.GetOperatedGroup()
	local m3=g:GetFirst()
	 local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetValue(1)
		m3:RegisterEffect(e1)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		m3:RegisterEffect(e5)
	 local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(1)
		m3:RegisterEffect(e3)
		 local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e7:SetValue(1)
		m3:RegisterEffect(e7)
		 local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e8:SetValue(1)
		m3:RegisterEffect(e8)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c82568011.sdcon)
	m3:RegisterEffect(e4)
end
end
function c82568011.sdcon(e)
	return not Duel.IsExistingMatchingCard(c82568011.MSfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c82568011.val(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rl=Duel.GetMatchingGroupCount(c82568011.CDfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return -rl*500
end