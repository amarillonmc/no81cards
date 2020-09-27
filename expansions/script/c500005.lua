--Foodie De Lapin
function c500005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c500005.tg)
	e1:SetOperation(c500005.activate)
	c:RegisterEffect(e1)   
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500005,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,500005)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c500005.scost)
	e2:SetTarget(c500005.stg)
	e2:SetOperation(c500005.sop)
	c:RegisterEffect(e2)
	--set2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(500005,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,500105)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCost(c500005.scost2)
	e3:SetTarget(c500005.stg2)
	e3:SetOperation(c500005.sop2)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(500005,ACTIVITY_CHAIN,c500005.chainfilter)
end
function c500005.costfilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsReleasableByEffect() and (c:IsOnField() or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c500005.setfilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and (c:IsSSetable() or c:GetActivateEffect():IsActivatable(tp))
end
function c500005.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if e:GetLabel()==100 then return 
		  Duel.IsExistingMatchingCard(c500005.setfilter,tp,LOCATION_GRAVE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c500005.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp)
	   else
		  return true
	   end
	end
end
function c500005.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c500005.setfilter,tp,LOCATION_GRAVE,0,nil,tp)
	if g:GetCount()>0 and Duel.IsExistingMatchingCard(c500005.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) and Duel.GetCustomActivityCount(500005,tp,ACTIVITY_CHAIN)==0 and (e:GetLabel()==100 or (Duel.GetFlagEffect(tp,500005)==0 and Duel.SelectYesNo(tp,aux.Stringid(500005,0)))) then
		if e:GetLabel()~=100 then
		   Duel.RegisterFlagEffect(tp,500005,RESET_PHASE+PHASE_END,0,1)
		end
		local rg=Duel.SelectMatchingCard(tp,c500005.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
		Duel.SendtoGrave(rg,REASON_EFFECT+REASON_RELEASE)
		if Duel.GetTurnPlayer()~=tp then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c500005.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.GetMatchingGroup(c500005.setfilter,tp,LOCATION_GRAVE,0,nil,tp)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if not tc then return end
		if tc:IsSSetable() and (not tc:GetActivateEffect():IsActivatable(tp) or not Duel.SelectYesNo(tp,aux.Stringid(500005,2))) then
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
function c500005.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_MZONE 
end
function c500005.chainfilter(re,tp,cid)
	return re:GetActivateLocation()~=LOCATION_MZONE 
end
function c500005.setfilter3(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable() and (c:IsSetCard(0xffac) or c:IsSetCard(0xffad))
end
function c500005.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c500005.setfilter3,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c500005.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500005.setfilter3,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetFlagEffect(tp,500005)==0 end
end
function c500005.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c500005.cfilter(c,tp,rc)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and (c:IsSetCard(0xffac) or c:IsSetCard(0xffad)) and c:IsAbleToDeckAsCost() and c:IsFaceup() and Duel.IsExistingMatchingCard(c500005.setfilter2,tp,LOCATION_GRAVE,0,1,c,rc,tp) and not c:IsCode(500008)
end
function c500005.setfilter2(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable() and (c:IsSetCard(0xffac) or c:IsSetCard(0xffad)) and not c:IsCode(500008)
end
function c500005.scost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c500005.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c500005.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler(),tp)
	g:AddCard(e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c500005.stg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500005.setfilter2,tp,LOCATION_GRAVE,0,1,nil) end
end
function c500005.sop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c500005.setfilter2,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
