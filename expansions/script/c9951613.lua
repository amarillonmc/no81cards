--fate·黑阿尔托利亚女仆
function c9951613.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xba5),aux.FilterBoolFunction(Card.IsAttackBelow,3000),2,true)
 --disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c9951613.distg)
	c:RegisterEffect(e1)
--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c9951613.disop)
	c:RegisterEffect(e2)
--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951613,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9951613.discon)
	e1:SetCost(c9951613.discost)
	e1:SetTarget(c9951613.distg2)
	e1:SetOperation(c9951613.disop2)
	c:RegisterEffect(e1)
--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9951613,2))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetTarget(c9951613.thtg)
	e5:SetOperation(c9951613.thop)
	c:RegisterEffect(e5)
	 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951613.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951613.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951613,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951613,1))
end
function c9951613.distg(e,c)
	return c:IsType(TYPE_LINK)
end
function c9951613.disop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_LINK) then Duel.NegateEffect(ev) end
end
function c9951613.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainDisablable(ev)
end
function c9951613.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9951613.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9951613.disop2(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateEffect(ev)
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951613,2))
end
function c9951613.thfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9951613.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9951613.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951613.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9951613.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9951613.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951613,2))
end
