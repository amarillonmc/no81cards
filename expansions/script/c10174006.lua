--大帝 达·格雷法
function c10174006.initial_effect(c)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10174006.discon)
	e1:SetOperation(c10174006.disop)
	c:RegisterEffect(e1)  
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10174006,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c10174006.ctcost)
	e2:SetTarget(c10174006.cttg)
	e2:SetOperation(c10174006.ctop)
	c:RegisterEffect(e2)  
end
function c10174006.rfilter(c)
	return Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c10174006.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c10174006.rfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c10174006.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c10174006.cfilter(c)
	return c:IsAbleToChangeControler() and c:GetSequence()<5
end
function c10174006.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10174006.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10174006.cfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c10174006.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c10174006.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local tct=1
	if Duel.GetTurnPlayer()~=tp then tct=2
	elseif Duel.GetCurrentPhase()==PHASE_END then tct=3 end
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
	   local seq=tc:GetSequence()+16
	   if Duel.GetControl(tc,tp,PHASE_END,tct) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CONTROL)
			e1:SetLabel(seq)
			e1:SetLabelObject(tc)
			e1:SetCondition(c10174006.zcon)
			e1:SetOperation(c10174006.zop) 
			e1:SetOwnerPlayer(tp)
			tc:RegisterEffect(e1,true)
	   end
	end
end
function c10174006.zcon(e)
	return e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function c10174006.zop(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end
function c10174006.discon(e,tp,eg,ep,ev,re,r,rp)
	local ex=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	return rp==1-tp and (re:IsHasCategory(CATEGORY_DESTROY+CATEGORY_REMOVE) or ex)
end
function c10174006.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10174006)
	Duel.NegateEffect(ev)
end
