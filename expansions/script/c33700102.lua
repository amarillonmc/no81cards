--动物朋友的回忆
function c33700102.initial_effect(c)
	c:SetUniqueOnField(1,0,33700102)  
	c:EnableCounterPermit(0x25)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
   --counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c33700102.ctcon)
	e2:SetOperation(c33700102.ctop)
	c:RegisterEffect(e2)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700102,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c33700102.cost)
	e2:SetLabel(2)
	e2:SetTarget(c33700102.target)
	e2:SetOperation(c33700102.operation)
	c:RegisterEffect(e2)
	--Destroy
   local e3=e2:Clone()
   e3:SetDescription(aux.Stringid(33700102,1))
   e3:SetCategory(CATEGORY_DESTROY)
   e3:SetLabel(3)
   e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
   e3:SetTarget(c33700102.destg)
   e3:SetOperation(c33700102.desop)
   c:RegisterEffect(e3)
   --draw
   local e4=e2:Clone()
   e4:SetDescription(aux.Stringid(33700102,2))
   e4:SetCategory(CATEGORY_DRAW)
   e4:SetLabel(3)
   e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
   e4:SetTarget(c33700102.drtg)
   e4:SetOperation(c33700102.drop)
   c:RegisterEffect(e4)
end
function c33700102.cfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) 
end
function c33700102.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700102.cfilter,1,nil)
end
function c33700102.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c33700102.cfilter,nil)
	e:GetHandler():AddCounter(0x25,ct)
end
function c33700102.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x25)>=e:GetLabel() end
   Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
   Duel.RemoveCounter(e:GetHandler(),tp,0x25,e:GetLabel(),REASON_COST)
end
function c33700102.filter(c,e,sp)
	return c:IsSetCard(0x442) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c33700102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c33700102.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33700102.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33700102.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c33700102.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c33700102.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c33700102.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c33700102.drop(e,tp,eg,ep,ev,re,r,rp)
	 if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.Draw(tp,2,REASON_EFFECT)
	if ct==0 then return end
	Duel.BreakEffect()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(33700102,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c33700102.recon)
	e1:SetOperation(c33700102.reop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e:GetHandler():RegisterEffect(e1)
end
function c33700102.recon(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetMatchingGroup(c33700102.cfilter,tp,LOCATION_GRAVE,0,nil)
	return Duel.GetTurnPlayer()==tp and  g:GetClassCount(Card.GetCode)<10 and e:GetHandler():GetCounter(0x25)>0
end
function c33700102.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(e:GetHandler(),tp,0x25,e:GetHandler():GetCounter(0x25),REASON_EFFECT)
end