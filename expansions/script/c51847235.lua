--辉光序曲「The Chariot」-"于光芒中集结吧!"
function c51847235.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCost(c51847235.excost)
	e0:SetDescription(aux.Stringid(51847235,0))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c51847235.target)
	e1:SetOperation(c51847235.activate)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51847235,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,51847235)
	e2:SetCondition(c51847235.thcon)
	e2:SetCost(c51847235.hintcost)
	e2:SetTarget(c51847235.thtg)
	e2:SetOperation(c51847235.thop)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
end
function c51847235.excfilter(c)
	return c:IsSetCard(0xa68) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c51847235.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(51847235)
	if chk==0 then return Duel.IsExistingMatchingCard(c51847235.excfilter,tp,LOCATION_MZONE,0,1,nil) end
	local fid=e:GetHandler():GetFieldID()
	local g=Duel.GetMatchingGroup(c51847235.excfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	local sel=Duel.IsPlayerAffectedByEffect(tp,51847220) and Duel.SelectYesNo(tp,aux.Stringid(51847220,0)) and 1 or 0
	Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	local des=sel==1 and aux.Stringid(51847220,2) or aux.Stringid(51847235,3)
	tc:RegisterFlagEffect(51847235,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,des)
	if sel==1 then tc:RegisterFlagEffect(51847220,RESET_EVENT+RESETS_STANDARD,0,1,fid) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(0,fid)
	e1:SetLabelObject(tc)
	e1:SetCondition(c51847235.retcon)
	e1:SetOperation(c51847235.retop)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	e:GetLabelObject():SetLabelObject(tc)
	e:GetLabelObject():SetLabel(sel,fid)
end
function c51847235.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)) then return false end
	local ct,fid=e:GetLabel()
	if ct==0 then e:SetLabel(1,fid) return false end
	if e:GetLabelObject():GetFlagEffectLabel(51847235)~=fid then e:Reset() return false else return true end
end
function c51847235.retop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():ResetFlagEffect(51847235)
	Duel.ReturnToField(e:GetLabelObject())
end
function c51847235.codefilter(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function c51847235.thfilter(c,tp,code)
	return c:IsSetCard(0xa68) and c:IsAbleToHand() and not Duel.IsExistingMatchingCard(c51847235.codefilter,tp,LOCATION_REMOVED,0,1,nil,c:GetCode())
end
function c51847235.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51847235.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c51847235.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local _,fid=e:GetLabel()
	if tc and tc:GetFlagEffectLabel(51847220)==fid then tc:ResetFlagEffect(51847220) Duel.ReturnToField(tc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c51847235.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		--Duel.ConfirmCards(1-tp,tc)
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(51847235,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
			if #rg==0 then return end
			Duel.HintSelection(rg)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c51847235.thcfilter(c)
	return c:IsSetCard(0xa68) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function c51847235.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c51847235.thcfilter,1,nil)
end
function c51847235.hintcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--hint
	local ct=Duel.GetFlagEffectLabel(tp,51847235) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,51847235,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,51847235,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+51847250,e,0,0,0,0)
end
function c51847235.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c51847235.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,c)
	end
end
