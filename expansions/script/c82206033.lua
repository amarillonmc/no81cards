local m=82206033
local cm=_G["c"..m]
cm.name="植占师13-拘束"
function cm.initial_effect(c)
	--equip  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_EQUIP)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)  
	e1:SetTarget(cm.eqtg)  
	e1:SetOperation(cm.eqop)  
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,m)  
	e2:SetCost(cm.spcost)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)  
end
function cm.filter(c)  
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)  
end  
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0  
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)  
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())  
end  
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end  
	local tc=Duel.GetFirstTarget()  
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then  
		Duel.SendtoGrave(c,REASON_EFFECT)  
		return  
	end  
	Duel.Equip(tp,c,tc,true)  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_EQUIP_LIMIT)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
	e1:SetValue(cm.eqlimit)  
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_EQUIP)  
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)  
	e2:SetValue(0)  
	e2:SetReset(RESET_EVENT+0x1fe0000)  
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_EQUIP)  
	e4:SetCode(EFFECT_DISABLE)  
	c:RegisterEffect(e4) 
end  
function cm.eqlimit(e,c)  
	return c:IsRace(RACE_ZOMBIE)  
end  
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end  
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)  
end
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x129d) and c:IsLevelBelow(4) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  