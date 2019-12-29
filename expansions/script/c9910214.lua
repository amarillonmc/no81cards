--天空漫步者-空返踢
function c9910214.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9910214.condition)
	e1:SetTarget(c9910214.target)
	e1:SetOperation(c9910214.activate)
	c:RegisterEffect(e1)
end
function c9910214.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsRace(RACE_PSYCHO))
end
function c9910214.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910214.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910214.spfilter(c,e,tp)
	return c:IsSetCard(0x955) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910214.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910214.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c9910214.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	if Duel.GetCurrentChain()>2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	end
end
function c9910214.filter(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp)
end
function c9910214.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g1=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	if g1:GetCount()==0 then return end
	if Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g2=g:Filter(c9910214.filter,nil,tp)
		if g2:GetCount()==0 then return end
		local tc=g2:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-1500)
		tc:RegisterEffect(e1)
		if Duel.GetCurrentChain()>2 and Duel.SelectYesNo(tp,aux.Stringid(9910214,0)) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
