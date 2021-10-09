--伊莉雅-Caster形态
function c9951284.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xaba8),aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),true)
  --negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951284,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9951284.condition)
	e2:SetTarget(c9951284.target)
	e2:SetOperation(c9951284.operation)
	c:RegisterEffect(e2)
 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951284,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9951284)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c9951284.sptg)
	e2:SetOperation(c9951284.spop)
	c:RegisterEffect(e2)
--To hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951284,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(c9951284.thcon)
	e4:SetTarget(c9951284.thtg)
	e4:SetOperation(c9951284.thop)
	c:RegisterEffect(e4)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951284.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951284.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951284,0))
end
function c9951284.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c9951284.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9951284.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951284,0))
end
function c9951284.thfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xaba8) and c:IsAbleToGrave()
end
function c9951284.thfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xaba8) and c:IsAbleToGrave() and c:GetSequence()<5
end
function c9951284.spfilter(c,e,tp)
	return c:IsSetCard(0xaba8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951284.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		local b=false
		if ft>0 then
			b=Duel.IsExistingTarget(c9951284.thfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		else
			b=Duel.IsExistingTarget(c9951284.thfilter2,tp,LOCATION_MZONE,0,1,nil)
		end
		return b and Duel.IsExistingTarget(c9951284.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if ft>0 then
		g1=Duel.SelectTarget(tp,c9951284.thfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	else
		g1=Duel.SelectTarget(tp,c9951284.thfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c9951284.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	e:SetLabelObject(g1:GetFirst())
end
function c9951284.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	if tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)>0
		and tc1:IsLocation(LOCATION_GRAVE) and tc2:IsRelateToEffect(e)
		and aux.NecroValleyFilter()(tc2) then
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9951284.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c9951284.filter(c)
	return c:IsSetCard(0xaba8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9951284.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9951284.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951284.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9951284.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9951284.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951284,0))
end
