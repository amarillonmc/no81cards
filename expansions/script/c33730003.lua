-- 键★等 －灵魂伴侣 / K.E.Y Etc. Anima Gemella
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x460) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,tp,{c:GetCode()},c:GetAttribute(),c:GetAttack(),c:GetDefense())
end
function s.filter2(c,tp,codes,attr,atk,def)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x460) and c:IsAbleToHand() and not c:IsCode(table.unpack(codes)) and (c:IsAttribute(attr) or c:GetAttack()==atk or c:GetDefense()==def)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33730009,0,TYPES_TOKEN_MONSTER,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute(),POS_FACEUP,1-tp)
end
function s.rmfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc,tp) end
	if chk==0 then
		return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp,{tc:GetCode()},tc:GetAttribute(),tc:GetAttack(),tc:GetDefense())
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:Filter(Card.IsLocation,nil,LOCATION_HAND):FilterCount(Card.IsControler,nil,tp)>0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsControler,nil,tp)
		Duel.ConfirmCards(1-tp,og)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,33730009,0,TYPES_TOKEN_MONSTER,tc:GetAttack(),tc:GetDefense(),tc:GetLevel(),tc:GetRace(),tc:GetAttribute(),POS_FACEUP,1-tp) then return end
		local token=Duel.CreateToken(tp,33730009)
		local oc=og:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(oc:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(oc:GetDefense())
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(oc:GetLevel())
		token:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(oc:GetRace())
		token:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(oc:GetAttribute())
		token:RegisterEffect(e5)
		if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_DECK,1,nil,tp) and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=Duel.SelectMatchingCard(1-tp,s.rmfilter,tp,0,LOCATION_HAND+LOCATION_DECK,1,1,token,tp)
			if #rg>0 then
				Duel.BreakEffect()
				if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 and rg:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)>0 and rg:GetFirst():IsType(TYPE_EFFECT) then
					local code=rg:GetFirst():GetOriginalCode()
					token:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
				end
			end
		end
		Duel.SpecialSummonComplete()
	end
end