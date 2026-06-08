--『旁观者』让·巴尔
function c9911442.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c9911442.mfilter,nil,2,99)
	c:EnableReviveLimit()
	--effect protect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9911442)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9911442.effcost)
	e1:SetTarget(c9911442.efftg)
	e1:SetOperation(c9911442.effop)
	c:RegisterEffect(e1)
end
function c9911442.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,6) or c:IsXyzLevel(xyzc,9) or c:IsXyzLevel(xyzc,12)
end
function c9911442.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9911442.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c9911442.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc~=c and c9911442.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911442.xfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9911442.xfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c)
end
function c9911442.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local fid=c:GetFieldID()
	if c:IsRelateToChain() then
		c:RegisterFlagEffect(9911442,RESET_PHASE+PHASE_END,EFFECT_FLAG_SET_AVAILABLE,1,fid)
		c:RegisterFlagEffect(9911443,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(9911442,0))
	end
	if tc:IsRelateToChain() and tc:IsLocation(LOCATION_MZONE) then
		tc:RegisterFlagEffect(9911442,RESET_PHASE+PHASE_END,EFFECT_FLAG_SET_AVAILABLE,1,fid)
		tc:RegisterFlagEffect(9911443,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(9911442,0))
	end
	if c:IsRelateToChain() and c:IsFaceup() and tc:IsRelateToChain() and tc:IsFaceupEx() then
		Duel.MajesticCopy(c,tc)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetLabel(fid)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c9911442.efilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
end
function c9911442.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	local res=tc:GetFlagEffectLabel(9911442)==e:GetLabel()
	if tc:GetFlagEffectLabel(9911443)~=e:GetLabel() then tc:ResetFlagEffect(9911442) end
	return p==tp and te:IsActiveType(TYPE_MONSTER) and loc&LOCATION_MZONE>0 and res
end
