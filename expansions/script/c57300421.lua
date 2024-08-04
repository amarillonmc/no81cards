--pvz bt z Z科技射线僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	Zombie_Characteristics_EX(c,300)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(s.dtg)
	e1:SetOperation(s.dop)
	c:RegisterEffect(e1)
end
function s.filter(c,g)
	return c:IsFaceup() and g:IsContains(c)
end
function s.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	cg:AddCard(c)
	if chkc then return s.filter(chkc,cg) and chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,cg)
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e2)
	end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e2)
	end
end