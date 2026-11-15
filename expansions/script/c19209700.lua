--乐士奏音 《自毁样品》
function c19209700.initial_effect(c)
	aux.AddCodeList(c,19209669)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19209700.target)
	e1:SetOperation(c19209700.activate)
	c:RegisterEffect(e1)
end
function c19209700.tffilter(c,tp,chk)
	return c:IsCode(19209681,19209696) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c19209700.cfilter(c)
	return (c:IsCode(19209696) and c:IsLocation(LOCATION_FZONE) or c:IsOriginalCodeRule(19209690) and c:IsLocation(LOCATION_MZONE)) and c:IsFaceup()
end
function c19209700.thfilter(c)
	return (c:IsSetCard(0xb53) and not c:IsCode(19209690) and c:IsType(TYPE_MONSTER) or aux.IsCodeListed(c,19209669) and c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToHand()
end
function c19209700.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c19209700.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp,0)
	local b2=Duel.IsExistingMatchingCard(c19209700.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c19209700.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(19209700,0)},
		{b2,aux.Stringid(19209700,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(0)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	end
end
function c19209700.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c19209700.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp,1):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c19209700.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if not tc then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
