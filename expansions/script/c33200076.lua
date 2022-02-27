--铁战灵兽 M大钢蛇
function c33200076.initial_effect(c)
	aux.AddCodeList(c,33200068) 
	--spesm
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x322),8,99,c33200076.ovfilter,aux.Stringid(33200076,1),99,c33200076.xyzop)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c33200076.txtcon)
	e0:SetOperation(c33200076.txtop)
	c:RegisterEffect(e0)
	--target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200076,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1)
	e1:SetCost(c33200076.cost)
	e1:SetOperation(c33200076.tgop)
	c:RegisterEffect(e1)
	--defense attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

--xyz
function c33200076.ovfilter(c)
	return c:IsFaceup() and c:IsCode(33200068)
end
function c33200076.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x323)
end
function c33200076.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,33200052)==0 
	and Duel.IsExistingMatchingCard(c33200076.xyzfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.RegisterFlagEffect(tp,33200052,nil,EFFECT_FLAG_OATH,1)
end
function c33200076.txtfilter(c)
	return c:IsFaceup() and c:IsCode(33200075)
end
function c33200076.txtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ) and Duel.IsExistingMatchingCard(c33200076.txtfilter,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c33200076.txtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(33200076,3))
	Duel.Hint(24,0,aux.Stringid(33200076,4))
end

--e1
function c33200076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsAbleToDeckAsCost,nil)
	if chk==0 then return g:GetCount()>0 end
	local tc=g:Select(tp,1,1,nil)
	Duel.SendtoDeck(tc,nil,2,REASON_COST)
end
function c33200076.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x322))
	e0:SetValue(c33200076.efilter)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e0) 
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33200076,0))
end
function c33200076.efilter(e,re)
	return not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end