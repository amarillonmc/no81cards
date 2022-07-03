--时间潜行者啮合
function c33201000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33201000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33201000)
	e1:SetTarget(c33201000.target)
	e1:SetOperation(c33201000.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33201000,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33211000)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c33201000.mattg)
	e2:SetOperation(c33201000.matop)
	c:RegisterEffect(e2)
end

--e1
function c33201000.filter1(c,e,tp)  
	return c:IsFaceup() and c:IsSetCard(0x126) and not c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c33201000.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c33201000.filter2(c,e,tp,mc)
	return c:IsRank(4) and c:IsSetCard(0x126) and mc:IsCanBeXyzMaterial(c) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c33201000.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c33201000.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33201000.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33201000.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33201000.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33201000.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(sc,Group.FromCards(c))
		end
	end
end

--e2
function c33201000.thfilter(c)  
	return c:IsSetCard(0x126) and c:IsAbleToHand()
end
function c33201000.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetOverlayGroup(tp,LOCATION_MZONE,0):Filter(c33201000.thfilter,nil)
	local g2=Duel.GetMatchingGroup(c33201000.thfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	g:Merge(g2)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c33201000.matop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOverlayGroup(tp,LOCATION_MZONE,0):Filter(c33201000.thfilter,nil)
	local g2=Duel.GetMatchingGroup(c33201000.thfilter,tp,LOCATION_GRAVE,0,nil)
	g:Merge(g2)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
	end
end
