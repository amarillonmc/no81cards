--秋叶夏花
local m=13090006
local cm=_G["c"..m]
function c13090006.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--to szone
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,13090006)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.tstg)
	e1:SetOperation(cm.tsop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,23090006)
	e4:SetCondition(cm.con2)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.activate)
	c:RegisterEffect(e4) 
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
	end
end
function cm.tsfilter(c,tp)
	return c:IsSetCard(0xe08) and c:IsFaceup() and not c:IsCode(13090006)
end
function cm.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tsfilter,tp,LOCATION_EXTRA,0,1,nil) and e:GetHandler() end
end
function cm.tsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,cm.tsfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	local te=tc.star_knight_spsummon_effect
	local tg=te:GetTarget()
	local aa=e:GetLabelObject()
	local bb=tc.star_knight_spsummon_effect
	local op=bb:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.penfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe08)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_EXTRA) end
	local tc=eg:GetFirst()
	Duel.ClearTargetCard()
	e:SetLabelObject(tc)
	local te=tc.star_knight_summon_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
   local tc=e:GetLabelObject()
	local te=tc.star_knight_summon_effect
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return rc:IsLocation(LOCATION_EXTRA) and rc:IsFaceup() and rc:IsSetCard(0xe08) and rc:IsLevelBelow(5)
end