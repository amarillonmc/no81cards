--巴别塔的亡灵·博士 - 人物技能卡片
function c79029233.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetOperation(c79029233.reop)
	c:RegisterEffect(e1)	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45950291,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(c79029233.thcon)
	e2:SetCost(c79029233.thcost)
	e2:SetTarget(c79029233.thtg)
	e2:SetOperation(c79029233.thop)
	c:RegisterEffect(e2)
	--sigle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e3)
end
function c79029233.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_RULE)
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
	Duel.Draw(tp,1,REASON_RULE)
end   
end
function c79029233.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetDrawCount(tp)>0 and Duel.GetLP(tp)<=1000
end
function c79029233.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
end
end
function c79029233.thfilter(c,e,tp)
	return (c:IsSetCard(0xc90e) or c:IsSetCard(0xb90d) or c:IsSetCard(0xa90f) or c:IsSetCard(0xa900)) and c:IsAbleToHand()
end
function c79029233.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c79029233.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c79029233.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029233.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c79029233.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end








