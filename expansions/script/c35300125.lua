--战源险胜
local m=35300125
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetOperation(cm.drawop)
	c:RegisterEffect(e3)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m+10000)
	e1:SetTarget(cm.desreptg)
	e1:SetValue(cm.desrepval)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,m+1)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e3)
end
function cm.drawop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.effilter)
	e1:SetValue(cm.efilter)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
	else
		e1:SetReset(RESET_PHASE+PHASE_MAIN2)
	end
	Duel.RegisterEffect(e1,tp)
end
function cm.effilter(e,c)
	return c:IsRace(RACE_DRAGON+RACE_WARRIOR)
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() 
end

function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsRace(RACE_DRAGON+RACE_WARRIOR) and not c:IsReason(REASON_REPLACE)
end
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(1-tp,1)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end