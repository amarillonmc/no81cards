--孝心变质 Token Effect
local s,id=GetID()

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(s.lpop)
	c:RegisterEffect(e1)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk,def=c:GetAttack(),c:GetDefense()
	if not atk or atk<0 then atk=0 end
	if not def or def<0 then def=0 end
	if atk==0 and def==0 then return end
	local val=math.max(atk,def)
	Duel.Recover(1-tp,val,REASON_EFFECT)
end