--疯狂犯罪者·松鼠猴
local s,id,o=GetID()
function s.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetRange(0xff)
	e3:SetCondition(s.ntcon)
	e3:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1191)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.tgcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.limit(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	s.limit(e,tp)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.CheckTribute(c,0) and c:IsLocation(LOCATION_HAND)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.sumfilter(c,se)
	return c:IsSetCard(0x6A73) and (c:IsSummonable(true,nil) or c:IsLevelAbove(5) and c:IsSummonable(true,se))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local se=e:GetLabelObject()
	if chk==0 then return Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,se) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,se)
	local tc=g:GetFirst()
	if tc then
		local ne=nil
		if tc:IsLevelAbove(5) and tc:IsSummonable(true,se) and (not tc:IsSummonable(true,nil) or Duel.SelectYesNo(tp,aux.Stringid(id,3))) then
			ne=se
		end
		if tc:IsSummonable(true,ne) then
			Duel.Summon(tp,tc,true,ne)
		end
	end
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==id then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
	s.limit(e,tp)
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsReason(REASON_TEMPORARY) and e:GetLabelObject():IsLocation(LOCATION_REMOVED)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function s.tgfilter(c)
	return c:IsSetCard(0x6A73) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if #sg>0 and Duel.SendtoGrave(sg,REASON_EFFECT)>0 and sg:GetFirst():IsLocation(LOCATION_GRAVE) then
		local rg=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if #rg==0 then return end
		if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			local tc=rg:Select(tp,1,1,nil):GetFirst()
			if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				tc:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(id,2))
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
				if Duel.GetCurrentPhase()==PHASE_STANDBY then
					e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
				else
					e1:SetReset(RESET_PHASE+PHASE_STANDBY)
				end
				e1:SetLabelObject(tc)
				e1:SetCountLimit(1)
				e1:SetCondition(s.retcon2)
				e1:SetOperation(s.retop2)
				e1:SetLabel(Duel.GetTurnCount())
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(id+o)~=0
end
function s.retop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end