--远古造物 毁灭刃齿虎
dofile("expansions/script/c9910700.lua")
function c9910735.initial_effect(c)
	--special summon
	QutryYgzw.AddSpProcedure(c,3)
	c:EnableReviveLimit()
	--flag
	QutryYgzw.AddTgFlag(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910735,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,9910735)
	e1:SetCondition(c9910735.descon)
	e1:SetTarget(c9910735.destg)
	e1:SetOperation(c9910735.desop)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c9910735.chainop)
	c:RegisterEffect(e2)
end
function c9910735.cfilter1(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c9910735.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910735.cfilter1,1,nil,1-tp)
end
function c9910735.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c9910735.cfilter1,nil,1-tp)
	g:AddCard(e:GetHandler())
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c9910735.cfilter2(c)
	return c:IsSetCard(0xc950) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910735.spfilter(c,e,tp)
	return c:IsSetCard(0xc950) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9910735.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=eg:Filter(c9910735.cfilter1,nil,1-tp)
	g:AddCard(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g)
	if #sg==0 then return end
	sg:AddCard(c)
	Duel.HintSelection(sg)
	if Duel.Destroy(sg,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	if #og>0 and og:IsExists(c9910735.cfilter2,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910735.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(9910735,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c9910735.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #tg>0 then
			Duel.SpecialSummon(tg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function c9910735.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c9910735.chainlm)
end
function c9910735.chainlm(e,rp,tp)
	return tp==rp
end
