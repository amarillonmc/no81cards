--第10032次轮回
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	aux.AddCodeList(c,5012604)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	--e1:SetCountLimit(1,id)
	--e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCost(s.cost)
	c:RegisterEffect(e2)
	--lv
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCost(s.spcost)
	--e3:SetCountLimit(1,id)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.cfilter(c,tp)
	return c.MoJin and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,c,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.thfilter(c)
	return c:IsAbleToDeck() or c:IsAbleToHand() 
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	sg:KeepAlive() 
	if Duel.Remove(sg,0,REASON_EFFECT+REASON_TEMPORARY) then
		local og=Duel.GetOperatedGroup()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(sg)
		e1:SetCountLimit(1)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
		
	   local e2=Effect.CreateEffect(e:GetHandler())
	   e2:SetType(EFFECT_TYPE_FIELD)
	   e2:SetCode(EFFECT_CHANGE_DAMAGE)
	   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e2:SetTargetRange(0,1)
	   e2:SetValue(0)
	   e2:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e2,tp)
	   local e3=e2:Clone()
	   e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	   e3:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e3,tp)
	
		local ct1=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_REMOVED,0,nil)
		local ct2=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_REMOVED,nil)
		if ct1<ct2 then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetCode(EFFECT_CANNOT_ACTIVATE)
			e4:SetTargetRange(1,0)
			e4:SetValue(s.aclimit)
			e4:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e4,tp)
		elseif ct1>ct2 then
			local tg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_REMOVED,0,nil)
			local tohand=tg:Filter(Card.IsAbleToHand,nil)
			local todeck=tg:Filter(Card.IsAbleToDeck,nil)
			if (#tohand>1 or #todeck>1) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then  
				if #todeck>2 and (#tohand<2 or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
					local dc=todeck:Select(tp,2,2,nil)
					Duel.SendtoDeck(dc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local tc=tohand:Select(tp,2,2,nil)
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				end
			end
		end
	end
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return not rc.MoJin
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
end
function s.ndcfilter(c)
	return c:IsFaceup() and c.MoJin
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	--return Duel.IsExistingMatchingCard(s.ndcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	return ct>0 and ct==Duel.GetMatchingGroupCount(s.ndcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
end
function s.spfilter(c,e,tp)
	local b1=Duel.GetLocationCountFromEx(tp,1-tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and not c:IsLocation(LOCATION_EXTRA)
	return c:IsCode(5012613) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and (b1 or b2)
end
function s.spfilter2(c,e,tp)
	local b1=Duel.GetLocationCountFromEx(tp,1-tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and not c:IsLocation(LOCATION_EXTRA)
	return c:IsCode(5012604) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,1-tp,true,true) and (b1 or b2)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) 
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)~=0 then
		g:GetFirst():CompleteProcedure()
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		if #sg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,1-tp,true,true,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end