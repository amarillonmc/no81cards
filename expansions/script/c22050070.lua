--悲叹之律－变奏曲
function c22050070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22050070,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_SUMMON+TIMING_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22050070+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22050070.target)
	e1:SetOperation(c22050070.activate)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22050070,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(c22050070.operation)
	c:RegisterEffect(e2)
end
function c22050070.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22050070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22050070.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsSetCard(0xff8) and tc:IsAttribute(ATTRIBUTE_EARTH) then
		if Duel.IsExistingMatchingCard(c22050070.filter,tp,0,LOCATION_ONFIELD,1,c)
		and Duel.SelectYesNo(tp,aux.Stringid(22050070,1)) then
			local sg=Duel.GetMatchingGroup(c22050070.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function c22050070.filter1(c)
	return c:IsFaceup() and c:IsCanAddCounter(0xfec,1)
end
function c22050070.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22050070.filter1,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do 
		tc:AddCounter(0xfec,1)
		tc=g:GetNext()
	end
end
