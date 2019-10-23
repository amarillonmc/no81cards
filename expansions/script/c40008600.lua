--究极异兽-堆砌之堡垒石
function c40008600.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c40008600.ovfilter,aux.Stringid(40008600,0),3,c40008600.xyzop)
	c:EnableReviveLimit()  
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c40008600.imcon)
	e4:SetValue(c40008600.efilter)
	c:RegisterEffect(e4)
	--cannot select battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(c40008600.atlimit)
	c:RegisterEffect(e2)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008600,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c40008600.cost)
	e1:SetTarget(c40008600.target)
	e1:SetOperation(c40008600.operation)
	c:RegisterEffect(e1)  
end
function c40008600.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(4) and c:GetOverlayCount()>1
end
function c40008600.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008600)==0 end
	Duel.RegisterFlagEffect(tp,40008600,RESET_PHASE+PHASE_END,0,1)
end
function c40008600.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c40008600.efilter(e,re,rp)
	if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
function c40008600.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup()
end
function c40008600.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40008600.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c40008600.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c40008600.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008600.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40008600.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c40008600.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
