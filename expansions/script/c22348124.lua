--墓 园 的 大 碑 海ling
local m=22348124
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348124,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c22348124.spcost)
	e1:SetTarget(c22348124.sptg)
	e1:SetOperation(c22348124.spop)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c22348124.atktg)
	e2:SetValue(c22348124.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348124,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22348124)
	e3:SetCondition(c22348124.thcon)
	e3:SetTarget(c22348124.thtg)
	e3:SetOperation(c22348124.thop)
	c:RegisterEffect(e3)
	
end
function c22348124.costfilter(c)
	return c:IsCode(22348080) and c:IsAbleToGraveAsCost()
end
function c22348124.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348124.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348124.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22348124.spfilter(c,e,tp)
	return c:IsSetCard(0x703) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348124.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348124.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c22348124.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348124.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348124.atkfilter(c,e,tp)
	return c:IsSetCard(0x703) and c:IsType(TYPE_MONSTER)
end
function c22348124.atktg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x703)
end
function c22348124.atkval(e,c)
	return Duel.GetMatchingGroupCount(c22348124.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end



function c22348124.cfilter(c,tp)
	return c:IsSetCard(0x703)
end

function c22348124.thcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():IsReason(REASON_EFFECT) and eg:IsExists(c22348124.cfilter,1,e:GetHandler(),tp) and rp==1-tp
end
function c22348124.thfilter(c)
	return c:IsSetCard(0x3703) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22348124.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c22348124.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22348124.thfilter,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22348124.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c22348124.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local tg=Group.__add(c,tc)
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end