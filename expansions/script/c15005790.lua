local m=15005790
local cm=_G["c"..m]
cm.name="反诘回响-『日出之前』"
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.rlfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
		and Duel.IsExistingMatchingCard(cm.thorspfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c,c:GetType())
end
function cm.thorspfilter(c,e,tp,hc,type)
	local b=c:IsAbleToHand()
	if bit.band(type,TYPE_FUSION)==TYPE_FUSION then
		b=(c:IsAbleToHand() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp,hc)>0))
	end
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3f43)
		and not c:IsOriginalCodeRule(hc:GetOriginalCodeRule())
		and b
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp,true,REASON_EFFECT):Filter(cm.rlfilter,nil,e,tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetReleaseGroup(tp,true,REASON_EFFECT):Filter(cm.rlfilter,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local hc=g:Select(tp,1,1,nil):GetFirst()
	local type=hc:GetType()
	if hc and Duel.Release(hc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local cg=Duel.SelectMatchingCard(tp,cm.thorspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,hc,type)
		if cg:GetCount()>0 then
			local tc=cg:GetFirst()
			local op=1
			if bit.band(type,TYPE_FUSION)==TYPE_FUSION then
				op=aux.SelectFromOptions(tp,
					{tc:IsAbleToHand(),aux.Stringid(m,0)},
					{(tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp,hc)>0),aux.Stringid(m,1)})
			end
			if op==1 then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			elseif op==2 then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end