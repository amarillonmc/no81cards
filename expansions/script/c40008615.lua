--究极之洞
function c40008615.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c40008615.activate)
	c:RegisterEffect(e1) 
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf18))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3) 
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40008615,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c40008615.tktg1)
	e4:SetOperation(c40008615.tkop1)
	c:RegisterEffect(e4) 
	local e5=e4:Clone() 
	e4:SetTarget(c40008615.tktg)
	e4:SetOperation(c40008615.tkop)
	e4:SetCountLimit(1,40008615)
end
function c40008615.atkfilter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsControler(tp) and c:IsCanBeEffectTarget(e) and c:IsSetCard(0xf18)
end
function c40008615.tktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c40008615.atkfilter1(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c40008615.atkfilter1,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,TYPE_MONSTER) end
	if eg:GetCount()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=eg:FilterSelect(tp,c40008615.atkfilter1,1,1,nil,e,tp)
		Duel.SetTargetCard(g)
	end
end
function c40008615.tkop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,TYPE_MONSTER)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function c40008615.atkfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsControler(tp) and c:IsCanBeEffectTarget(e) and not c:IsSetCard(0xf18)
end
function c40008615.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c40008615.atkfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c40008615.atkfilter,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,TYPE_MONSTER) end
	if eg:GetCount()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=eg:FilterSelect(tp,c40008615.atkfilter,1,1,nil,e,tp)
		Duel.SetTargetCard(g)
	end
end
function c40008615.tkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,TYPE_MONSTER)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function c40008615.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf18) and c:IsAbleToHand()
end
function c40008615.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c40008615.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40008615,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
