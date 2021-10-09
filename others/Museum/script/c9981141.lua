--骑士时刻·时王-W装甲
function c9981141.initial_effect(c)
	 c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981141,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,99811411)
	e1:SetTarget(c9981141.thtg)
	e1:SetOperation(c9981141.thop)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9981141.spcon)
	c:RegisterEffect(e1)
	--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981141,0))
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9981141)
	e3:SetCondition(c9981141.descon)
	e3:SetTarget(c9981141.destg)
	e3:SetOperation(c9981141.desop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9981141,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,99811410)
	e4:SetCondition(c9981141.thcon2)
	e4:SetTarget(c9981141.thtg2)
	e4:SetOperation(c9981141.thop2)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981141.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981141.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981141,2))
end
function c9981141.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bc3) and c:IsType(TYPE_PENDULUM) and not c:IsCode(9981141) and c:IsAbleToHand()
end
function c9981141.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981141.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c9981141.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9981141.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981141,3))
	end
end
function c9981141.spfilter1(c)
	return c:IsFaceup() and c:IsCode(9981141)
end
function c9981141.spfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6bc3) and c:IsLevelAbove(7)
end
function c9981141.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or Duel.IsExistingMatchingCard(c9981141.spfilter1,tp,LOCATION_MZONE,0,1,nil) then return false end
	return Duel.IsExistingMatchingCard(c9981141.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9981141.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousSetCard(0x6bc3)
end
function c9981141.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9981141.cfilter,1,nil,tp)
end
function c9981141.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c9981141.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function c9981141.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c9981141.thfilter2(c)
	return c:IsSetCard(0x6bc3) and not c:IsCode(9981141) and c:IsAbleToHand()
end
function c9981141.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981141.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9981141.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9981141.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
