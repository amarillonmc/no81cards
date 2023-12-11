--枪管炮台
function c11634011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11634011+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c11634011.activate)
	c:RegisterEffect(e1)
	 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetDescription(aux.Stringid(11634011,1))
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c11634011.target1)
	e2:SetOperation(c11634011.operation1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c11634011.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c11634011.filter(c)
	return c:IsRace(RACE_DRAGON)
end
function c11634011.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11634011.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetMatchingGroup(c11634011.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11634011,0)) then
		if Duel.Destroy(g:Select(tp,1,1,nil),REASON_EFFECT)==0 then return end
		local sg=Duel.GetMatchingGroup(c11634011.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
		if #sg==0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
function c11634011.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetChainLimit(c11634011.chlimit)
end
function c11634011.chlimit(e,ep,tp)
	return tp==ep
end
function c11634011.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-500)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function c11634011.eftg(e,c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_DRAGON)
end