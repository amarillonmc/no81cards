--深海电脑乐土·BB护士限定
function c9950491.initial_effect(c)
	  --Rank Up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950491,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9950491)
	e3:SetTarget(c9950491.target)
	e3:SetOperation(c9950491.operation)
	c:RegisterEffect(e3)
 --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950491,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9950491)
	e2:SetCost(c9950491.thcost)
	e2:SetTarget(c9950491.thtg)
	e2:SetOperation(c9950491.thop)
	c:RegisterEffect(e2)
	 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950491.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950491.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950491,0))
end
function c9950491.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xba5)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c9950491.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRank()+1,c)
end
function c9950491.spfilter(c,e,tp,rank,mc)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_XYZ) and c:IsRank(rank) and mc:IsCanBeXyzMaterial(c,tp)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9950491.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9950491.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9950491.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9950491.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950491.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsFaceup()
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9950491.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank()+1,tc)
		local sc=g:GetFirst()
		if sc then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9950491.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9950491.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xba5)
end
function c9950491.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9950491.thfilter(c)
	return c:IsSetCard(0x5ba8) and not c:IsCode(9950491) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9950491.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950491.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950491.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950491.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end