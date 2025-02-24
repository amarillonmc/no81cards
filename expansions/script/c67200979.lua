--众星修正者 焚轮
function c67200979.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200979,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200979)
	e1:SetCondition(c67200979.tgcon)
	e1:SetTarget(c67200979.target)
	e1:SetOperation(c67200979.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200979,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,67200980)
	e2:SetCondition(c67200979.spcon)
	e2:SetTarget(c67200979.lktg)
	e2:SetOperation(c67200979.lkop)
	c:RegisterEffect(e2)	 
end
function c67200979.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) 
end
function c67200979.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa67a)
end
function c67200979.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200979.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,2,tp,LOCATION_DECK)
end
function c67200979.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200979,2))
	local g=Duel.SelectMatchingCard(tp,c67200979.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		g:AddCard(e:GetHandler())
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end
--
function c67200979.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa67a) and c:IsSummonPlayer(tp)
end
function c67200979.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c67200979.cfilter,1,c,tp) and not eg:IsContains(c)
end
function c67200979.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x67a)
end
function c67200979.lkfilter(c,mg)
	return c:IsLinkSummonable(mg)
end
function c67200979.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c67200979.matfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c67200979.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg) and e:GetHandler():IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c67200979.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
			local mg=Duel.GetMatchingGroup(c67200979.matfilter,tp,LOCATION_MZONE,0,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=Duel.SelectMatchingCard(tp,c67200979.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
			local tc=tg:GetFirst()
			if tc then
				Duel.BreakEffect()
				Duel.LinkSummon(tp,tc,mg)
			end
		end
	end
end