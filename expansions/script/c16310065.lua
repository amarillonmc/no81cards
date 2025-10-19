--Legend-Arms 传世的救灭神装
function c16310065.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(c16310065.con)
	e1:SetValue(c16310065.tg)
	c:RegisterEffect(e1)
	--cannot be target
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e11:SetRange(LOCATION_SZONE)
	e11:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e11:SetTargetRange(LOCATION_MZONE,0)
	e11:SetCondition(c16310065.con)
	e11:SetTarget(c16310065.tg)
	e11:SetValue(aux.tgoval)
	c:RegisterEffect(e11)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,16310065)
	e2:SetTarget(c16310065.tgtg)
	e2:SetOperation(c16310065.tgop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,16310065+1)
	e3:SetCondition(c16310065.thcon)
	e3:SetTarget(c16310065.thtg)
	e3:SetOperation(c16310065.thop)
	c:RegisterEffect(e3)
end
function c16310065.filter(c)
	return c:IsFaceup() and c:IsAttack(0)
end
function c16310065.con(e)
	return Duel.IsExistingMatchingCard(c16310065.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c16310065.tg(e,c)
	return c:IsFaceup() and c:IsDefense(0)
end
function c16310065.tgfilter(c)
	return c:IsSetCard(0x3dc6) and c:IsType(0x1) and c:IsAbleToGrave() and c:IsFaceup()
		and c:IsLevelBelow(11)
end
function c16310065.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c16310065.tgfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function c16310065.check(g)
	return g:GetSum(Card.GetLevel)<=11
end
function c16310065.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c16310065.tgfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	aux.GCheckAdditional=c16310065.check
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,1,11)
	aux.GCheckAdditional=nil
	if sg and sg:GetCount()>0 then
		Duel.SendtoGrave(sg,nil,REASON_EFFECT+REASON_RETURN)
	end
end
function c16310065.sfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsPreviousSetCard(0x3dc6)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c16310065.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16310065.sfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c16310065.thfilter(c)
	return c:IsSetCard(0x3dc6) and c:IsType(0x1) and c:IsFaceupEx() and c:IsAbleToHand()
end
function c16310065.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c16310065.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16310065.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c16310065.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c16310065.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end