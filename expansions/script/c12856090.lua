--塔尔塔罗斯 女神试炼
function c12856090.initial_effect(c)
	c:EnableCounterPermit(0xa7d)
	c:SetCounterLimit(0xa7d,4)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c12856090.sptg)
	e1:SetOperation(c12856090.spop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c12856090.acop)
	c:RegisterEffect(e3)
end
function c12856090.rarity(c)
	if c.SetRarity_SR then
		return 1
	elseif c.SetRarity_SSR then
		return 2
	elseif c.SetRarity_UR then
		return 3
	elseif c.SetRarity_UTR then
		return 4
	else
		return 0
	end
end
function c12856090.cfilter(c,e,tp)
	return c:IsSetCard(0x3a7d) and c:IsType(TYPE_RITUAL) and c:IsFaceup() and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c12856090.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c12856090.rarity(c))
end
function c12856090.spfilter(c,e,tp,rare)
	return c12856090.rarity(c)~=rare and c:IsSetCard(0x3a7d) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c12856090.rarity(c)>0
end
function c12856090.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12856090.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c12856090.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c12856090.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_MZONE)
end
function c12856090.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c12856090.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,c12856090.rarity(tc))
		if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)~=0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c12856090.acop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0xa7d,1)
	end
end
