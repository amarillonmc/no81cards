--BB 苍之书
function c32500520.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32500520,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,32500520)
	e1:SetCost(c32500520.spcost)
	e1:SetTarget(c32500520.sptg)
	e1:SetOperation(c32500520.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,32500521)
	e2:SetCost(c32500520.thcost)
	e2:SetTarget(c32500520.thtg)
	e2:SetOperation(c32500520.thop)
	c:RegisterEffect(e2)
end
function c32500520.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c32500520.cfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c32500520.fselect(g,tg)
	return tg:IsExists(Card.IsLink,1,nil,#g)
end
function c32500520.spfilter(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xae1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c32500520.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c32500520.cfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(c32500520.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local _,maxlink=tg:GetMaxGroup(Card.GetLink)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		if #tg==0 then return false end
		return cg:CheckSubGroup(c32500520.fselect,1,maxlink,tg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=cg:SelectSubGroup(tp,c32500520.fselect,false,1,maxlink,tg)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(rg:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c32500520.spfilter1(c,e,tp,lk)
	return c32500520.spfilter(c,e,tp) and c:IsLink(lk)
end
function c32500520.spop(e,tp,eg,ep,ev,re,r,rp)
	local lk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32500520.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lk)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c32500520.thcfilter(c)
	return c:IsAbleToDeckAsCost()
end
function c32500520.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c32500520.spfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingMatchingCard(c32500520.thcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c32500520.thcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,e:GetHandler())
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c32500520.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c32500520.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
