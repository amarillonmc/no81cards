--辉光序曲"突破"-「时间之箭」
function c51847205.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	--zone limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_MUST_USE_MZONE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	e0:SetValue(c51847205.zonelimit)
	c:RegisterEffect(e0)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdocon)
	e1:SetOperation(c51847205.regop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetDescription(1192)--aux.Stringid(51847205,0)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1,51847205)
	e2:SetCost(c51847205.rmcost)
	e2:SetTarget(c51847205.rmtg)
	e2:SetOperation(c51847205.rmop)
	c:RegisterEffect(e2)
end
function c51847205.zonelimit(e)
	return 0x7f007f & ~e:GetHandler():GetLinkedZone()
end
function c51847205.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
end
function c51847205.rmfilter(c)
	return c:IsSetCard(0xa68) and c:IsAbleToRemoveAsCost()
end
function c51847205.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c51847205.rmfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c51847205.rmfilter,tp,LOCATION_HAND,0,1,1,c):GetFirst()
	local g=Group.FromCards(c,tc):Filter(Card.IsType,nil,TYPE_LINK)
	local sel=#g>0 and Duel.IsPlayerAffectedByEffect(tp,51847220) and Duel.SelectYesNo(tp,aux.Stringid(51847220,0)) and 1 or 0
	local fid=c:GetFieldID()
	e:SetLabel(sel,fid)
	Duel.Remove(Group.FromCards(c,tc),POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	local og=Duel.GetOperatedGroup()
	for oc in aux.Next(og) do
		local des=oc:IsPreviousLocation(LOCATION_MZONE) and aux.Stringid(51847205,2) or aux.Stringid(51847205,1)
		if sel==1 and g:IsContains(oc) then des=aux.Stringid(51847220,2) end
		oc:RegisterFlagEffect(51847205,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,des)
	end
	if sel==1 then c:RegisterFlagEffect(51847220,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid) end
	og:KeepAlive()
	e:SetLabelObject(og)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(og)
	e1:SetCondition(c51847205.retcon)
	e1:SetOperation(c51847205.retop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c51847205.retfilter(c,fid)
	return c:GetFlagEffectLabel(51847205)==fid
end
function c51847205.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c51847205.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c51847205.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c51847205.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	for tc in aux.Next(sg) do
		if tc~=e:GetHandler() then Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		else Duel.ReturnToField(tc) end
	end
end
function c51847205.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c51847205.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local _,fid=e:GetLabel()
	for tc in aux.Next(g) do
		if tc:GetFlagEffectLabel(51847220)==fid then tc:ResetFlagEffect(51847220) Duel.ReturnToField(tc) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if sc then
		Duel.HintSelection(Group.FromCards(sc))
		Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
	end
end
