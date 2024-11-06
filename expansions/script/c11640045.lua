--天龙座的光诞
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)	
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3224) and c:IsLevelAbove(1)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLevelAbove(1) then
		local down=tc:IsLevelAbove(3)
		local op=aux.SelectFromOptions(tp,
			{true,aux.Stringid(id,3),2},
			{down,aux.Stringid(id,4),-2})
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(op)
		tc:RegisterEffect(e1)
		if  c:IsRelateToEffect(e) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
--
function s.filter1(c,tp)
	return  c:IsSetCard(0x3224) and c:IsLevelAbove(1) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,c,tp)
end
function s.filter2(c,tp)
	return  c:IsSetCard(0x3224) and c:IsLevelAbove(1) and c:IsType(TYPE_MONSTER)
		and ((c:IsReleasableByEffect() and not c:IsLocation(LOCATION_GRAVE)) or (c:IsAbleToRemove() and c:IsLocation(LOCATION_GRAVE)  ))
end
function s.filter3(c,e,tp,lv)
	local op1=(c:IsSetCard(0x3224) and c:IsLevel(lv) and c:IsLocation(LOCATION_DECK))
	local op2=(c:IsLevelBelow(lv) and c:IsAttribute(ATTRIBUTE_LIGHT)  and not c:IsLocation(LOCATION_DECK))
	return  (op1 or op2 )   and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	local sc=g:GetFirst()
	local lv1=sc:GetLevel()
	local tg=Group.FromCards()  
	Duel.ConfirmCards(1-tp,sc)
	local lv2=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local rg=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,99,sc,tp)
	for tc in aux.Next(rg) do
		if tc:IsLocation(LOCATION_GRAVE) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		else
			Duel.Release(tc,REASON_EFFECT)
		end
		tg:AddCard(tc)
		lv2=lv2+tc:GetLevel()
	end  
	local ld=math.abs(lv1-lv2)  
	if Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,tg,e,tp,ld) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter3),tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,1,tg,e,tp,ld)
		if g2:GetCount()>0 then
			local tc2=g2:GetFirst()
			tc2:SetMaterial(tg)
			Duel.SpecialSummon(tc2,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc2:CompleteProcedure()
		end  
	end
end