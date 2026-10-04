--无畏骑兵
function c43990970.initial_effect(c)
	aux.AddCodeList(c,43990987)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43990970)
	e1:SetTarget(c43990970.target)
	e1:SetOperation(c43990970.activate)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c43990970.chainop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c43990970.reccon)
	e3:SetOperation(c43990970.recop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(43990970,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,43990970-1)
	e4:SetCondition(c43990970.thcon)
	e4:SetTarget(c43990970.thtg)
	e4:SetOperation(c43990970.thop)
	c:RegisterEffect(e4)
end
function c43990970.thfilter(c)
	return aux.IsCodeListed(c,43990987) and c:IsAbleToHand()
end
function c43990970.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990970.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c43990970.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c43990970.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c43990970.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():GetType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) then
		Duel.SetChainLimit(c43990970.chainlm)
	end
end
function c43990970.chainlm(e,rp,tp)
	return tp==rp
end
function c43990970.rcfilter(c,tp)
	return (c:GetOriginalType()&TYPE_TRAP)~=0 and c:IsSummonPlayer(tp)
end
function c43990970.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990970.rcfilter,1,nil,tp)
end
function c43990970.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,43990970)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
function c43990970.cfilter(c,tp)
	return c:IsCode(43990987) and c:IsControler(tp)
end
function c43990970.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c43990970.cfilter,1,nil,tp)
end
function c43990970.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetSZoneCount(tp)>0
	local b2=Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,43990970,0,TYPES_NORMAL_TRAP_MONSTER,2000,2400,4,RACE_FAIRY,ATTRIBUTE_LIGHT)
	if chk==0 then return b1 or b2 end
end
function c43990970.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or aux.NecroValleyNegateCheck(c) or not aux.NecroValleyFilter()(c) then return end
	local b1=Duel.GetSZoneCount(tp)>0
	local b2=Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,43990970,0,TYPES_NORMAL_TRAP_MONSTER,2000,2400,4,RACE_FAIRY,ATTRIBUTE_LIGHT)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(43990970,0)},
		{b2,1152})
	if not (b1 or b2) then return end
	if op==1 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
