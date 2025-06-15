--风暴星幽使
function c9910294.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c9910294.lcheck)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c9910294.datg)
	c:RegisterEffect(e1)
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910294)
	e2:SetTarget(c9910294.tetg)
	e2:SetOperation(c9910294.teop)
	c:RegisterEffect(e2)
end
function c9910294.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function c9910294.datg(e,c)
	return e:GetHandler()==c or (c:IsType(TYPE_PENDULUM) and e:GetHandler():GetLinkedGroup():IsContains(c))
end
function c9910294.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanRemove(tp) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c9910294.spfilter(c,e,tp,tg)
	local b1=c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	local ct=#tg
	if tg:IsContains(c) then ct=ct-1 end
	return c:IsSetCard(0x3957) and (c:IsLevelBelow(ct) or c:IsLinkBelow(ct))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (b1 or b2)
end
function c9910294.gselect(g,e,tp)
	return Duel.IsExistingMatchingCard(c9910294.spfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,g,e,tp,#g)
end
function c9910294.spfilter2(c,e,tp,ct)
	local b1=c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	return c:IsSetCard(0x3957) and (c:IsLevel(ct) or c:IsLink(ct))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (b1 or b2)
end
function c9910294.teop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		local check=false
		local tg=g:Filter(Card.IsType,nil,TYPE_PENDULUM)
		if #tg>0 and Duel.IsExistingMatchingCard(c9910294.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,tg)
			and Duel.SelectYesNo(tp,aux.Stringid(9910294,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910294,1))
			local sg=tg:SelectSubGroup(tp,c9910294.gselect,false,1,#tg,e,tp)
			Duel.DisableShuffleCheck()
			local ct=Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
			g:Sub(sg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,c9910294.spfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,ct):GetFirst()
			if tc then
				if tc:IsLocation(LOCATION_DECK) then
					check=true
					Duel.DisableShuffleCheck()
				end
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				g:RemoveCard(tc)
			end
		end
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REVEAL)
		if check then Duel.ShuffleDeck(tp) end
	end
end
