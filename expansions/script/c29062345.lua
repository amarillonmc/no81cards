--方舟骑士团-送葬人·圣约
local m=29062345
local cm=_G["c"..m]
cm.named_with_Arknight=1
function cm.initial_effect(c)
	aux.AddMaterialCodeList(c,29055096)
	--synchro summon
	aux.AddSynchroMixProcedure(c,cm.syncheck1,nil,nil,cm.sfilter,1,99)
	c:EnableReviveLimit()   
	--add counter self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.addtg)
	e1:SetOperation(cm.addop)
	c:RegisterEffect(e1)   
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.addocon)
	e2:SetTarget(cm.addotg)
	e2:SetOperation(cm.addoop)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(cm.descost)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
end
function cm.sfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function cm.syncheck1(c)
	return c:IsCode(29055096)
end
function cm.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x17af,4) and e:GetHandler():GetCounter(0x17af)==0 end
end
function cm.addop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x17af,4)
	end
end
function cm.addocon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end
function cm.addcheck(c)
	return c:IsOnField() and c:IsFaceup() and c:IsCanAddCounter(0x17af,1) and not c:IsStatus(STATUS_LEAVE_CONFIRMED) 
end
function cm.addotg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsControler(1-tp) end
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x17af,1,REASON_EFFECT) and Duel.IsExistingTarget(cm.addcheck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,cm.addcheck,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function cm.addoop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsCanRemoveCounter(tp,0x17af,1,REASON_EFFECT) then
		c:RemoveCounter(tp,0x17af,1,REASON_EFFECT)
		Duel.RaiseEvent(c,EVENT_REMOVE_COUNTER+0x17af,e,REASON_EFFECT,tp,tp,1)
		Duel.RaiseSingleEvent(c,EVENT_REMOVE_COUNTER+0x17af,e,REASON_EFFECT,tp,tp,1)
		if tc:IsRelateToEffect(e) then
			tc:AddCounter(0x17af,1)
		end
	end
end
function cm.descheck(c)
	return c:GetCounter(0x17af)>0
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x17af)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x17af,1,REASON_COST) end
	local ct2=c:GetCounter(0x17af)
	c:RemoveCounter(tp,0x17af,ct2,REASON_COST)
	Duel.RaiseEvent(c,EVENT_REMOVE_COUNTER+0x17af,e,REASON_EFFECT,tp,tp,ct2)
	Duel.RaiseSingleEvent(c,EVENT_REMOVE_COUNTER+0x17af,e,REASON_EFFECT,tp,tp,ct2)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.descheck,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(cm.descheck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.descheck,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end