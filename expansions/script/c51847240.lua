--辉光序曲「Judgement」-"守护帷幕外的世界!"
function c51847240.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCost(c51847240.excost)
	e0:SetDescription(aux.Stringid(51847240,0))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c51847240.condition)
	e1:SetTarget(c51847240.target)
	e1:SetOperation(c51847240.activate)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51847240,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,51847240)
	e2:SetCondition(c51847240.thcon)
	e2:SetCost(c51847240.hintcost)
	e2:SetTarget(c51847240.thtg)
	e2:SetOperation(c51847240.thop)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
end
function c51847240.excfilter(c)
	return c:IsSetCard(0xa68) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c51847240.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	--e:SetLabel(51847240)
	if chk==0 then return Duel.IsExistingMatchingCard(c51847240.excfilter,tp,LOCATION_MZONE,0,1,nil) end
	local fid=e:GetHandler():GetFieldID()
	local g=Duel.GetMatchingGroup(c51847240.excfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	local sel=Duel.IsPlayerAffectedByEffect(tp,51847220) and Duel.SelectYesNo(tp,aux.Stringid(51847220,0)) and 1 or 0
	Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	local des=sel==1 and aux.Stringid(51847220,2) or aux.Stringid(51847240,3)
	tc:RegisterFlagEffect(51847240,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,des)
	if sel==1 then tc:RegisterFlagEffect(51847220,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(0,fid)
	e1:SetLabelObject(tc)
	e1:SetCondition(c51847240.retcon)
	e1:SetOperation(c51847240.retop)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	e:GetLabelObject():SetLabelObject(tc)
	e:GetLabelObject():SetLabel(sel,fid)
end
function c51847240.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)) then return false end
	local ct,fid=e:GetLabel()
	if ct==0 then e:SetLabel(1,fid) return false end
	if e:GetLabelObject():GetFlagEffectLabel(51847240)~=fid then e:Reset() return false else return true end
end
function c51847240.retop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():ResetFlagEffect(51847240)
	Duel.ReturnToField(e:GetLabelObject())
end
function c51847240.cfilter(c)
	return c:IsSetCard(0xa68) and c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c51847240.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and Duel.IsExistingMatchingCard(c51847240.cfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,1,nil)
end
function c51847240.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local g=rc:GetColumnGroup()
	g:AddCard(rc)
	if chk==0 then return rc:IsRelateToChain(ev) and g:IsExists(Card.IsAbleToRemove,1,nil) end
end
function c51847240.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local _,fid=e:GetLabel()
	if tc and tc:GetFlagEffectLabel(51847220)==fid then tc:ResetFlagEffect(51847220) Duel.ReturnToField(tc) end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c51847240.repop)
end
function c51847240.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain(ev) then return end
	local g=c:GetColumnGroup()
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c51847240.thcfilter(c)
	return c:IsSetCard(0xa68) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function c51847240.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c51847240.thcfilter,1,nil)
end
function c51847240.hintcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--hint
	local ct=Duel.GetFlagEffectLabel(tp,51847240) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,51847240,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,51847240,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+51847250,e,0,0,0,0)
end
function c51847240.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c51847240.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,c)
	end
end
