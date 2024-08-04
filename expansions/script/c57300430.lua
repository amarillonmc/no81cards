--pvz bt z 史莱姆僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	Zombie_Characteristics_X(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.defcon)
	e1:SetTarget(s.deftg)
	e1:SetOperation(s.defop)
	c:RegisterEffect(e1)
end
function s.defcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetDefense()<=400 and e:GetHandler():GetFlagEffect(id)<2
end
function s.deftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(c:GetBaseDefense())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	if Duel.GetTurnPlayer()==tp then
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	else
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	end
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end