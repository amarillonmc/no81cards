--[[
键★LB令 - 幸福螺旋！
K.E.Y L.B.O - Let's Start The Sprial of Happiness!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_KEYFRAGMENT_LOADED then
	GLITCHYLIB_KEYFRAGMENT_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
Duel.LoadScript("glitchylib_helper.lua")
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_LBO_HAPPINESS)
	c:SetCounterLimit(COUNTER_LBO_HAPPINESS,10)
	c:Activation()
	--[[Each time you pay LP to activate a FIRE "K.E.Y" monster effect: Place 1 counter on this card for each 100 LP you paid (max. 10).]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PAY_LPCOST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetFunctions(s.ctcon,nil,s.cttg,s.ctop)
	c:RegisterEffect(e1)
	--All FIRE "K.E.Y" monsters you control gain 100 ATK/DEF for each counter on this card, during the Battle Phase only.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(aux.BattlePhaseCond())
	e2:SetTarget(s.target)
	e2:SetValue(s.value)
	c:RegisterEffect(e2)
	e2:UpdateDefenseClone(c)
end

--E1
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if not re or rp~=tp or ev<100 then return end
	local rc=re:GetHandler()
	return re:IsActivated() and re:IsActiveType(TYPE_MONSTER) and rc:IsAttribute(ATTRIBUTE_FIRE)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,math.floor(ev/100),0,COUNTER_LBO_HAPPINESS)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=math.floor(ev/100)
	if c:IsRelateToChain() and c:IsCanAddCounter(COUNTER_LBO_HAPPINESS,ct,true) then
		c:AddCounter(COUNTER_LBO_HAPPINESS,ct,1)
	end
end

--E2
function s.target(e,c)
	return c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.value(e,c)
	local c=e:GetHandler()
	local ct=c:GetCounter(COUNTER_LBO_HAPPINESS)
	return ct*100
end