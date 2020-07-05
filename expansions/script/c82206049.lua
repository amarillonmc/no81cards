local m=82206049
local cm=_G["c"..m]
cm.name="植占师29-三叶"
function cm.initial_effect(c)
	--fusion material  
	c:EnableReviveLimit() 
	aux.AddFusionProcFunRep(c,cm.ffilter,3,true) 
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)  
	--spsummon condition  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e1:SetValue(cm.splimit)  
	c:RegisterEffect(e1)  
	--triple attack  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_EXTRA_ATTACK)  
	e2:SetValue(2)  
	c:RegisterEffect(e2)  
	--remove  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_TODECK)  
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.remcon)  
	e3:SetTarget(cm.remtg)  
	e3:SetOperation(cm.remop)  
	c:RegisterEffect(e3)  
	--to hand  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,4))  
	e4:SetCategory(CATEGORY_TOHAND)  
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)  
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)  
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e4:SetCountLimit(1,82216049)  
	e4:SetCondition(cm.thcon)  
	e4:SetTarget(cm.thtg)  
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)  
end
function cm.ffilter(c,fc,sub,mg,sg)  
	return c:IsRace(RACE_PLANT) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))  
end  
function cm.splimit(e,se,sp,st)  
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA  
end  
function cm.remcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()==1-tp and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,3,nil,RACE_PLANT)  
end  
function cm.remtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,0x1e,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0x1e)  
end  
function cm.remop(e,tp,eg,ep,ev,re,r,rp)  
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)  
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)  
	local g3=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)  
	local sg=Group.CreateGroup()  
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
		local sg1=g1:Select(tp,1,1,nil)  
		Duel.HintSelection(sg1)  
		sg:Merge(sg1)  
	end  
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
		local sg2=g2:Select(tp,1,1,nil)  
		Duel.HintSelection(sg2)  
		sg:Merge(sg2)  
	end  
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(m,3))) then   
		local sg3=g3:RandomSelect(tp,1)  
		sg:Merge(sg3)  
	end  
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)  
end  
function cm.thfilter(c)  
	return c:IsSetCard(0x29d) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.thfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  