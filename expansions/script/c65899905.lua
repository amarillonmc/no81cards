--目标丢失
local s,id,o=GetID()
function s.initial_effect(c)
	--①：让对方指定场上以外的区域1处才能发动。自己失去1000基本分。这个效果在自己基本分小于1000的场合也能发动。
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
	local s=Duel.SelectField(1-tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,0xffffffff)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-1000)
end