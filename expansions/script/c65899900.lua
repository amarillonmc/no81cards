--陶片放逐法
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--win
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.condition3)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end

function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)
	return g1-g2>=7
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_TRUE_EXODIA = 0x3a30
	Duel.Win(tp,WIN_REASON_TRUE_EXODIA)
	if Duel.GetCurrentChain()==0 then Duel.Readjust() end
end

function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)
	return g2-g1>=7
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_TRUE_EXODIA = 0x3a30
	Duel.Win(1-tp,WIN_REASON_TRUE_EXODIA)
	if Duel.GetCurrentChain()==0 then Duel.Readjust() end
end