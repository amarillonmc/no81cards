--迷托邦夜守 迷昔
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	--c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
end
function cm.cfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function cm.thfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToHand()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) then Duel.HintSelection(Group.FromCards(e:GetHandler())) end
	--Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
		if #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.BreakEffect()
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then e:GetLabelObject():AddCard(tc) end
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		local fid=e1:GetFieldID()
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(e:GetLabelObject())
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		if Duel.GetCurrentPhase()==PHASE_END then
			e1:SetLabel(Duel.GetTurnCount()+1)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,fid,aux.Stringid(m,1))
		else
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(m,1))
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retfilter(c,e)
	return c:GetFlagEffect(m)>0 --Label(m)==e:GetLabel()
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	if e:GetLabel()~=Duel.GetTurnCount() then
		return false
	elseif tg:IsExists(cm.retfilter,1,nil,e) then
		return true
	else
		tg:Clear()
		e:Reset()
		return false
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject():Filter(cm.retfilter,nil,e)
	for tc in aux.Next(tg) do Duel.SendtoHand(tc,nil,REASON_EFFECT) end
	e:GetLabelObject():Clear()
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsCode(m) then
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,e,0,0,0,0)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end