--王威·狂风领主
function c40009176.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c40009176.ffilter1,c40009176.ffilter2,true) 
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009176,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c40009176.negcon)
	e2:SetCost(c40009176.negcost)
	e2:SetTarget(c40009176.negtg)
	e2:SetOperation(c40009176.negop)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c40009176.valcheck)
	c:RegisterEffect(e3)
	--immune
	--add type & attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c40009176.atkcon)
	e1:SetOperation(c40009176.atkop)
	c:RegisterEffect(e1)
end
function c40009176.ffilter1(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)
end
function c40009176.ffilter2(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
end
function c40009176.negcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c40009176.costfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c40009176.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c40009176.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c40009176.negfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_NORMAL)
end
function c40009176.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c40009176.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009176.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c40009176.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c40009176.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc2=g:GetFirst()
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e2)
		if tc2 and tc1:IsType(TYPE_MONSTER) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetValue(tc1:GetBaseAttack())
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e3)
			tc2=g:GetNext()  
		end   
	end
end
function c40009176.valcheck(e,c)
	local g=c:GetMaterial()
	local code=0
	local tc=g:GetFirst()
	while tc do
		code=bit.bor(code,tc:GetOriginalCodeRule())
		tc=g:GetNext()
	end
	e:SetLabel(code)
end
function c40009176.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function c40009176.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(e:GetLabelObject():GetLabel(),40009154)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1050)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
	if bit.band(e:GetLabelObject():GetLabel(),40009246)~=0 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(1050)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e5)
	end
end
function c40009176.matcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,40009154) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1050)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
		--Immunity
	  --  local e3=Effect.CreateEffect(c)
	   -- e3:SetDescription(aux.Stringid(40009176,1))
	   -- e3:SetType(EFFECT_TYPE_SINGLE)
	  --  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	   -- e3:SetRange(LOCATION_MZONE)
	   -- e3:SetCode(EFFECT_IMMUNE_EFFECT)
	   -- e3:SetValue(c40009176.efilter1)
	   -- e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	   -- c:RegisterEffect(e3) 
	end
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,40009246) then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(1050)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e5)
	   -- local e6=Effect.CreateEffect(c)
	   -- e6:SetDescription(aux.Stringid(40009176,2))
		--e6:SetType(EFFECT_TYPE_SINGLE)
	   -- e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		--e6:SetRange(LOCATION_MZONE)
		--e6:SetCode(EFFECT_IMMUNE_EFFECT)
		--e6:SetValue(c40009176.efilter2)
		--e6:SetReset(RESET_EVENT+RESETS_STANDARD)
	   -- c:RegisterEffect(e6)
	end
end
function c40009176.efilter1(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) or (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) then return false
	end
	return te:GetOwner()~=e:GetHandler() and te:GetOwner()~=e:GetOwner()
end
function c40009176.efilter2(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:GetOwner()~=e:GetHandler() and te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)
end

