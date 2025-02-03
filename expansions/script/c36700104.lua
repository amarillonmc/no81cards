--skip-石堂柊
function c36700104.initial_effect(c)
	--act limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_TRIGGER)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(0,LOCATION_ONFIELD)
	e0:SetCondition(c36700104.accon)
	e0:SetTarget(c36700104.actg)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,36700104+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c36700104.hspcon)
	e1:SetOperation(c36700104.hspop)
	e1:SetValue(c36700104.hspval)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(36700104,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,36700104)
	e3:SetCondition(c36700104.thcon)
	e3:SetTarget(c36700104.thtg)
	e3:SetOperation(c36700104.thop)
	c:RegisterEffect(e3)
end
function c36700104.accon(e)
	local race=e:GetHandler():GetSpecialSummonInfo(SUMMON_INFO_RACE)
	return e:GetHandler():IsSummonType(SUMMON_VALUE_SELF) or race&RACE_WARRIOR~=0
end
function c36700104.acfilter(c,p)
	return c:IsSetCard(0xc22) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsControler(1-p)
end
function c36700104.actg(e,c)
	local g=c:GetColumnGroup()
	return c:IsFaceup() and g:IsExists(c36700104.acfilter,1,nil,c:GetControler())
end
function c36700104.cfilter(c)
	return c:IsSetCard(0xc22) and c:IsFaceup()
end
function c36700104.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c36700104.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		if seq==5 or seq==6 then
			zone=zone|(1<<aux.MZoneSequence(seq))
		else
			if seq>0 then zone=zone|(1<<(seq-1)) end
			if seq<4 then zone=zone|(1<<(seq+1)) end
		end
	end
	return zone
end
function c36700104.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c36700104.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c36700104.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(36700104,0))
end
function c36700104.hspval(e,c)
	local tp=c:GetControler()
	return SUMMON_VALUE_SELF,c36700104.getzone(tp)
end
function c36700104.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0xc22)
end
function c36700104.spfilter(c,e,tp)
	return c:IsSetCard(0xc22) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
		and (c:IsAbleToHand() or (Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c36700104.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x30) and chkc:IsControler(tp) and c36700104.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c36700104.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c36700104.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
end
function c36700104.thop(e,tp,eg,ep,ev,re,r,rp)
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
