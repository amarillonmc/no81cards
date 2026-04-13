--辉光序曲「Justice」-"我于此光芒中起誓"
function c51847250.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCost(c51847250.excost)
	e0:SetDescription(aux.Stringid(51847250,0))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c51847250.target)
	e1:SetOperation(c51847250.activate)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51847250,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,51847250)
	e2:SetCondition(c51847250.thcon)
	e2:SetCost(c51847250.hintcost)
	e2:SetTarget(c51847250.thtg)
	e2:SetOperation(c51847250.thop)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	if not JUSTICE_EFFECT_HINT then
		JUSTICE_EFFECT_HINT = true
		--CountLimit display
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CUSTOM+51847250)
		ge1:SetOperation(c51847250.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c51847250.excfilter(c)
	return c:IsSetCard(0xa68) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c51847250.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	--e:SetLabel(51847250)
	local cg=Group.CreateGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c51847250.excfilter,tp,LOCATION_MZONE,0,1,nil) end
	local fid=e:GetHandler():GetFieldID()
	local g=Duel.GetMatchingGroup(c51847250.excfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	local sel=Duel.IsPlayerAffectedByEffect(tp,51847220) and Duel.SelectYesNo(tp,aux.Stringid(51847220,0)) and 1 or 0
	Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	local des=sel==1 and aux.Stringid(51847220,2) or aux.Stringid(51847250,3)
	tc:RegisterFlagEffect(51847250,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,des)
	if sel==1 then tc:RegisterFlagEffect(51847220,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(0,fid)
	e1:SetLabelObject(tc)
	e1:SetCondition(c51847250.retcon)
	e1:SetOperation(c51847250.retop)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--local rg=Group.FromCards(tc)
	--rg:KeepAlive()
	e:GetLabelObject():SetLabelObject(tc)
	e:GetLabelObject():SetLabel(sel,fid)
end
function c51847250.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)) then return false end
	local ct,fid=e:GetLabel()
	if ct==0 then e:SetLabel(1,fid) return false end
	if e:GetLabelObject():GetFlagEffectLabel(51847250)~=fid then e:Reset() return false else return true end
end
function c51847250.retop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():ResetFlagEffect(51847250)
	Duel.ReturnToField(e:GetLabelObject())
end
function c51847250.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,51847250)<3 end
end
function c51847250.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,51847250)>=3 then return end
	Duel.RegisterFlagEffect(tp,51847250,0,0,0)
	local tc=e:GetLabelObject()
	local _,fid=e:GetLabel()
	if tc and tc:GetFlagEffectLabel(51847220)==fid then tc:ResetFlagEffect(51847220) Duel.ReturnToField(tc) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetCondition(c51847250.rmcon)
	e1:SetOperation(c51847250.rmop)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c51847250.rmcfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function c51847250.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c51847250.rmcfilter,1,nil,tp)
end
function c51847250.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,51847250)
	local g0=Duel.GetDecktopGroup(0,1)
	local g1=Duel.GetDecktopGroup(1,1)
	g0:Merge(g1)
	Duel.DisableShuffleCheck()
	if Duel.Remove(g0,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup()
		local fid=og:GetFirst():GetFieldID()
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(51847250,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(51847250,2))
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCondition(c51847250.rtdcon)
		e1:SetOperation(c51847250.rtdop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c51847250.retfilter(c,fid)
	return c:GetFlagEffectLabel(51847250)==fid
end
function c51847250.rtdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c51847250.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c51847250.rtdop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c51847250.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	for tc in aux.Next(sg) do
		Duel.SendtoDeck(tc,tc:GetPreviousControler(),SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c51847250.thcfilter(c)
	return c:IsSetCard(0xa68) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function c51847250.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c51847250.thcfilter,1,nil)
end
function c51847250.hintcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--hint
	local ct=Duel.GetFlagEffectLabel(tp,51847250) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,51847250,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,51847250,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+51847250,e,0,0,0,0)
end
function c51847250.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c51847250.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,c)
	end
end
function c51847250.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local ge1=Effect.CreateEffect(e:GetHandler())
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CUSTOM+51847250)
		ge1:SetOperation(c51847250.hintop)
		Duel.RegisterEffect(ge1,p)
	end
	e:Reset()
end
function c51847250.hintop(e,tp,eg,ep,ev,re,r,rp)
	--if rp~=tp then return end
	--if r~=0 then return end
	local member_list={51847225,51847230,51847235,51847240,51847245,51847250}
	for _,te in pairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+51847250)}) do te:Reset() end
	for i,code in pairs(member_list) do
		if Duel.GetFlagEffectLabel(tp,code)==1 then
			local te=Effect.CreateEffect(e:GetHandler())
			te:SetDescription(aux.Stringid(code,5))
			te:SetType(EFFECT_TYPE_FIELD)
			te:SetCode(EFFECT_FLAG_EFFECT+51847250)
			te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			te:SetTargetRange(1,0)
			te:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(te,tp)
		end
	end
end
