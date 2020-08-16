--DarkBug Remake
local m=33330078
local cm=_G["c"..m]
function c33330078.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.filter(c)
	return c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsPlayerCanSpecialSummonMonster(tp,33330077,0,0x4011,1800,1800,4,RACE_CYBERSE,ATTRIBUTE_EARTH) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,g:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local recount=0
	while tc do
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetOperation(cm.retop)
			Duel.RegisterEffect(e1,tp)
			recount=recount+1
		end
		tc=g:GetNext()
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e3:SetTargetRange(0,1)
		e3:SetValue(HALF_DAMAGE)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	local scount=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if recount>scount then
		recount=scount
	end
	if recount>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33330077,0,0x4011,1800,1800,4,RACE_CYBERSE,ATTRIBUTE_EARTH) then 
		for i=1,recount do
			local token=Duel.CreateToken(tp,33330077)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end