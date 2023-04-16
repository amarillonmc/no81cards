--幻变骚灵·切换莱西
function c98920090.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c98920090.matfilter,1,1)
	c:EnableReviveLimit()
--link ss
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920090,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,98920090)
	e1:SetCondition(c98920090.thcon)
	e1:SetTarget(c98920090.sptg1)
	e1:SetOperation(c98920090.spop1)
	c:RegisterEffect(e1)
--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920090.,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98930090)
	e2:SetCondition(c98920090.damcon)
	e2:SetTarget(c98920090.damtg)
	e2:SetOperation(c98920090.damop)
	c:RegisterEffect(e2)
end
function c98920090.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98920090.matfilter(c)
	return c:IsLinkSetCard(0x103) and not c:IsLinkType(TYPE_LINK)
end
function c98920090.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x103) and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c98920090.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetCode()) and not c:IsType(TYPE_LINK)
end
function c98920090.spfilter1(c,e,tp,code)
	return c:IsSetCard(0x103) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920090.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920090.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98920090.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98920090.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c98920090.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c98920090.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode()):GetFirst()
		if sc then Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) end
	end
end
function c98920090.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c98920090.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(700)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,700)
end
function c98920090.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end