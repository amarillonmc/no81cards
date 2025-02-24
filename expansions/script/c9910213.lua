--天空漫步者-小憩
function c9910213.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910213,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910213+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910213.cost)
	e1:SetTarget(c9910213.target)
	e1:SetOperation(c9910213.activate)
	c:RegisterEffect(e1)
end
function c9910213.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c9910213.thfilter(c)
	return c:IsSetCard(0x6956) and c:IsAbleToHand() and not c:IsCode(9910213)
end
function c9910213.spfilter(c,e,tp)
	return c:IsSetCard(0x6956) and (c:IsLevelBelow(4) or c:IsLink(1)) and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c9910213.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc,exc,cpchk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9910213.spfilter(chkc,e,tp) end
	local b1=Duel.IsExistingMatchingCard(c9910213.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingTarget(c9910213.spfilter,tp,LOCATION_GRAVE,0,1,exc,e,tp)
	if chk==0 then
		if e:GetLabel()~=0 and not cpchk then
			e:SetLabel(0)
			return b1 or (b2 and Duel.CheckLPCost(tp,1000))
		else
			return b1 or b2
		end
	end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9910213,0),aux.Stringid(9910213,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9910213,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9910213,1))+1
	end
	if op==0 then
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetProperty(0)
		e:SetOperation(c9910213.activate)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		if e:GetLabel()~=0 and not cpchk then
			e:SetLabel(0)
			Duel.PayLPCost(tp,1000)
		end
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,c9910213.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		e:SetOperation(c9910213.activate2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,0,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,0,0,0)
	end
end
function c9910213.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,1000,REASON_EFFECT)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910213.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910213.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if aux.NecroValleyNegateCheck(tc) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
