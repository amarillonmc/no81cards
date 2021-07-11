--未来崩崩崩
local m=33711501
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.target)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.condition)
	e3:SetOperation(cm.operation2)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetTarget(cm.condition)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.filter(c)
	return c:IsAbleToRemove()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		for tc in aux.Next(og) do
			if tc:IsLocation(LOCATION_REMOVED) then
				tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,0)
			end
		end 
	end
end
function cm.get(c)
	return c:GetFlagEffect(m)>0
end
function cm.condition(e)
	return Duel.GetMatchingGroupCount(cm.get,e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED,nil)>0
end
function cm.get1(c,e,tp)
	return c:GetFlagEffect(m)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetMatchingGroupCount(cm.get,e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if num>0 and Duel.SelectYesNo(e:GetHandlerPlayer(),aux.Stringid(m,1)) then
		Duel.Destroy(c,REASON_EFFECT)
		Duel.Recover(tp,num*1500,REASON_EFFECT)  
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(cm.get1,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,e,tp)
	if Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0 and #sg>0 and Duel.SelectYesNo(e:GetHandlerPlayer(),aux.Stringid(m,2)) then
	for tc in aux.Next(sg) do
		if Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)==0 then Duel.SendtoGrave(tc,REASON_RULE) 
		elseif tc:IsCanBeSpecialSummoned(e,0,e:GetHandler(),false,false) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetValue(cm.val)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_SET_ATTACK_FINAL)
			e5:SetValue(0)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e6)
			local e7=e5:Clone()
			e7:SetCode(EFFECT_CHANGE_LEVEL)
			e7:SetValue(1)
			tc:RegisterEffect(e7)
		end
	end
	Duel.SpecialSummonComplete()
	end
end
function cm.val(e,c)
	return c:IsRank(1)
end