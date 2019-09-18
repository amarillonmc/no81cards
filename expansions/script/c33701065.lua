--篝 ～收获祭的记忆～
function c33701065.initial_effect(c)
	 --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c33701065.lcheck)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701065,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_OATH)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c33701065.setcon)
	e1:SetTarget(c33701065.settg)
	e1:SetOperation(c33701065.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701065,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_OATH)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c33701065.pccon)
	e1:SetTarget(c33701065.pctg)
	e1:SetOperation(c33701065.pcop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c33701065.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c33701065.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(33701065,2))
end
function c33701065.lcheck(g,lc)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_EARTH)
end
function c33701065.setcfilter(c,tp,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsSetCard(0x441) and c:IsFaceup() and c:IsControler(tp) and ec:GetLinkedGroup():IsContains(c)
	else
		return c:IsPreviousSetCard(0x441) and c:IsPreviousPosition(POS_FACEUP)
			and c:GetPreviousControler()==tp and bit.extract(ec:GetLinkedZone(tp),c:GetPreviousSequence())~=0
	end
end
function c33701065.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33701065.setcfilter,1,nil,tp,e:GetHandler())
end
function c33701065.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsCanAddCounter(0x1021,4) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1021,4) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,0x1021,4)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x1021,4)
end
function c33701065.setop(e,tp,eg,ep,ev,re,r,rp)
   local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x1021,4)
	end
end
function c33701065.setcfilter2(c,tp,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsSetCard(0x6440) and c:IsFaceup() and c:IsControler(tp) and ec:GetLinkedGroup():IsContains(c)
	else
		return c:IsPreviousSetCard(0x6440) and c:IsPreviousPosition(POS_FACEUP)
			and c:GetPreviousControler()==tp and bit.extract(ec:GetLinkedZone(tp),c:GetPreviousSequence())~=0
	end
end
function c33701065.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33701065.setcfilter2,1,nil,tp,e:GetHandler())
end
function c33701065.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3440) and not c:IsForbidden()
end
function c33701065.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c33701065.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c33701065.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c33701065.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end