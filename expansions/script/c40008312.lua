--黑装死龙「渊风」
function c40008312.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c40008312.matfilter,1,1)   
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_LINK)
	e1:SetCountLimit(1,40008312)
	e1:SetCondition(c40008312.spcon)
	e1:SetOperation(c40008312.spop)
	c:RegisterEffect(e1) 
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c40008312.actlimit)
	c:RegisterEffect(e2)
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c40008312.atkval)
	c:RegisterEffect(e5)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c40008312.reptg)
	c:RegisterEffect(e4)
end
function c40008312.matfilter(c)
	return c:IsLinkRace(RACE_DRAGON)
end
function c40008312.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c40008312.atkval(e,c)
	return Duel.GetMatchingGroupCount(c40008312.cfilter,c:GetControler(),LOCATION_EXTRA,0,nil)*100
end
function c40008312.spfilter(c,tp,sc)
	return c:IsSetCard(0xf12) and c:IsType(TYPE_MONSTER)  and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0
end
function c40008312.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c40008312.spfilter,tp,LOCATION_REMOVED,0,1,nil)
end
function c40008312.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40008312.spfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c40008312.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetAttack()<e:GetHandler():GetAttack()
end
function c40008312.repfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemove() and c:IsFaceup()
end
function c40008312.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c40008312.repfilter,tp,LOCATION_EXTRA,0,2,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c40008312.repfilter,tp,LOCATION_EXTRA,0,2,2,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end