--闪耀的紫焰光 田中摩美美
function c28316149.initial_effect(c)
	--antica spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28316149)
	e1:SetCondition(c28316149.spcon)
	e1:SetCost(c28316149.cost)
	e1:SetTarget(c28316149.sptg)
	e1:SetOperation(c28316149.spop)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	--to hand
	if not CATEGORY_MSET then CATEGORY_MSET,CATEGORY_SSET = 0,0 end
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28316149,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_MSET+CATEGORY_SSET+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38316149)
	e2:SetCondition(c28316149.thcon)
	e2:SetCost(c28316149.cost)
	--e2:SetTarget(c28316149.thtg)
	e2:SetOperation(c28316149.thop)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
	c28316149.field_effect=e2
end
function c28316149.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c28316149.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if Duel.GetLP(tp)>3000 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
	end
end
function c28316149.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
	if Duel.GetLP(tp)>3000 then Duel.Damage(tp,2000,REASON_EFFECT) end
end
function c28316149.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c28316149.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28316149.cfilter,1,nil,tp)
end
function c28316149.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c28316149.setfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c28316149.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() then c28316149.effop(c) end
	if Duel.GetLP(tp)<=3000 and Duel.IsExistingMatchingCard(c28316149.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28316149,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c28316149.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SSet(tp,g)
	end
end
function c28316149.effop(c)
	--operation
	local id=c:IsOriginalCodeRule(28333723) and 4 or 1
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(28316149,id))
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CUSTOM+28333723)
	e0:SetRange(0xff)
	e0:SetOperation(c28316149.regop)
	c:RegisterEffect(e0)
	--trigger
	local flag=not ANTICA_EFFECT_HINT and EFFECT_FLAG_DELAY or 0--console
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28316149,id))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(flag+EFFECT_FLAG_CLIENT_HINT)
	e1:SetOperation(c28316149.checkop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
end
function c28316149.checkop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local p=e:GetHandler():GetPreviousControler()
	if e:GetHandler():IsReason(REASON_DESTROY) then
		if not ANTICA_EFFECT_HINT then Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+28333723,te,0,0,0,0) else
			c28384553.process_list[p][#c28384553.process_list[p]+1]=te
		end
	end
	e:Reset()
end
function c28316149.mmmfilter(c,e,p,code)
	return c:IsCode(code) and (c:IsSSetable() or Duel.GetMZoneCount(p)>0 and c:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEDOWN_DEFENSE))
end
function c28316149.regop(e,tp,eg,ep,ev,re,r,rp)
	if re~=e then return end
	local c=e:GetHandler()
	local p=c:GetPreviousControler()
	local g=Duel.GetMatchingGroup(c28316149.mmmfilter,p,LOCATION_DECK,0,nil,e,p,c:GetPreviousCodeOnField())
	if c:IsReason(REASON_DESTROY) and #g>0 then
		Duel.Hint(HINT_CARD,0,28316149)
		local tc=g:GetFirst()
		if #g>=2 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SET)
			tc=g:Select(p,1,1,nil):GetFirst()
		end
		if Duel.GetMZoneCount(p)>0 and tc:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEDOWN_DEFENSE) and (not tc:IsSSetable() or Duel.SelectOption(p,1152,1153)==0) then
			Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-p,tc)
		else
			Duel.SSet(p,tc)
		end
	end
	e:Reset()
end
function c28316149.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFlagEffectLabel(tp,28316149) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,28316149,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,28316149,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+28384553,e,0,0,0,0)
end
