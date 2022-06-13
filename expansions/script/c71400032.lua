--蚀异梦境-幻想植物回路
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400032.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--rece
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetTarget(c71400032.tg1)
	e1:SetValue(RACE_PLANT)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400032,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c71400032.con2)
	e2:SetTarget(c71400032.tg2)
	e2:SetOperation(c71400032.op2)
	c:RegisterEffect(e2)
	--self to deck & activate field
	yume.AddYumeFieldGlobal(c,71400032,2)
end
function c71400032.tg1(e,c)
	return not c71400032.filter2b(c)
end
function c71400032.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(c71400032.filter2con,tp,LOCATION_MZONE,LOCATION_MZONE,4,nil) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c71400032.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c71400032.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71400032.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,c71400032.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c71400032.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c71400032.rcon)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		tc:RegisterEffect(e2)
		local g=Duel.GetMatchingGroup(c71400032.filter2a,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if Duel.IsExistingMatchingCard(c71400032.filter2b,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400032,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c71400032.filter2(c)
	return c:IsRace(RACE_PLANT) and aux.NegateMonsterFilter(c)
end
function c71400032.filter2con(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function c71400032.filter2a(c)
	return c:IsSetCard(0xd714) and c:IsAbleToHand()
end
function c71400032.filter2b(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c71400032.rcon(e)
	local c=e:GetHandler()
	return e:GetOwner():IsHasCardTarget(c) and c:IsRace(RACE_PLANT)
end