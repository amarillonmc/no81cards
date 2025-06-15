--[[
宏大之殇
Wound of Greatness
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[Apply the following effects for the rest of the Duel.
	● Monsters you control gain ATK/DEF equal to their original ATK/DEF, also they cannot be destroyed by card effects during your turn.
	● If a card(s) you control leaves the field: Send all cards you control to the GY. ]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(
		nil,
		nil,
		s.target,
		s.activate
	)
	c:RegisterEffect(e1)
end
--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(s.atkval)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:UpdateDefenseClone(c,true)
	e2:SetValue(s.defval)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(aux.TurnPlayerCond(0))
	e3:SetValue(1)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:Desc(2,id)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetFunctions(s.tgcon,nil,s.tgtg,s.tgop)
	Duel.RegisterEffect(e4,tp)
end
function s.atkval(e,c)
	return math.max(0,c:GetBaseAttack())
end
function s.defval(e,c)
	return math.max(0,c:GetBaseDefense())
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousControler,1,nil,tp)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,tp,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end