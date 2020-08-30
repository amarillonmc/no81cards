local m=82224056
local cm=_G["c"..m]
cm.name="萤火鼠"
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SUMMON_SUCCESS)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.tktg)  
	e1:SetOperation(cm.tkop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e2)  
	--to extra  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1)) 
	e3:SetCountLimit(1,m)
	e3:SetCategory(CATEGORY_TOEXTRA)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_GRAVE)  
	e3:SetCost(aux.bfgcost)  
	e3:SetTarget(cm.tdtg)  
	e3:SetOperation(cm.tdop)  
	c:RegisterEffect(e3) 
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)  
end  
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0  
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,82224057,0,0x4011,0,0,1,RACE_PSYCHO,ATTRIBUTE_LIGHT) then return end  
	local token=Duel.CreateToken(tp,82224057)  
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)  
end  
function cm.tdfilter(c)  
	return c:IsAbleToDeck() or c:IsAbleToExtra()  
end  
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)  
end  
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)  
	end  
end  