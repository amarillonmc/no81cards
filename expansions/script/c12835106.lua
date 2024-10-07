--侍之魂 樱流
local s,id,o=GetID()
function s.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--left
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.mcon1)
	e2:SetTarget(s.mtg1)
	e2:SetOperation(s.mop1)
	c:RegisterEffect(e2)
	--right
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.mcon2)
	e3:SetTarget(s.mtg2)
	e3:SetOperation(s.mop2)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_MSET)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge3:SetCondition(s.checkcon)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_CHANGE_POS)
		Duel.RegisterEffect(ge4,0)
	end
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.pcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPublic()
end
function s.cfilter(c)
	return (c:GetOriginalType()&TYPE_SPELL+TYPE_TRAP)>0 and c:IsSetCard(0x3a70) and c:IsAbleToGraveAsCost()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetTurnPlayer()==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function s.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(aux.TRUE)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e4:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e4,tp)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	s.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
end
function s.thfilter(c)
	return c:IsSetCard(0x3a70) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
function s.cfilter1(c,tp)
	local seq=c:GetSequence()
	return c:IsControler(tp) and c:IsCode(12835101) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_MZONE) and seq==c:GetPreviousSequence()-1 and seq<=3
end
function s.mcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil,tp) and e:GetHandler():GetFlagEffect(id)==0
end
function s.mtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mc=eg:Filter(s.cfilter1,nil,tp):GetFirst()
	if not mc then return false end
	local tg=mc:GetColumnGroup():Filter(Card.IsAbleToHand,nil)
	if chk==0 then return tg:GetCount()>0 and c:GetFlagEffect(id+100)==0 end
	c:RegisterFlagEffect(id+100,RESET_CHAIN,0,1)
	e:SetLabelObject(mc)
	mc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function s.mop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mc=e:GetLabelObject()
	if not mc:IsLocation(LOCATION_MZONE) or not mc:IsRelateToEffect(e) then return end
	Duel.Hint(24,0,aux.Stringid(id,0))
	local tc=mc:GetColumnGroup():FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	if tc then
		Duel.Hint(HINT_CARD,0,12835112)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,12835110,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.actcon)
	e1:SetOperation(s.actop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	c:SetTurnCounter(3)
end
function s.cfilter2(c,tp)
	local seq=c:GetSequence()
	return c:IsControler(tp) and c:IsCode(12835101) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_MZONE) and seq==c:GetPreviousSequence()+1 and seq<=4
end
function s.mcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter2,1,nil,tp) and e:GetHandler():GetFlagEffect(id)==0
end
function s.desfilter(c,s,tp)
	local seq=c:GetSequence()
	if c:GetSequence()==5 and tp~=c:GetControler() then seq=6 end
	if c:GetSequence()==6 and tp~=c:GetControler() then seq=5 end
	return seq<5 and aux.GetColumn(c,tp)==s or seq==5 and s==1 and c:IsLocation(LOCATION_MZONE) or seq==6 and s==3 and c:IsLocation(LOCATION_MZONE)
end
function s.mtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mc=eg:Filter(s.cfilter2,nil,tp):GetFirst()
	if not mc then return false end
	local seq=mc:GetPreviousSequence()
	local tg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,mc,seq,mc:GetControler())
	if chk==0 then return tg:GetCount()>0 and c:GetFlagEffect(id+100)==0 end
	c:RegisterFlagEffect(id+100,RESET_CHAIN,0,1)
	e:SetLabelObject(mc)
	mc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function s.mop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mc=e:GetLabelObject()
	if not mc:IsLocation(LOCATION_MZONE) or not mc:IsRelateToEffect(e) then return end
	Duel.Hint(24,0,aux.Stringid(id,1))
	local seq=mc:GetPreviousSequence()
	local tc=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,mc,seq,mc:GetControler())
	if tc then
		Duel.Hint(HINT_CARD,0,12835113)
		Duel.Destroy(tc,REASON_EFFECT)
	end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,12835110,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.actcon)
	e1:SetOperation(s.actop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	c:SetTurnCounter(3)
end
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPublic() and not re:GetHandler():IsCode(id)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct-1
	c:SetTurnCounter(ct)
	if ct==0 then
		Duel.Hint(24,0,aux.Stringid(id,2))
		c:ResetFlagEffect(id)
		e:Reset()
	end
end