--Re_SURGUM 影夜与残心
local m=60002046
local cm=_G["c"..m]
cm.name="Re:SURGUM 影夜与残心"
function cm.initial_effect(c)
	--Activate from deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(cm.oper)
	e2:SetCountLimit(1,m)
	c:RegisterEffect(e2)   
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.oper(e,tp,eg,ep,ev,re,r,rp)
	c=e:GetHandler()
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
	Duel.SendtoGrave(fc,REASON_RULE)
	Duel.BreakEffect()
	end
	Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)  
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x62d) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end