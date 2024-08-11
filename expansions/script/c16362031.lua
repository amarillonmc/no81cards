--英雄刻印 堕世之翼
function c16362031.initial_effect(c)
	c:SetUniqueOnField(1,0,16362031)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c16362031.target)
	e1:SetOperation(c16362031.activate)
	c:RegisterEffect(e1)
	--Equip Limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c16362031.eqlimit)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,16362031)
	e3:SetCondition(c16362031.thcon)
	e3:SetTarget(c16362031.thtg)
	e3:SetOperation(c16362031.thop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,16362031)
	e4:SetTarget(c16362031.sptg)
	e4:SetOperation(c16362031.spop)
	c:RegisterEffect(e4)
end
function c16362031.filter(c)
	return c:IsSetCard(0xdc0) and c:IsFaceup()
end
function c16362031.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c16362031.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16362031.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,c16362031.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c16362031.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c16362031.eqlimit(e,c)
	return c:IsSetCard(0xdc0)
end
function c16362031.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xdc0) and c:IsSummonPlayer(tp)
end
function c16362031.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16362031.cfilter,1,nil,tp)
end
function c16362031.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c16362031.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SendtoHand(c,nil,REASON_EFFECT) end
end
function c16362031.spfilter(c,e,tp,ec)
	local lv=ec:GetLevel()
	local attr=ec:GetAttribute()
	local code=ec:GetCode()
	return c:IsSetCard(0xdc0) and c:IsLevel(lv) and c:IsAttribute(attr) and not c:IsCode(code)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,ec,c)
end
function c16362031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	local loc=LOCATION_DECK
	if ec:IsType(TYPE_SYNCHRO) then loc=LOCATION_EXTRA end
	if chk==0 then return Duel.IsExistingMatchingCard(c16362031.spfilter,tp,loc,0,1,nil,e,tp,ec) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c16362031.spop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local loc=LOCATION_DECK
	if ec:IsType(TYPE_SYNCHRO) then loc=LOCATION_EXTRA end
	if Duel.SendtoDeck(ec,nil,0,REASON_EFFECT)~=0 and ec:IsLocation(loc) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c16362031.spfilter,tp,loc,0,1,1,nil,e,tp,ec):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)
		end
	end
end