--我是现实主义者！
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
end
function s.cfilter(c)
	return c:IsCode(id) and c:IsAbleToRemoveAsCost()
end
function s.filter(c)
	return c:IsCode(id) and c:GetFlagEffect(id)~=0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and g:GetCount()>0 end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
	end
	if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_REMOVED,0,3,nil) then
		local WIN_REASON_REALIST=0xffff
		Duel.Win(tp,WIN_REASON_REALIST)
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_AVOID_BATTLE_DAMAGE) and Duel.GetBattleDamage(tp)>0
		and tc:GetAttack()>=Duel.GetLP(tp) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	Duel.RegisterEffect(e1,tp)
end