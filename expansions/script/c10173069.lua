--霸王超龙 终端毁灭龙
function c10173069.initial_effect(c)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173069,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10173069.descon)
	e1:SetTarget(c10173069.destg)
	e1:SetOperation(c10173069.desop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173069,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c10173069.thcon)
	e2:SetTarget(c10173069.thtg)
	e2:SetOperation(c10173069.thop)
	c:RegisterEffect(e2)
	--to hand self
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10173069,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c10173069.retcon)
	e3:SetTarget(c10173069.rettg)
	e3:SetOperation(c10173069.retop)
	c:RegisterEffect(e3)
end
function c10173069.retcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c10173069.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10173069.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c10173069.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c10173069.thfilter(c,e)
	return c:IsAbleToHand() and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_EFFECT) and c:GetReasonEffect():GetOwner()==e:GetHandler()
end
function c10173069.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c10173069.thfilter,tp,0x70,0x70,nil,e)
	if g:GetCount()>0 then
	   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	end
end
function c10173069.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10173069.thfilter),tp,0x70,0x70,1,99,nil,e)
	if tg:GetCount()>0 and Duel.SendtoHand(tg,tp,REASON_EFFECT)~=0 then
	   local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,nil,e,0,tp,false,false)
	   if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(10173069,3)) then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local sg=g:Select(tp,1,1,nil)
		  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	   end
	end
end
function c10173069.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c10173069.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler())
	if g:GetCount()>0 then
	   Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
	Duel.SetChainLimit(aux.FALSE)
end
function c10173069.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,c)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
	   local dg=Duel.GetOperatedGroup()
	   local tc,code=dg:GetFirst(),0
	   while tc do
			 if tc:IsType(TYPE_MONSTER) then
				code=tc:GetOriginalCode()
				c:CopyEffect(code,RESET_EVENT+0x1fe0000)
				tc:SetHint(HINT_CARD,code)
			 end
	   tc=dg:GetNext()
	   end
	end
end