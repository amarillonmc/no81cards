--梦比优斯环
function c9951082.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c9951082.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951082,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,99510820)
	e1:SetCondition(c9951082.thcon)
	e1:SetTarget(c9951082.thtg)
	e1:SetOperation(c9951082.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951082,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,9951082)
	e3:SetCost(c9951082.spcost)
	e3:SetTarget(c9951082.sptg)
	e3:SetOperation(c9951082.spop)
	c:RegisterEffect(e3)
end
function c9951082.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bd1)
end
function c9951082.atkval(e,c)
	return Duel.GetMatchingGroupCount(c9951082.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*100
end
function c9951082.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9bd1) and c:GetSummonPlayer()==tp
end
function c9951082.tgfilter(c,tp,g)
	return g:IsContains(c) and Duel.IsExistingMatchingCard(c9951082.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c9951082.thfilter(c,code)
	return c:IsSetCard(0x9bd1) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToHand()
end
function c9951082.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and eg:IsExists(c9951082.cfilter,1,nil,tp)
end
function c9951082.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c9951082.cfilter,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9951082.tgfilter(chkc,tp,g) end
	if chk==0 then return Duel.IsExistingTarget(c9951082.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,g) end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c9951082.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9951082.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local code=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9951082.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c9951082.spfilter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x9bd1) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c9951082.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c9951082.spfilter2(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0x9bd1) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9951082.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9951082.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9951082.spfilter1(chkc,e,tp) end
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingTarget(c9951082.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9951082.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9951082.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9951082.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
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
