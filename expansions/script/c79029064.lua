--啸岚寒域 失温爆发
local m=79029064
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x115),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WATER),true)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m) 
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Effect 2  
	local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,m+100) 
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--Effect 3 
	--Effect 4 
	--Effect 5 
end
cm.named_with_KarlanTrade=true 
--Effect 1
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetFieldGroup(1-tp,LOCATION_MZONE,0):GetCount()>0
	local b2=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)>0
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	e:SetLabel(s)
	local g=nil
	if s==0 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)
	end
	if s==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	if e:GetLabel()==0 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)
	end
	if e:GetLabel()==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e),TYPE_SPELL+TYPE_TRAP)
	end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--Effect 2
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp)
end
function cm.thfilter(c)
	return c.named_with_KarlanTrade and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Effect 3 
--Effect 4 
--Effect 5   
