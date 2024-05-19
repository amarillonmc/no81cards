--万界星尘·拉尼亚凯亚
function c9910646.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2,nil,nil,99)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910646,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910646.thcon)
	e1:SetTarget(c9910646.thtg)
	e1:SetOperation(c9910646.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c9910646.spcon)
	e2:SetTarget(c9910646.sptg)
	e2:SetOperation(c9910646.spop)
	c:RegisterEffect(e2)
end
function c9910646.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function c9910646.thfilter(c,mc)
	return c:IsSetCard(0xa952) and (c:IsAbleToHand() or (mc:IsType(TYPE_XYZ) and c:IsCanOverlay()))
end
function c9910646.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910646.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910646.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9910646.thfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		if c:IsType(TYPE_XYZ) and tc:IsCanOverlay() and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,aux.Stringid(9910646,1))==1) then
			Duel.Overlay(c,Group.FromCards(tc))
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	for sc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(c9910646.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		sc:RegisterEffect(e1)
	end
end
function c9910646.efilter(e,re)
	return e:GetHandler()~=re:GetOwner() and e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c9910646.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c9910646.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910646.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetPreviousOverlayCountOnField()
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910646.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9910646.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910646.spfilter),tp,LOCATION_GRAVE,0,1,e:GetLabel(),nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
