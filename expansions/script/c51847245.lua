--辉光序曲「The World」-"只能使用这招了!"
function c51847245.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCost(c51847245.excost)
	e0:SetDescription(aux.Stringid(51847245,0))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c51847245.cost)
	e1:SetTarget(c51847245.target)
	e1:SetOperation(c51847245.activate)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51847245,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,51847245)
	e2:SetCondition(c51847245.thcon)
	e2:SetCost(c51847245.hintcost)
	e2:SetTarget(c51847245.thtg)
	e2:SetOperation(c51847245.thop)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
end
function c51847245.excfilter(c,tp,g)
	local cg=Group.FromCards(c)
	if g and #g>0 then cg:Merge(g) end
	return c:IsSetCard(0xa68) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsAbleToRemoveAsCost() and (#cg==1 or Duel.IsExistingMatchingCard(c51847245.rfilter,tp,0,LOCATION_ONFIELD,1,nil,cg))
end
function c51847245.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	--e:SetLabel(51847245)
	local cg=Group.CreateGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c51847245.excfilter,tp,LOCATION_MZONE,0,1,nil,tp,cg) end
	local fid=e:GetHandler():GetFieldID()
	local g=Duel.GetMatchingGroup(c51847245.excfilter,tp,LOCATION_MZONE,0,nil,tp,cg)
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	local sel=Duel.IsPlayerAffectedByEffect(tp,51847220) and Duel.SelectYesNo(tp,aux.Stringid(51847220,0)) and 1 or 0
	Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	local des=sel==1 and aux.Stringid(51847220,2) or aux.Stringid(51847245,3)
	tc:RegisterFlagEffect(51847245,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,des)
	if sel==1 then tc:RegisterFlagEffect(51847220,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(0,fid)
	e1:SetLabelObject(tc)
	e1:SetCondition(c51847245.retcon)
	e1:SetOperation(c51847245.retop)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local rg=Group.FromCards(tc)
	rg:KeepAlive()
	e:GetLabelObject():SetLabelObject(rg)
	e:GetLabelObject():SetLabel(sel,fid)
end
function c51847245.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)) then return false end
	local ct,fid=e:GetLabel()
	if ct==0 then e:SetLabel(1,fid) return false end
	if e:GetLabelObject():GetFlagEffectLabel(51847245)~=fid then e:Reset() return false else return true end
end
function c51847245.retop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():ResetFlagEffect(51847245)
	Duel.ReturnToField(e:GetLabelObject())
end
function c51847245.rmfilter(c)
	return c:IsSetCard(0xa68) and c:IsFaceupEx() and c:IsAbleToRemoveAsCost()
end
function c51847245.cfilter(c)
	return c:IsSetCard(0xa68) and c:IsFaceup()
end
function c51847245.rfilter(c,g)
	local cg=c:GetColumnGroup()
	return cg:IsExists(c51847245.cfilter,1,g)
end
function c51847245.gcheck(g,tp,sec)
	return Duel.IsExistingMatchingCard(c51847245.excfilter,tp,LOCATION_MZONE,0,1,g,tp,g)
		or sec and Duel.IsExistingMatchingCard(c51847245.rfilter,tp,0,LOCATION_ONFIELD,1,nil,g)
end
function c51847245.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local sec=not (Duel.GetTurnPlayer()~=tp and e:GetHandler():IsLocation(LOCATION_HAND))-- and e:GetLabelObject():GetLabel()~=51847245--skip extra check
	local g=Duel.GetMatchingGroup(c51847245.rmfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(c51847245.gcheck,3,3,tp,sec) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c51847245.gcheck,false,3,3,tp,true)
	local sel=sg:IsExists(Card.IsType,1,nil,TYPE_LINK) and Duel.IsPlayerAffectedByEffect(tp,51847220) and Duel.SelectYesNo(tp,aux.Stringid(51847220,0)) and 1 or 0
	local fid=e:GetHandler():GetFieldID()
	if sel==1 then
		local lg=sg:Filter(Card.IsType,nil,TYPE_LINK)
		sg:Sub(lg)
		Duel.Remove(lg,POS_FACEUP,REASON_COST+REASON_TEMPORARY)
		for tc in aux.Next(lg) do
			tc:RegisterFlagEffect(51847220,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(51847220,2))
		end
		local rg=e:GetLabelObject()
		if not rg then
			rg=lg
			rg:KeepAlive()
		else
			rg:Merge(lg)
		end
		e:SetLabelObject(rg)
		e:SetLabel(sel,fid)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c51847245.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51847245.rfilter,tp,0,LOCATION_ONFIELD,1,nil,nil) end
end
function c51847245.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local _,fid=e:GetLabel()
	if g and #g>0 then
		for tc in aux.Next(g) do if tc:GetFlagEffectLabel(51847220)==fid then tc:ResetFlagEffect(51847220) Duel.ReturnToField(tc) end end
		g:DeleteGroup()
	end
	local g=Duel.GetMatchingGroup(c51847245.rfilter,tp,0,LOCATION_ONFIELD,nil,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c51847245.thcfilter(c)
	return c:IsSetCard(0xa68) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function c51847245.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c51847245.thcfilter,1,nil)
end
function c51847245.hintcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--hint
	local ct=Duel.GetFlagEffectLabel(tp,51847245) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,51847245,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,51847245,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+51847250,e,0,0,0,0)
end
function c51847245.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c51847245.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,c)
	end
end
