--[[
【日】我们面对名为未来的破灭迈出一步
【Ｏ】Voyage to the End
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
if not TYPE_DOUBLESIDED then
	Duel.LoadScript("glitchylib_doublesided.lua")
end
function s.initial_effect(c)
	aux.AddDoubleSidedProc(c,SIDE_OBVERSE,id+1,id)
	c:EnableCounterPermit(COUNTER_VOYAGE_TO_THE_END)
	c:SetCounterLimit(COUNTER_VOYAGE_TO_THE_END,5)
	c:Activation()
	--[[During your End Phase: You can discard 1 card; place 1 counter on this card (max. 5).]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:OPT()
	e1:SetFunctions(aux.TurnPlayerCond(0),aux.DiscardCost(nil,1),s.cttg,s.ctop)
	c:RegisterEffect(e1)
	--[[All monsters you control gain 200 ATK/DEF for each counter on this card.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	e2:UpdateDefenseClone(c)
	--[[Destroy this card if you have no cards in your hand.]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(s.sdcon)
	c:RegisterEffect(e3)
	--[[During your Main Phase, if there are exactly 5 counters on this card: You can Transform this card into "Voyage Beyond the End". ]]
	local e4=Effect.CreateEffect(c)
	e4:Desc(1,id)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetFunctions(s.trcon,nil,aux.IsCanTransformTargetFunction,aux.TransformOperationFunction(SIDE_REVERSE))
	c:RegisterEffect(e4)
end
--E1
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanAddCounter(COUNTER_VOYAGE_TO_THE_END,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,tp,COUNTER_VOYAGE_TO_THE_END)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() and c:IsCanAddCounter(COUNTER_VOYAGE_TO_THE_END,1) then
		c:AddCounter(COUNTER_VOYAGE_TO_THE_END,1)
	end
end

--E2
function s.atkval(e,c)
	local ct=e:GetHandler():GetCounter(COUNTER_VOYAGE_TO_THE_END)
	return ct*200
end

--E3
function s.sdcon(e)
	return Duel.GetHandCount(e:GetHandlerPlayer())==0
end

--E4
function s.trcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(COUNTER_VOYAGE_TO_THE_END)==5
end