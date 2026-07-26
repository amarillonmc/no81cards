--四象天引录
local s,id,o=GetID()
local CodeList=1202000	--引力术卡号
function s.initial_effect(c)
	aux.AddCodeList(c,CodeList)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--gravity
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.gvcon)
	e2:SetCost(s.gvcost)
	e2:SetTarget(s.gvtg)
	e2:SetOperation(s.gvop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	--e3:SetCountLimit(1)
	e3:SetCondition(s.rmcon)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	--本代码抄袭自「天命教士」（16104200）
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_RELEASE)
	e4:SetOperation(s.MonToPenOp2)
	c:RegisterEffect(e4)
	
end

function s.gvsumfilter(c,e,tp)
	return c:IsSummonable(false,nil)
end
function s.gvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 or Duel.IsExistingMatchingCard(s.gvsumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp)
end
function s.costfilter(c)
	return c:IsCode(CodeList) and c:IsReleasable(REASON_COST)
end
function s.gvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function s.gvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.gvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND):Filter(Card.IsLevelAbove,nil,1)
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetOperation(s.hlvop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(s.actlimit2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function s.hlvfilter(c)
	return c:IsLevelAbove(1)
end
function s.hlvop(e,tp,eg,ep,ev,re,r,rp)
	local hg=eg:Filter(s.hlvfilter,nil)
	local tc=hg:GetFirst()
	local time=e:GetLabel()
	if time-Duel.GetTurnCount()+2<=0 then return end
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END
			,time-Duel.GetTurnCount()+2)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
end

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():IsLocation(LOCATION_SZONE)
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		and e:GetHandler():GetFlagEffect(id+1)<=0
end
function s.rmfilter(c)
	return (c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsAbleToRemove() and c:IsLevelAbove(8))
		or (aux.IsCodeListed(c,CodeList) and c:IsAbleToRemove() and c:IsFaceup() and c:IsType(TYPE_CONTINUOUS))
		--and (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_CONTINUOUS))
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and c:IsLocation(LOCATION_SZONE) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		if not g or g:GetCount()==0 then return end
		local tg=g:Select(tp,1,g:GetCount(),e:GetHandler())
		Duel.Hint(HINT_CARD,0,id)
		Duel.HintSelection(tg)
		if Duel.Remove(tg,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			for tc in aux.Next(og) do
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(og)
			e1:SetCountLimit(1)
			e1:SetCondition(s.retcon)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
			--for tc in aux.Next(og) do
			--	local e2=Effect.CreateEffect(c)
			--	e2:SetType(EFFECT_TYPE_FIELD)
			--	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			--	e2:SetCode(EFFECT_CANNOT_REMOVE)
			--	e2:SetTargetRange(1,0)
			--	e2:SetTarget(s.rmlimit)
			--	e2:SetLabel(tc:GetOriginalCode())
			--	e2:SetReset(RESET_PHASE+PHASE_END)
			--	Duel.RegisterEffect(e2,tp)
			--end
		end
		c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
	end
end
function s.rmlimit(e,c,tp,r,re)
	return c:GetOriginalCode()==e:GetLabel() and re and re:GetHandler():GetOriginalCode()==id and r&REASON_EFFECT~=0
end
function s.retfilter(c)
	return c:GetFlagEffect(id)~=0
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(s.retfilter,1,nil)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)	
	local g=e:GetLabelObject():Filter(s.retfilter,nil)
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
end

function s.MonToPenOp2(e,tp)
	local c=e:GetHandler()
	if not c:IsPreviousLocation(LOCATION_DECK) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() and c:CheckUniqueOnField(tp) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			local g=Group.FromCards(c)
			g=g:Select(tp,1,1,nil)
			Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
			if Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,false) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetValue(s.actlimit)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
			c:SetStatus(STATUS_EFFECT_ENABLED,true)
			
		end
	end
end
function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function s.actlimit2(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsLocation(LOCATION_ONFIELD)
end