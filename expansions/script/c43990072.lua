--为人勿哭
local m=43990072
local cm=_G["c"..m]
function cm.initial_effect(c)
	--SpecialSummon1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCost(c43990072.sp1cost)
	e1:SetTarget(c43990072.sp1tg)
	e1:SetOperation(c43990072.sp1op)
	c:RegisterEffect(e1)
	--sp2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43990072)
	e2:SetCondition(c43990072.spcon)
	e2:SetTarget(c43990072.sptg)
	e2:SetOperation(c43990072.spop)
	c:RegisterEffect(e2)
	
end
function c43990072.sp1filter(c)
	return c:IsRace(RACE_ILLUSION) and c:IsAbleToGraveAsCost()
end
function c43990072.sp1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c43990072.sp1filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c43990072.sp1filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c43990072.sp1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,ct)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function c43990072.sp1filter2(c,e,tp)
	return c:IsSetCard(0x5510) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43990072.sp1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanDiscardDeck(tp,5) then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(c43990072.sp1filter2,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(43990072,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:FilterSelect(tp,c43990072.sp1filter2,1,1,nil,e,tp)
				if sg:GetCount()>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
				g:Sub(sg)
			end
	if Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)~=0 and e:GetActivateLocation()==LOCATION_HAND and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(43990072,1)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
		end
	end
end
function c43990072.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousPosition(POS_FACEUP)
end
function c43990072.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990072.cfilter,1,nil,tp) and rp==1-tp
end
function c43990072.sppfilter(c,e,tp)
	return c:IsSetCard(0x5510) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c43990072.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c43990072.sppfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c43990072.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c43990072.sppfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

