--目标丢失
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectField(1-tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,0xffffffff)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>1000 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-1000)
end