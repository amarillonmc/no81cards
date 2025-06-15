--[[
花花变身·动物朋友 赤龙
H-Anifriends Red Dragon
Card Author: nemoma
Scripted by: XGlitchy30
]]
local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:EnableReviveLimit()
	--2+ monsters with different names
	aux.AddLinkProcedure(c,nil,2,nil,s.lcheck)
	--Can only be Special Summoned while your LP is 2000+ lower than your opponent.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(s.spcost)
	c:RegisterEffect(e0)
	--This card's name becomes "Anifriends Red Dragon of Summer" while on the field or in the GY.
	aux.EnableChangeCode(c,id-1,LOCATION_MZONE|LOCATION_GRAVE)
	--This card's ATK becomes equal to the difference between the players' LP.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.adval)
	c:RegisterEffect(e1)
	--If a card(s) you control would be destroyed, you can make your LP become equal to your opponent's LP, instead. (This effect cannot be used if both players have the same LP).
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.destg)
	e2:SetValue(s.repval)
	c:RegisterEffect(e2)
end
function s.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end

--E0
function s.spcost(e,c,tp,st)
	return Duel.GetLP(1-tp)-Duel.GetLP(tp)>=2000
end

--E1
function s.adval(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end

--E2
function s.desfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.desfilter,1,nil,tp) and Duel.GetLP(0)-Duel.GetLP(1)~=0 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.SetLP(tp,Duel.GetLP(1-tp))
		return true
	else return false end
end
function s.repval(e,c)
	return s.desfilter(c,e:GetHandlerPlayer())
end