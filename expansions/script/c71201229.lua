--闪烁初星 ～美味偶像便当～
function c71201229.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71201229,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,71201229)
	e2:SetTarget(c71201229.thtg)
	e2:SetOperation(c71201229.thop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c71201229.reccon)
	e3:SetOperation(c71201229.recop)
	c:RegisterEffect(e3)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(71201229,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,11201229)
	e5:SetTarget(c71201229.lktg)
	e5:SetOperation(c71201229.lkop)
	c:RegisterEffect(e5)
end
function c71201229.thfilter(c,tp)
	return c:IsSetCard(0x7121) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c71201229.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71201229.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71201229.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71201229.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71201229.cfilter(c)
	return c:IsSetCard(0x7121) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c71201229.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71201229.cfilter,1,nil)
end
function c71201229.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,71201229)
	Duel.Recover(tp,500,REASON_EFFECT)
end
function c71201229.lkfilter(c,mg)
	return c:IsLinkSummonable(mg,nil,1,mg:GetCount())
end
function c71201229.lkmfilter(c)
	return c:IsSetCard(0x7121) and c:IsFaceup() and c:IsCanBeLinkMaterial(nil)
end
function c71201229.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c71201229.lkmfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c71201229.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg) 
		and e:GetHandler():IsAbleToGrave() 
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
end
function c71201229.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c71201229.lkmfilter,tp,LOCATION_MZONE,0,nil)
	if not c:IsRelateToEffect(e) or Duel.SendtoGrave(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71201229.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
		Duel.SetSelectedCard(fg)
		local sg=mg:SelectSubGroup(tp,aux.LCheckGoal,false,1,tc:GetLink(),tp,tc,nil,nil)
		tc:SetMaterial(sg)
		Auxiliary.LExtraMaterialCount(sg,tc,tp)
		Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)>0 then
			tc:CompleteProcedure()
		end
		Duel.AdjustAll()
		local tg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		if tg:GetCount()>0 then
			Duel.BreakEffect()
			local sc=tg:Select(tp,1,1,nil)
			Duel.SendtoGrave(sc,REASON_EFFECT)
		end
	end
	
end