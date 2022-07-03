--再拾的永夏 鹰原羽依里
function c9910967.initial_effect(c)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(c9910967.flag)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9910967.thtg)
	e1:SetOperation(c9910967.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910967)
	e2:SetTarget(c9910967.sptg)
	e2:SetOperation(c9910967.spop)
	c:RegisterEffect(e2)
end
function c9910967.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function c9910967.thfilter(c)
	return c:IsSetCard(0x5954) and c:IsAbleToHand()
end
function c9910967.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910967.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910967.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9910967.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9910967.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
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
	local g=Duel.GetMatchingGroup(c9910967.rmfilter,tp,LOCATION_DECK,0,nil,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910967.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910967.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910967.rmfilter,tp,LOCATION_DECK,0,nil,tp)
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
