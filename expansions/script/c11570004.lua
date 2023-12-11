--翼冠结界·凝时宙域
function c11570004.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c11570004.destg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11570004,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,11570004)
	e3:SetTarget(c11570004.thtg)
	e3:SetOperation(c11570004.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c11570004.atkcon)
	e4:SetTarget(c11570004.atktg)
	e4:SetValue(c11570004.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
end
function c11570004.rfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x810) and c:IsAbleToRemove()
end
function c11570004.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=eg:GetFirst()
	if chk==0 then return eg:GetCount()==1 and dc~=e:GetHandler() and dc:IsFaceup() and dc:IsLocation(LOCATION_MZONE)
		and dc:IsSetCard(0x3810) and not dc:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c11570004.rfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,dc) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c11570004.rfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,dc)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function c11570004.filter(c)
	return c:IsSetCard(0x810) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c11570004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11570004.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c11570004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c11570004.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c11570004.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3810)
end
function c11570004.atkcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c11570004.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11570004.atktg(e,c)
	return c:IsSetCard(0x810)
end
function c11570004.atkval(e,c)
	return c:GetLevel()*100
end