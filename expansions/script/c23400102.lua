--钓瓶落琪斯美
local m=23400102
local cm=c23400102
function c23400102.initial_effect(c)
		local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCountLimit(1,m)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_HAND)  
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target2)
	e3:SetOperation(cm.activate2)
	c:RegisterEffect(e3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.filter2(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSummonLocation(LOCATION_GRAVE) and c:IsSummonPlayer(1-tp)
		and c:IsAbleToRemove()
end
function cm.fit(c)
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_ZOMBIE)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.filter2,1,nil,tp) end
	if Duel.GetMatchingGroupCount(cm.fit,tp,LOCATION_GRAVE,0,nil)<1 then e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE) end
	local g=eg:Filter(cm.filter2,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end

function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter2,nil,tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	while tc do
	if  tc:IsCanBeDisabledByEffect(e) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
	tc=g:GetNext()
	end
	end
end