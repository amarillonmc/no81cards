--英雄刻印 轮回之镜
function c16362030.initial_effect(c)
	c:SetUniqueOnField(1,0,16362030)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c16362030.target)
	e1:SetOperation(c16362030.activate)
	c:RegisterEffect(e1)
	--Equip Limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c16362030.eqlimit)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,16362030)
	e3:SetCondition(c16362030.thcon)
	e3:SetTarget(c16362030.thtg)
	e3:SetOperation(c16362030.thop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,16362030)
	e4:SetTarget(c16362030.sptg)
	e4:SetOperation(c16362030.spop)
	c:RegisterEffect(e4)
end
function c16362030.filter(c)
	return c:IsSetCard(0xdc0) and c:IsFaceup()
end
function c16362030.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c16362030.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16362030.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,c16362030.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c16362030.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c16362030.eqlimit(e,c)
	return c:IsSetCard(0xdc0)
end
function c16362030.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xdc0) and c:IsSummonPlayer(tp)
end
function c16362030.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16362030.cfilter,1,nil,tp)
end
function c16362030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c16362030.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SendtoHand(c,nil,REASON_EFFECT) end
end
function c16362030.spfilter(c,e,tp,lv)
	return c:IsSetCard(0xdc0) and c:IsLevelAbove(0) and c:GetLevel()<lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16362030.desfilter(c,lv)
	return c:IsFaceup() and c:IsLevelAbove(0) and c:GetLevel()<lv
end
function c16362030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	local op1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16362030.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ec:GetLevel())
	local op2=Duel.IsExistingMatchingCard(c16362030.desfilter,tp,0,LOCATION_MZONE,1,nil,ec:GetLevel())
	if chk==0 then return op1 or op2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function c16362030.spop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local op1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16362030.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ec:GetLevel())
	local op2=Duel.IsExistingMatchingCard(c16362030.desfilter,tp,0,LOCATION_MZONE,1,nil,ec:GetLevel())
	if op1 and (not op2 or Duel.SelectYesNo(tp,aux.Stringid(16362030,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c16362030.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ec:GetLevel())
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c16362030.desfilter,tp,0,LOCATION_MZONE,1,1,nil,ec:GetLevel())
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end