--恶 魔 之 颜
local m=22348122
local cm=_G["c"..m]
function cm.initial_effect(c)
	--atkup remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348122,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c22348122.target1)
	e1:SetOperation(c22348122.operation1)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348122,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetTarget(c22348122.target2)
	e2:SetOperation(c22348122.operation2)
	c:RegisterEffect(e2)
	
end
function c22348122.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rg=Duel.GetDecktopGroup(tp,5)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,5,0,0)
end
function c22348122.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.GetDecktopGroup(tp,5)
	Duel.DisableShuffleCheck()
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then
		local ct=Duel.GetMatchingGroupCount(aux.ture,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		if ct>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*100)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end
function c22348122.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function c22348122.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348122)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end

