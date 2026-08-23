--超级运动员夹击战术
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb2) and c:IsAbleToHand()
end
function s.thfilter1(c,e)
	return s.thfilter(c) and c:IsCanBeEffectTarget(e)
end
function s.desfilter2(c)
	return true
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	local ct1=Duel.GetMatchingGroupCount(s.thfilter1,tp,LOCATION_MZONE,0,nil,e)
	local ct2=Duel.GetMatchingGroupCount(s.desfilter2,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return ct1>0 and ct2>0 end
	local ct=math.min(ct1,3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_MZONE,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,#g,0,LOCATION_ONFIELD)
	local ch=Duel.GetCurrentChain()
	if ch>1 and Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER)==1-tp then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xb2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		if ct>0 and Duel.IsExistingMatchingCard(s.desfilter2,tp,0,LOCATION_ONFIELD,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local hg=Duel.SelectMatchingCard(tp,s.desfilter2,tp,0,LOCATION_ONFIELD,1,ct,nil)
			local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
			Duel.HintSelection(hg)
			if Duel.Destroy(hg,REASON_EFFECT)~=0 and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sct=ct
				if sct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then sct=1 end
				local ssg=sg:Select(tp,1,ct,nil)
				Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
