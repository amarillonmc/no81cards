local m=53799163
local cm=_G["c"..m]
cm.name="菌屋"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	if bit.band(loc,LOCATION_ONFIELD)~=0 and rp==1 and (re:IsHasCategory(CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_DRAW)) then rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1) end
	if bit.band(loc,LOCATION_ONFIELD)~=0 and rp==1 and ex2 and bit.band(dv2,LOCATION_HAND)~=LOCATION_HAND then rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,2) end
end
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	return ((re:IsHasCategory(CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_DRAW)) and rc:GetFlagEffectLabel(m)==2) or ((ex2 and bit.band(dv2,LOCATION_HAND)~=LOCATION_HAND) and rc:GetFlagEffectLabel(m)==1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.sumlimit)
	if Duel.GetTurnPlayer()~=tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	end
	Duel.RegisterEffect(e1,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DRAW)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	if Duel.GetTurnPlayer()~=tp then
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	else
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	end
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_TO_HAND)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	Duel.RegisterEffect(e4,tp)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER) and se:IsHasType(EFFECT_TYPE_ACTIONS)
end
