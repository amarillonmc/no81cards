--授秽者的传教士
local m=33332203
local cm=_G["c"..m]
local flag=true
function c33332203.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(cm.spcon)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
--
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
--
function cm.filter1(c)
	return c:IsFaceup()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
--
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(33332200)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(3)
			tc:RegisterEffect(e2)
			if Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.Recover(1-tp,500,REASON_EFFECT)
			end
		end
end
--

function cm.spfilter(c)
	return c:IsFaceup() and c:IsCode(33332200) 
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(cm.spfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(cm.retg)
	e1:SetValue(cm.reval)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e2:SetCondition(cm.recon)
	e2:SetValue(LOCATION_DECK)
	c:RegisterEffect(e2,true)
end
function cm.recon(e)
	return flag
end
function cm.repfilter(c,e,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetLeaveFieldDest()==1
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then
		return cm.repfilter(c,e,tp) and eg:IsContains(c)
	end
	flag=false
	Duel.SendtoDeck(c,1-tp,0,REASON_EFFECT)
	flag=true
	return true
end
function cm.reval(e,c)
	return c == e:GetHandler()
end