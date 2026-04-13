--辉光序曲「The Lovers」-"大家，拜托了!"
function c51847230.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCost(c51847230.excost)
	e0:SetDescription(aux.Stringid(51847230,0))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCost(c51847230.cost)
	e1:SetTarget(c51847230.target)
	e1:SetOperation(c51847230.activate)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51847230,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,51847230)
	e2:SetCondition(c51847230.thcon)
	e2:SetCost(c51847230.hintcost)
	e2:SetTarget(c51847230.thtg)
	e2:SetOperation(c51847230.thop)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
end
function c51847230.excfilter(c,tp)
	return c:IsSetCard(0xa68) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsAbleToRemoveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,TYPE_LINK)>0
end
function c51847230.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	--e:SetLabel(51847230)
	if chk==0 then return Duel.IsExistingMatchingCard(c51847230.excfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local fid=e:GetHandler():GetFieldID()
	local g=Duel.GetMatchingGroup(c51847230.excfilter,tp,LOCATION_MZONE,0,nil,tp)
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	local sel=Duel.IsPlayerAffectedByEffect(tp,51847220) and Duel.SelectYesNo(tp,aux.Stringid(51847220,0)) and 1 or 0
	Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	local des=sel==1 and aux.Stringid(51847220,2) or aux.Stringid(51847230,3)
	tc:RegisterFlagEffect(51847230,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,des)
	if sel==1 then tc:RegisterFlagEffect(51847220,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(0,fid)
	e1:SetLabelObject(tc)
	e1:SetCondition(c51847230.retcon)
	e1:SetOperation(c51847230.retop)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	e:GetLabelObject():SetLabelObject(tc)
	e:GetLabelObject():SetLabel(sel,fid)
end
function c51847230.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)) then return false end
	local ct,fid=e:GetLabel()
	if ct==0 then e:SetLabel(1,fid) return false end
	if e:GetLabelObject():GetFlagEffectLabel(51847230)~=fid then e:Reset() return false else return true end
end
function c51847230.retop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():ResetFlagEffect(51847230)
	Duel.ReturnToField(e:GetLabelObject())
end
function c51847230.spfilter(c,e,tp,sec)
	return c:IsSetCard(0xa68) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (sec or Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c51847230.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sec=not (Duel.GetTurnPlayer()~=tp and e:GetHandler():IsLocation(LOCATION_HAND))-- and e:GetLabelObject():GetLabel()==51847230--skip extra check
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,e:GetHandler(),TYPE_SPELL):Filter(Card.IsAbleToRemove,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c51847230.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sec) and #g>=3 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c51847230.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local _,fid=e:GetLabel()
	if tc and tc:GetFlagEffectLabel(51847220)==fid then tc:ResetFlagEffect(51847220) Duel.ReturnToField(tc) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil):Filter(Card.IsType,nil,0x2)
	if #g<3 then return end
	if #g>3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=g:Select(tp,3,3,nil)
	end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup()
		local fid=og:GetFirst():GetFieldID()
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(51847230,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(51847230,2))
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCondition(c51847230.rthcon)
		e1:SetOperation(c51847230.rthop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c51847230.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,false):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c51847230.retfilter(c,fid)
	return c:GetFlagEffectLabel(51847230)==fid
end
function c51847230.rthcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c51847230.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c51847230.rthop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c51847230.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	for tc in aux.Next(sg) do
		Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
	end
end
function c51847230.thcfilter(c)
	return c:IsSetCard(0xa68) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function c51847230.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c51847230.thcfilter,1,nil)
end
function c51847230.hintcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--hint
	local ct=Duel.GetFlagEffectLabel(tp,51847230) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,51847230,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,51847230,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+51847250,e,0,0,0,0)
end
function c51847230.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c51847230.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,c)
	end
end
