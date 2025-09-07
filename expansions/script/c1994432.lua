--阶级跃迁革命
function c1994432.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,1994432)
    e1:SetCost(c1994432.cost)
	e1:SetTarget(c1994432.target)
	e1:SetOperation(c1994432.activate)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1994432,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,19944320)
	e3:SetCondition(c1994432.setcon)
	e3:SetTarget(c1994432.settg)
	e3:SetOperation(c1994432.setop)
	c:RegisterEffect(e3)
end


function c1994432.filter(c)
	return ((c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0x95)) and c:IsDiscardable()
end
function c1994432.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1994432.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c1994432.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c1994432.checkop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	local ar=Duel.GetAttacker()
	if at and at:IsSetCard(ba) then
		Duel.RegisterFlagEffect(at:GetControler(),id,RESET_PHASE+PHASE_END,0,1)
	end
	if ar and ar:IsSetCard(ba) then
		Duel.RegisterFlagEffect(ar:GetControler(),id,RESET_PHASE+PHASE_END,0,1)
	end
end
function c1994432.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c1994432.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetCode())
end
function c1994432.filter2(c,e,tp,mc,code)
	return c:IsSetCard(0xba) and not c:IsCode(code) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c1994432.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1994432.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1994432.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c1994432.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1994432.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL)
		or tc:IsFacedown() or not tc:IsRelateToChain() or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1994432.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetCode())
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

function c1994432.setfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x13b)
end

function c1994432.setcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c1994432.setfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c1994432.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end

function c1994432.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c) 
    end
end