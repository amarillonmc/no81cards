--[[
【月】我们面对名为破灭的未来迈出一步
【Ｒ】Voyage Beyond the End
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
	aux.AddDoubleSidedProc(c,SIDE_REVERSE,id-1,id)
	c:Activation()
	--[[All monsters you control gain 500 ATK/DEF.]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	e1:UpdateDefenseClone(c)
	--[[During your End Phase, your opponent must discard 1 card from their hand.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(0,id)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE|PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:OPT()
	e2:SetFunctions(aux.TurnPlayerCond(0),nil,nil,s.discardop)
	c:RegisterEffect(e2)
	--[[Destroy this card if your opponent has no cards in their hand. ]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(s.sdcon)
	c:RegisterEffect(e3)
end
--E2
function s.discardop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_DISCARD|REASON_EFFECT)
end

--E3
function s.sdcon(e)
	return Duel.GetHandCount(1-e:GetHandlerPlayer())==0
end