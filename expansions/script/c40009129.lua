--苍岚霸龙 荣光灾漩
function c40009129.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),7,2,c40009129.ovfilter,aux.Stringid(40009129,0),2,c40009129.xyzop)
	c:EnableReviveLimit() 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009129,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c40009129.condition)
	e1:SetCost(c40009129.cost)
	e1:SetTarget(c40009129.target)
	e1:SetOperation(c40009129.operation)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c40009129.atkcon)
	e2:SetTarget(c40009129.sumlimit)
	c:RegisterEffect(e2)
end
function c40009129.cfilter(c)
	return c:IsSetCard(0x7f1d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c40009129.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6f1d)
end
function c40009129.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009129.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetFlagEffect(tp,28346136)==0 end
	Duel.DiscardHand(tp,c40009129.cfilter,1,1,REASON_COST,nil)
	Duel.RegisterFlagEffect(tp,28346136,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c40009129.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c40009129.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009129.filter(c)
	return c:IsFaceup() and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c40009129.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009129.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009129.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40009129.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c40009129.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c40009129.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x7f1d)
end
function c40009129.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetAttribute()~=ATTRIBUTE_WATER
end