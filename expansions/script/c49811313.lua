--异虫防护罩
function c49811313.initial_effect(c)
	c:SetUniqueOnField(1,0,49811313)
	--activate
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e0) 
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3e))
	e1:SetValue(aux.tgoval) 
	e1:SetCondition(c49811313.idcon)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c49811313.reptg)
	e2:SetValue(c49811313.repval)
	e2:SetOperation(c49811313.repop)
	c:RegisterEffect(e2) 
end
function c49811313.idcon(e) 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsSetCard(0x3e) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	return g:GetCount()>0 and g:GetClassCount(Card.GetCode)==g:GetCount()  
end 
function c49811313.repfilter(c,tp)
	return c:IsFaceup() and c:IsOnField() and c:IsControler(tp) and c:IsSetCard(0x3e) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE) 
end
function c49811313.desfilter(c,e)
	return c:IsSetCard(0x3e) and c:IsType(TYPE_MONSTER) and c:IsDestructable(e)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c49811313.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(c49811313.repfilter,nil,tp)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c49811313.desfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e) end 
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then 
		return true
	else return false end
end
function c49811313.repval(e,c)
	return c49811313.repfilter(c,e:GetHandlerPlayer())
end
function c49811313.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,49811313) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
	local tg=Duel.SelectMatchingCard(tp,c49811313.desfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e)  
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end




