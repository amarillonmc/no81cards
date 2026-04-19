--不■■
function c28380808.initial_effect(c)
	--remain field
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c28380808.activate)
	c:RegisterEffect(e1)
end
function c28380808.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c28380808.regop)
	Duel.RegisterEffect(e1,tp)
	local tc=Duel.GetMatchingGroup(nil,tp,0xff,0xff,e:GetHandler()):RandomSelect(0,1):GetFirst()
	Duel.Overlay(tc,e:GetHandler())
end
function c28380808.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,0)
end
