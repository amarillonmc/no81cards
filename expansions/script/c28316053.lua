--闪耀的支援者 七草叶月
function c28316053.initial_effect(c)
	--support
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c28316053.cost)
	e1:SetTarget(c28316053.sutg)
	e1:SetOperation(c28316053.suop)
	c:RegisterEffect(e1)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,28316053)
	e5:SetTarget(c28316053.reptg)
	e5:SetValue(c28316053.repval)
	e5:SetOperation(c28316053.repop)
	c:RegisterEffect(e5)
end
function c28316053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c28316053.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x283) and c:GetOriginalLevel()<=4 and c:GetOriginalLevel()>0
end
function c28316053.sutg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c28316053.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28316053.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c28316053.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local phase=Duel.GetCurrentPhase()
	local ops,opval={},{}
	ops[1]=aux.Stringid(28316053,0)
	opval[1]=0
	if phase~=PHASE_DAMAGE then
		ops[2]=aux.Stringid(28316053,1)
		opval[2]=1
		ops[3]=aux.Stringid(28316053,2)
		opval[3]=2
		ops[4]=aux.Stringid(28316053,3)
		opval[4]=3
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
end
function c28316053.suop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local sel=e:GetLabel()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and sel==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	elseif tc:IsFaceup() and tc:IsRelateToEffect(e) and sel==1 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e4)
	elseif tc:IsFaceup() and tc:IsRelateToEffect(e) and sel==2 then
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_INACTIVATE)
		e5:SetLabel(1)
		e5:SetValue(c28316053.effectfilter)
		Duel.RegisterEffect(e5,tp)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_CANNOT_DISEFFECT)
		e6:SetLabel(2)
		Duel.RegisterEffect(e6,tp)
		e5:SetLabelObject(e6)
		e6:SetLabelObject(tc)
	elseif tc:IsFaceup() and tc:IsRelateToEffect(e) and sel==3 then
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_DIRECT_ATTACK)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7)
	end
end
function c28316053.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local label=e:GetLabel()
	local tc
	if label==1 then
		tc=e:GetLabelObject():GetLabelObject()
	else
		tc=e:GetLabelObject()
	end
	return tc and tc==te:GetHandler()
end
function c28316053.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x283) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c28316053.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c28316053.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c28316053.repval(e,c)
	return c28316053.repfilter(c,e:GetHandlerPlayer())
end
function c28316053.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
