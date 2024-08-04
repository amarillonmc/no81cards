--pvz bt z 乌龟骑手僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	Zombie_Characteristics_EX(c,600)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
end
function s.atkfilter(c,tp)
	return not c:IsAttack(0) and c:IsFaceup() and c:IsControler(1-tp)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsControler(tp) then return end
	local g=c:GetColumnGroup():Filter(s.atkfilter,nil,tp)
	if g:GetCount()>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(math.ceil(c:GetAttack()/2))
			tc:RegisterEffect(e1)
		end
	end
end