--pvz bt z 撑杆僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	Zombie_Characteristics_EX(c,400)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1)
	e1:SetTarget(s.deftg)
	e1:SetOperation(s.defop)
	c:RegisterEffect(e1)
end
function s.filter(c,g)
	return c:IsDefenseBelow(3000) and c:IsFaceup() and g:IsContains(c)
end
function s.deftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	cg:AddCard(c)
	if chkc then return s.filter(chkc,cg) and chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,cg) end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(tc:GetAttack()*-1)
		c:RegisterEffect(e2)
	end
end