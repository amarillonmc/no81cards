--宵暗的妖怪 露米娅
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsPosition,POS_FACEDOWN))
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(s.target)
	e2:SetOperation(s.prop)
	c:RegisterEffect(e2)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,d,1,0,0)
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	local c=e:GetHandler()
	if d:IsRelateToBattle() and d:IsDefensePos() and Duel.SendtoGrave(d,REASON_EFFECT)>0 and c:IsRelateToBattle() then
		Duel.ChainAttack()
	end
end