--再拾的永夏 鹰原羽依里
function c9910967.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910967)
	e1:SetTarget(c9910967.sptg)
	e1:SetOperation(c9910967.spop)
	c:RegisterEffect(e1)
end
function c9910967.rmfilter(c,tp)
	return c:IsSetCard(0x5954) and c:IsLevelAbove(0) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910967.gcheck(lv)
	return  function(sg)
				return aux.dncheck(sg) and sg:GetSum(Card.GetLevel)<=lv
			end
end
function c9910967.gselect(sg,lv)
	return sg:GetSum(Card.GetLevel)==lv
end
function c9910967.spfilter(c,e,tp,g)
	local clv=c:GetLevel()
	local b1=c:IsSetCard(0x5954) and clv>1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsPublic()
	if not b1 then return false end
	aux.GCheckAdditional=c9910967.gcheck(clv)
	local b2=g:CheckSubGroup(c9910967.gselect,1,#g,clv)
	aux.GCheckAdditional=nil
	return b2
end
function c9910967.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910967.rmfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910967.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910967.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910967.rmfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c9910967.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,g):GetFirst()
	if not tc then return end
	Duel.ConfirmCards(1-tp,tc)
	local clv=tc:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	aux.GCheckAdditional=c9910967.gcheck(clv)
	local sg=g:SelectSubGroup(tp,c9910967.gselect,false,1,#g,clv)
	aux.GCheckAdditional=nil
	Duel.ConfirmCards(1-tp,sg)
	if Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)~=0
		and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local lv=0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910967,0))
		if clv==2 then lv=Duel.AnnounceNumber(tp,1)
		elseif clv==3 then lv=Duel.AnnounceNumber(tp,1,2)
		else lv=Duel.AnnounceNumber(tp,1,2,3) end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-lv)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
