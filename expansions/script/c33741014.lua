--Echoes Kernel #Mη - Tech Ruins
local s,id,o=GetID()
Duel.LoadScript("c33741000.lua")
function s.initial_effect(c)
	DEchoes.AddKernelFusion(c,RACE_MACHINE)
	DEchoes.AddGrantTrigger(c,id,s.grant)
end
function s.cfilter(c)
	return DEchoes.IsEchoes(c) and c:IsType(TYPE_MONSTER)
end
function s.ctfilter(c)
	return DEchoes.FaceupDEchoes(c) and c:GetCounter(DEchoes.COUNTER_TECH)==0 and c:IsCanAddCounter(DEchoes.COUNTER_TECH,1)
end
function s.atkval(e,c)
	return Duel.GetCounter(0,1,1,DEchoes.COUNTER_TECH)*400
end
function s.grant(e,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e,tp,eg) return eg:IsExists(s.cfilter,1,nil) end)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) return DEchoes.FaceupDEchoes(c) end)
	e2:SetValue(s.atkval)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2,true)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e3,true)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsCanAddCounter(DEchoes.COUNTER_TECH,1) then
		tc:AddCounter(DEchoes.COUNTER_TECH,1)
	end
end
