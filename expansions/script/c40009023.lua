--机空队 青天四式
function c40009023.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c40009023.matfilter,1,1) 
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009023,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,40009023)
	e2:SetCondition(c40009023.thcon)
	e2:SetTarget(c40009023.eqtg)
	e2:SetOperation(c40009023.eqop)
	c:RegisterEffect(e2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009023,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40009024)
	e1:SetCost(c40009023.descost)
	e1:SetTarget(c40009023.rmtg)
	e1:SetOperation(c40009023.rmop)
	c:RegisterEffect(e1)
end
function c40009023.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c40009023.matfilter(c)
	return not c:IsLink(1) and c:GetBaseAttack()==0 and c:IsType(TYPE_EFFECT)
end
function c40009023.eqfilter(c,tp)
	return c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0xf22) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c40009023.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c40009023.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND)
end
function c40009023.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c40009023.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c40009023.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c40009023.eqlimit(e,c)
	return e:GetOwner()==c
end
function c40009023.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf22) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c40009023.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009023.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	if Duel.IsExistingMatchingCard(c40009023.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
		 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c40009023.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c40009023.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove() and c:IsFaceup()
end
function c40009023.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c40009023.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009023.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c40009023.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c40009023.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end