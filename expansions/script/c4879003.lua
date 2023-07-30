local m=4879003
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	 local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(cm.rlcon2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.lkcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	if not cm.global_check then
	cm.global_check=true
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_TO_HAND)
	--ge1:SetCondition(cm.spcon)
	ge1:SetOperation(cm.negop)
	Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkfilter(c,tp)
	return c:IsCode(m) and c:IsControler(tp)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.checkfilter,1,nil,0) and re and re:GetHandler():IsSetCard(0xae55) then Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1) end
	if eg:IsExists(cm.checkfilter,1,nil,1) and re and re:GetHandler():IsSetCard(0xae55) then Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1) end
end
function cm.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0xae55) and e:GetHandler():IsCode(m)
end
function cm.rlcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)~=0
end
function cm.filter(c)
	return c:IsSetCard(0xae55) and c:IsAbleToHand()
end
function cm.desfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xae55)
end
function cm.cfilter(c,code)
	return c:IsCode(code)
end
function cm.tgfilter(c)
	return c:IsSetCard(0xae56) and c:IsAbleToGrave() and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
   g1:Merge(g2)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoHand(g,nil,REASON_EFFECT) then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g1:GetCount()>0 then
	Duel.SendtoGrave(g1,REASON_EFFECT)
	end
	end
end
function cm.cfilter(c)
	return c:IsSetCard(0xae55) and not c:IsPublic()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
e:SetLabel(1)
	if chk==0 then return true end
   
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if e:GetLabel()==0 then return false end
	e:SetLabel(0)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
		e:SetLabel(0)
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.filter2(c)
	return c:IsSetCard(0xae55) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
	local c=e:GetHandler()
	if  c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then 
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
	 
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	 if g2:GetCount()>0 then
	local sg1=g2:Select(tp,1,1,nil)
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
	end
	end
local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end