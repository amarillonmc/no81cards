local m=82204214
local cm=_G["c"..m]
cm.name="我boki了"
function cm.initial_effect(c)
	aux.AddCodeList(c,82204200) 
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)  
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)  
	--Atk up  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_EQUIP)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetValue(500)  
	c:RegisterEffect(e2)
	--attack all  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_EQUIP)  
	e3:SetCode(EFFECT_ATTACK_ALL)  
	e3:SetValue(1)  
	c:RegisterEffect(e3) 
	--to hand  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TOHAND)  
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e4:SetRange(LOCATION_GRAVE)  
	e4:SetCountLimit(1,82214214)  
	e4:SetCost(aux.bfgcost)  
	e4:SetTarget(cm.thtg)  
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)   
end
function cm.filter(c,e,tp)  
	return c:IsCode(82204200) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Debug.Message("当我第一次看见那幅画时…")
	Debug.Message("怎么说呢…说起来有点下流…")
	Debug.Message("我boki了…")
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then  
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end  
		Duel.Equip(tp,c,tc)  
		--Add Equip limit  
		local e1=Effect.CreateEffect(tc)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetCode(EFFECT_EQUIP_LIMIT)  
		e1:SetValue(cm.eqlimit)  
		e1:SetReset(RESET_EVENT+0x1fe0000)  
		c:RegisterEffect(e1)  
	end  
end  
function cm.eqlimit(e,c)  
	return e:GetOwner()==c  
end  
function cm.thfilter(c)  
	return  (c:IsCode(82204200) or aux.IsCodeListed(c,82204200)) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end  
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