--昭和骑士·强人
function c9980673.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980673,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9980673)
	e1:SetCondition(c9980673.spcon)
	e1:SetTarget(c9980673.sptg)
	e1:SetOperation(c9980673.spop)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980673,2))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c9980673.thtg)
	e1:SetOperation(c9980673.thop)
	c:RegisterEffect(e1)
	--xyzlv
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL+EFFECT_SYNCHRO_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9980673.xyzlv)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980673.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980673.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980673,2))
end
function c9980673.xyzlv(e,c,rc)
	return 0x40000+e:GetHandler():GetLevel()
end
function c9980673.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ+REASON_SYNCHRO
end
function c9980673.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x6bc1) and not c:IsCode(9980673)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
		and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function c9980673.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9980673.cfilter,1,nil,tp)
end
function c9980673.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9980673.tdfilter(c)
	return c:IsAbleToDeck()
end
function c9980673.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9980673.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
		and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9980673,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	end
end
function c9980673.thfilter(c)
	return c:IsSetCard(0x6bc1) and c:IsAbleToHand()
end
function c9980673.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9980673.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980673.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9980673.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9980673.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980673,2))
	end
end