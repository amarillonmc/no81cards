local m=82204226
local cm=_G["c"..m]
cm.name="null"
function cm.initial_effect(c)
	--splimit  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(cm.splimit)  
	c:RegisterEffect(e0)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)   
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)  
	--to hand
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,2))  
	e4:SetCategory(CATEGORY_TOHAND)  
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)  
	e4:SetCountLimit(1,m)
	e4:SetCost(aux.bfgcost)  
	e4:SetTarget(cm.thtg)  
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)
end
cm.SetCard_01_YeRen=true 
function cm.splimit(e,se,sp,st)  
	return se:IsHasType(EFFECT_TYPE_ACTIONS)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsDiscardable() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)  
end  
 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end  
 
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end  
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.ConfirmDecktop(tp,1)  
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if tc:IsType(TYPE_MONSTER) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then  
		Duel.DisableShuffleCheck()  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else  
		Duel.ShuffleDeck(tp)
	end  
end
 
function cm.thfilter(c)  
	return c.SetCard_01_YeRen and not c:IsCode(m) and c:IsAbleToHand()
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
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