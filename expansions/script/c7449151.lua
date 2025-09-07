--害虫杀手
function c7449151.initial_effect(c)
	--aux.AddCodeList(c,7449105)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e0:SetRange(LOCATION_HAND)
	e0:SetTargetRange(POS_FACEUP,1)
	e0:SetCondition(c7449151.sprcon)
	e0:SetOperation(c7449151.sprop)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7449151,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c7449151.atktg)
	e1:SetOperation(c7449151.atkop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7449151,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c7449151.thcon)
	e2:SetTarget(c7449151.thtg)
	e2:SetOperation(c7449151.thop)
	c:RegisterEffect(e2)
end
function c7449151.spfilter(c,e,tp)
	return c:IsCode(7449105) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c7449151.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c7449151.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(0)>0 and Duel.GetMZoneCount(1)>0
end
function c7449151.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c7449151.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c7449151.tfilter(c,g)
	return c:IsRace(RACE_INSECT) and c:IsFaceup()-- and g:IsContains(c)
end
function c7449151.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--local g=e:GetHandler():GetAttackableTarget()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c7449151.tfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c7449151.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) and e:GetHandler():IsAttackPos() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c7449151.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c7449151.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) or c:IsDefensePos() then return end
	Duel.CalculateDamage(c,tc,true)
end
function c7449151.cfilter(c)
	return bit.band(c:GetPreviousRaceOnField(),RACE_INSECT)~=0
end
function c7449151.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7449151.cfilter,1,nil)
end
function c7449151.thfilter(c,chk)
	return c:IsCode(7449157,7449155,7449153) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c7449151.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c7449151.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c7449151.thfilter,tp,LOCATION_DECK,0,1,nil,1) and Duel.SelectYesNo(tp,aux.Stringid(7449151,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c7449151.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	if Duel.IsExistingMatchingCard(c7449151.thfilter,1-tp,LOCATION_DECK,0,1,nil,1) and Duel.SelectYesNo(1-tp,aux.Stringid(7449151,2)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(1-tp,c7449151.thfilter,1-tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,tc)
		end
	end
end
