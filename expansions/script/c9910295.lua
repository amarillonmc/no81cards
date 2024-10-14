--星幽灿烂
function c9910295.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910295+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9910295.activate)
	c:RegisterEffect(e1)
	--to hand/spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,9910296)
	e2:SetCost(c9910295.thcost)
	e2:SetTarget(c9910295.thtg)
	e2:SetOperation(c9910295.thop)
	c:RegisterEffect(e2)
end
function c9910295.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x3957) and c:IsType(TYPE_PENDULUM)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910295.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910295.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910295,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910295.rfilter(c,e,tp)
	return c:IsSetCard(0x3957) and Duel.IsExistingMatchingCard(c9910295.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode(),c)
end
function c9910295.thfilter(c,e,tp,code,mc)
	if not (c:IsSetCard(0x3957) and c:IsType(TYPE_MONSTER)) or c:IsCode(code) then return false end
	return c:IsAbleToHand() or (Duel.GetMZoneCount(tp,mc)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c9910295.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9910295.rfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c9910295.rfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Release(g,REASON_COST)
end
function c9910295.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c9910295.chainlm)
end
function c9910295.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER) or e:GetHandler():IsType(TYPE_PENDULUM)
end
function c9910295.thop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9910295.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
