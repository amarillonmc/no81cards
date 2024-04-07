--真神 神力释放
local m=91020008
local cm=c91020008
function c91020008.initial_effect(c)
	aux.AddCodeList(c,10000000)
	aux.AddCodeList(c,10000010)
	aux.AddCodeList(c,10000020)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cm.val)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.tg4)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function cm.fit1(c)
	return c:IsCode(91020010) or c:IsCode(91020011) or c:IsCode(91020014) and c:IsReleasable()
end
function cm.fit0(c,eg)
	return (c:IsCode(10000010) and eg:IsExists(aux.FilterBoolFunction(Card.IsCode,91020014),1,nil)) or (c:IsCode(10000000) and eg:IsExists(aux.FilterBoolFunction(Card.IsCode,91020011),1,nil)) or (c:IsCode(10000020) and eg:IsExists(aux.FilterBoolFunction(Card.IsCode,91020010),1,nil)) 
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and (c:IsCode(91020011) and Duel.IsExistingMatchingCard(aux.FilterBoolFunction(Card.IsCode,10000000),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil)) or (c:IsCode(91020014) and Duel.IsExistingMatchingCard(aux.FilterBoolFunction(Card.IsCode,10000010),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil)) or (c:IsCode(91020010) and Duel.IsExistingMatchingCard(aux.FilterBoolFunction(Card.IsCode,10000020),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil)) 
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.fit(c,e,tp)
	return c:IsCode(10000000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.fit11(c,e,tp)
	return c:IsCode(10000010) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.fit21(c,e,tp)
	return c:IsCode(10000020) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(cm.fit0,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,nil,eg)
	local ft=dg:GetCount()
	local b=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local a=math.min(ft,b) 
	local ng=dg:SelectSubGroup(tp,aux.dncheck,flase,1,a,nil)
	local tc2=ng:GetFirst()
	while tc2 do 
	Duel.SpecialSummonStep(tc2,0,tp,tp,true,false,POS_FACEUP) 
	if  tc2:IsCode(10000010) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(4000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		tc2:RegisterEffect(e2)
	end
	tc2=ng:GetNext()
	end
  Duel.SpecialSummonComplete()  
end
--e2
function cm.tg4(e,c)
return c:IsAttribute(ATTRIBUTE_DIVINE)
end
function cm.val(e,te)
return  te:IsActiveType(TYPE_MONSTER) and (te:GetHandler():IsLevelBelow(10) or te:GetHandler():IsRankBelow(10)) and te:GetOwner()~=e:GetOwner() 
end