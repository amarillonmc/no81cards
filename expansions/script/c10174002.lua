--束能赛道
function c10174002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c10174002.adjustop)
	c:RegisterEffect(e2)
	--selfdes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c10174002.descon)
	c:RegisterEffect(e3)
end
function c10174002.cfilter(c)
	return c:GetAttack()>c:GetBaseAttack() and c:IsFaceup()
end
function c10174002.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local ptbl={tp,1-tp}
	local tg=Group.CreateGroup()
	for i=1,2 do
		local p=ptbl[i]
		local g=Duel.GetMatchingGroup(c10174002.cfilter,p,LOCATION_MZONE,0,nil)
		local ct=g:GetCount()
		if ct>1 then
		   Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		   local tg2=g:Select(p,ct-1,ct-1,nil)
		   tg:Merge(tg2)
		end
	end
	if tg:GetCount()>0 then
		Duel.SendtoGrave(tg,REASON_RULE)
		Duel.Readjust()
	end
end
function c10174002.descon(e)
	return not Duel.IsExistingMatchingCard(c10174002.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

