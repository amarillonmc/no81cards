--砾岩山谷落岩
local m=33331710
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,33331708)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.fdtg)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.fs,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.fs(c)
	return c:IsFaceup() and c:IsCode(33331708)
end
function cm.fdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ==0 then return Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.fcheck,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(cm.check,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g2,#g2,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
function cm.check(c)
	return c:IsFaceup() and c:IsRace(RACE_ROCK) and c:IsCanChangePosition()
end
function cm.fcheck(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(cm.check,tp,LOCATION_MZONE,0,nil)
	if g2:GetCount()>0 then
		if Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE) then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(cm.fcheck,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end