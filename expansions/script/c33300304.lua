--虚网字节妖精
local m=33300304
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.rmcheck(c)
	return c:IsSetCard(0x562) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmcheck,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,tp,0)
end
function cm.adcheck(c)
	return c:IsSetCard(0x562) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.operation(e,tp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,cm.rmcheck,tp,LOCATION_DECK,0,1,1,nil)
	if rg:GetCount()>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.adcheck,tp,LOCATION_GRAVE,0,1,nil) and c:IsAbleToGrave() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.SendtoGrave(c,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,cm.adcheck,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cm.IsLinkZoneOver(count)
	local flag=0
	for i=0,4 do
		if (Duel.GetLinkedZone(0)&((2^i)<<0))~=0 then
			flag=flag+1
		elseif (Duel.GetLinkedZone(1)&((2^i)<<0))~=0 then
			flag=flag+1
		end
	end
	return flag>=count
end  
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and cm.IsLinkZoneOver(3)
end
function cm.costcheck(c,tp)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x562) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costcheck,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,cm.costcheck,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function cm.rmcheck(c)
	return c:IsSetCard(0x562) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function cm.operation2(e,tp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and cm.IsLinkZoneOver(3) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)	
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end