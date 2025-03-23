--小喙
function c61701014.initial_effect(c)
	aux.AddCodeList(c,61701001)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetCost(c61701014.cost)
	e1:SetTarget(c61701014.target)
	e1:SetOperation(c61701014.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1190)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,61701014)
	e2:SetCondition(c61701014.thcon)
	e2:SetTarget(c61701014.thtg)
	e2:SetOperation(c61701014.thop)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetCondition(c61701014.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--double battle damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL)
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetCondition(c61701014.indcon)
	e4:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e4)
end
function c61701014.rmfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLinkAbove(1) and c:IsAbleToRemove()
end
function c61701014.tfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(c61701014.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local og=Duel.GetOverlayGroup(tp,1,0):Filter(c61701014.rmfilter,nil)
	g:Merge(og)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(c61701014.xfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank(),g)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c61701014.xfilter(c,e,tp,mc,rk,g)
	if not (c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and mc:IsCanBeXyzMaterial(c)) then return end
	local ct=c:GetRank()-rk
	return ct>0 and g:IsExists(Card.IsLink,1,nil,ct) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c61701014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c61701014.tfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c61701014.tfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c61701014.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c61701014.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c61701014.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local og=Duel.GetOverlayGroup(tp,1,0):Filter(c61701014.rmfilter,nil)
	g:Merge(og)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c61701014.xfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank(),g):GetFirst()
	if sc then
		local ct=sc:GetRank()-tc:GetRank()
		local rg=g:FilterSelect(tp,Card.IsLink,1,1,nil,ct)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c61701014.chkfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c61701014.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c61701014.chkfilter,1,nil,tp)
end
function c61701014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c61701014.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c61701014.indcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsCode(61701001) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
