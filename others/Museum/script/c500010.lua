--Energetic de Doe
function c500010.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c500010.tg)
	e1:SetOperation(c500010.activate)
	c:RegisterEffect(e1)
	e1:SetLabel(100)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500010,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,500010)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c500010.scost)
	e2:SetTarget(c500010.stg)
	e2:SetOperation(c500010.sop)
	c:RegisterEffect(e2)
	--set2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(500010,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,500110)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCost(c500010.scost2)
	e3:SetTarget(c500010.stg2)
	e3:SetOperation(c500010.sop2)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(500010,ACTIVITY_CHAIN,c500010.chainfilter)	 
end

function c500010.filter(c,e,tp)
	if (not c:IsSetCard(0xffad) and not c:IsSetCard(0xffac)) or c:IsFacedown() or c:IsCode(500010) then return false end
	local tg=c:GetActivateEffect():GetTarget()
	return not c.noway and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,false,true))
end
function c500010.tg(e,tp,eg,ep,ev,re,r,rp,chk,oilolo,caca)
	if chk==0 then 
	   if caca then return 
		  Duel.IsExistingMatchingCard(c500010.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler(),e,tp,eg,ep,ev,re,r,rp)
	   else
		  return true
	   end
	end
end
function c500010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c500010.filter,tp,LOCATION_SZONE,LOCATION_SZONE,c,e,tp,eg,ep,ev,re,r,rp)
	if g:GetCount()>0 and Duel.GetCustomActivityCount(500010,tp,ACTIVITY_CHAIN)==0 and ((Duel.GetFlagEffect(tp,500010)==0 and Duel.SelectYesNo(tp,aux.Stringid(500010,0)))) then
	Duel.RegisterFlagEffect(tp,500010,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetTurnPlayer()~=tp then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c500010.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	local g=Duel.GetMatchingGroup(c500010.filter,tp,LOCATION_SZONE,LOCATION_SZONE,c,e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		local te=tc:GetActivateEffect()
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function c500010.setfilter3(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable() and (c:IsSetCard(0xffac) or c:IsSetCard(0xffad))
end
function c500010.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c500010.setfilter3,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c500010.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500010.setfilter3,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetFlagEffect(tp,500010)==0 end
end
function c500010.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c500010.cfilter(c,tp,rc)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and (c:IsSetCard(0xffac) or c:IsSetCard(0xffad)) and c:IsAbleToDeckAsCost() and c:IsFaceup() and Duel.IsExistingMatchingCard(c500010.setfilter2,tp,LOCATION_GRAVE,0,1,c,rc,tp) and not c:IsCode(500008)
end
function c500010.setfilter2(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable() and (c:IsSetCard(0xffac) or c:IsSetCard(0xffad)) and not c:IsCode(500008)
end
function c500010.scost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c500010.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c500010.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler(),tp)
	g:AddCard(e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c500010.stg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500010.setfilter2,tp,LOCATION_GRAVE,0,1,nil) end
end
function c500010.sop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c500010.setfilter2,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c500010.chainfilter(re,tp,cid)
	return re:GetActivateLocation()~=LOCATION_MZONE 
end