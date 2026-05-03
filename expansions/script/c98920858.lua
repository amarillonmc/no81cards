--劫火之亚龙 幽鬼亚龙
--劫火之亚龙 幽鬼亚龙
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,35705817)
	
	--①：特召并生成衍生物
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,35622740)
	e2:SetCondition(c98920858.thcon)
	e2:SetTarget(c98920858.thtg)
	e2:SetOperation(c98920858.thop)
	c:RegisterEffect(e2)
end

--效果①相关
function s.cfilter(c)
	return c:IsCode(35705817) and not c:IsPublic()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function s.tgfilter(c)
	return c:IsFaceup() and c:GetOriginalLevel()>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,8198621,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			--攻击力变成0
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			--特召衍生物
			local oatk=tc:GetBaseAttack()
			local olvl=tc:GetOriginalLevel()
			if oatk<0 then oatk=0 end
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,8198621,0,TYPES_TOKEN_MONSTER,oatk,0,olvl,RACE_ZOMBIE,ATTRIBUTE_DARK) then
				local token=Duel.CreateToken(tp,8198621)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_BASE_ATTACK)
				e2:SetValue(oatk)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CHANGE_LEVEL)
				e3:SetValue(olvl)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e3)
				Duel.SpecialSummonComplete()
			end
		end
	end
end

--效果②相关
function s.thfilter(c)
	return (c:IsCode(35705817) or aux.IsCodeListed(c,35705817) or c:IsCode(61103515,99370594)) and not c:IsCode(id) and c:IsAbleToHand()
end
function c98920858.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) and r==REASON_FUSION
end
function c98920858.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920858.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c98920858.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920858.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end