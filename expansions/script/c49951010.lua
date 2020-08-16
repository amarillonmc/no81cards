--混沌病毒-伊索德
function c49951010.initial_effect(c)
 --xyz summon
	aux.AddXyzProcedure(c,nil,1,3,c49951010.ovfilter,aux.Stringid(49951010,0),99,c49951010.xyzop)
	c:EnableReviveLimit() 
	 --to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49951010,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,49951010)
	e1:SetCost(c49951010.cost)
	e1:SetCondition(c49951010.thcon)
	e1:SetTarget(c49951010.thtg)
	e1:SetOperation(c49951010.thop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49951010,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c49951010.damcon2)
	e3:SetCost(c49951010.damcost2)
	e3:SetOperation(c49951010.damop2)
	c:RegisterEffect(e3)
	 --get effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(49951010,2))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,499510003)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(aux.exccon)
	e5:SetTarget(c49951010.destg)
	e5:SetOperation(c49951010.desop)
	c:RegisterEffect(e5)
end
function c49951010.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x823) and c:IsLevel(1) and not c:IsCode(49951010)
end
function c49951010.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,49951010)==0 end
	Duel.RegisterFlagEffect(tp,49951010,RESET_PHASE+PHASE_END,0,1)
end
function c49951010.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c49951010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c49951010.thfilter1(c)
	return c:IsCode(49951004) and c:IsAbleToHand()
end
function c49951010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49951010.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49951010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c49951010.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c49951010.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c49951010.damcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(49951010)==0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(49951010,RESET_CHAIN,0,1)
end
function c49951010.damop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	Duel.RegisterEffect(e1,tp)
end
function c49951010.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x823)
end
function c49951010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c49951010.sfilter(chkc,ft) end
	if chk==0 then return ft>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c49951010.sfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c49951010.sfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49951010.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
