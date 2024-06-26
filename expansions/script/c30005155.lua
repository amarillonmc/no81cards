--沌风机 失协
local m=30005155
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_SYNCHRO),aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),true)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(cm.immunefilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(cm.indes)
	c:RegisterEffect(e2)
	--Effect 2  
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(m,0))
	e13:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetRange(LOCATION_MZONE)
	e13:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e13:SetCountLimit(1)
	e13:SetTarget(cm.todtg)
	e13:SetOperation(cm.todop)
	c:RegisterEffect(e13)
	--Effect 3 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)  
end
--Effect 1
cm.material_type=TYPE_SYNCHRO
function cm.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner() and  te:GetHandler():IsType(TYPE_SYNCHRO)
end
function cm.indes(e,c)
	return  c:IsType(TYPE_SYNCHRO)
end
--Effect 2
function cm.td(c)
	return c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and (c:GetOriginalType()&TYPE_TUNER~=0 or c:IsType(TYPE_TUNER))
end
function cm.todtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.td,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.todop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.td),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if #g>0  then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup():Filter(cm.tk,nil)
		if #og>0 then
			local atk=#og*500
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetValue(-atk)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.tk(c)
	return not c:IsReason(REASON_REDIRECT) and c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
end
--Effect 3 
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:IsAbleToExtra() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if not c:IsRelateToEffect(e)  then return end
	if  Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 
		and c:IsLocation(LOCATION_EXTRA) 
		and #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end

