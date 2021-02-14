local m=15000337
local cm=_G["c"..m]
cm.name="虚内核 帝纳拜因·登神"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--update baseATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.atkcon)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
	--back
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCountLimit(1,m)
	e5:SetCost(cm.tdcost)
	e5:SetTarget(cm.tdtg)
	e5:SetOperation(cm.tdop)
	c:RegisterEffect(e5)
	--battle  
	local e6=Effect.CreateEffect(c)  
	e6:SetType(EFFECT_TYPE_SINGLE)  
	e6:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)  
	e6:SetValue(1)  
	c:RegisterEffect(e6)  
	local e7=Effect.CreateEffect(c)  
	e7:SetType(EFFECT_TYPE_SINGLE)  
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e7:SetValue(1)  
	c:RegisterEffect(e7)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.sprfilter(c,sc)
	return c:IsFaceup() and c:IsSetCard(0xf39) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.sprfilter1,c:GetControler(),LOCATION_ONFIELD,0,1,c,sc,c)
end
function cm.sprfilter1(c,sc,tc)
	local sg=Group.FromCards(c,tc)
	return c:IsFaceup() and c:IsSetCard(0xf39) and c:IsAbleToGraveAsCost() and Duel.GetLocationCountFromEx(c:GetControler(),c:GetControler(),sg,sc)>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.sprfilter,tp,LOCATION_ONFIELD,0,1,nil,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cm.sprfilter,tp,LOCATION_ONFIELD,0,1,1,nil,c)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,cm.sprfilter1,tp,LOCATION_ONFIELD,0,1,1,tc,c,tc)
	Group.Merge(g1,g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function cm.cfilter(c)
	return c:IsSetCard(0xf39) and c:IsType(TYPE_MONSTER)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_MZONE) and eg:IsExists(cm.cfilter,1,nil)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetBaseAttack()
	local ag=eg:Filter(cm.cfilter,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(atk+ag:GetCount()*500)
	c:RegisterEffect(e1)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandler():GetControler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function cm.costfilter(c)  
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xf39) and c:IsType(TYPE_MONSTER)
end
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=e:GetHandler():GetControler()
	e:SetLabel(p)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,p,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(p,cm.costfilter,p,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local p=e:GetLabel()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-p) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,p,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectTarget(p,Card.IsAbleToDeck,p,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end