--授秽者的赞颂人
local m=33332206
local cm=_G["c"..m]
local flag=true
function c33332206.initial_effect(c)
			--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m+1000)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
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
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function cm.tgfilter(c)
	return c:IsSetCard(0x3568) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,0))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,0))
		Duel.SendtoGrave(g,REASON_EFFECT)
		local g2=Duel.GetDecktopGroup(1-tp,1)
		if g2:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,1))
			Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,1))
			Duel.SendtoGrave(g2,REASON_EFFECT)
			Duel.Recover(1-tp,500,REASON_EFFECT)
		end
	end
end

---special Summon
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