--pvz bt z 电鱼僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	Zombie_Characteristics_EX(c,400)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(s.defcon)
	e3:SetOperation(s.defop)
	c:RegisterEffect(e3)
end
function s.defcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,57300456)
end
function s.deffilter(c,tp)
	return c:GetColumnGroup():IsExists(aux.AND(Card.IsFaceup,Card.IsCode),1,nil,57300456)
		and c:IsFaceup()
		and c:GetFlagEffect(57300424)~=0
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.deffilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(c:GetAttack()*-1)
			tc:RegisterEffect(e1)
		end
	end
end