--蝶梦-「萦」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401024.initial_effect(c)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71401001,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c71401024.con1)
	e1:SetCountLimit(1,71401024)
	e1:SetCost(yume.ButterflyLimitCost)
	e1:SetTarget(yume.ButterflyPlaceTg)
	e1:SetOperation(yume.ButterflySpellOp)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401024,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_DECK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,71401024)
	e2:SetCondition(c71401024.con2)
	e2:SetTarget(c71401024.tg2)
	e2:SetOperation(c71401024.op2)
	c:RegisterEffect(e2)
	yume.ButterflyCounter()
end
function c71401024.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function c71401024.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA)
end
function c71401024.filter2a(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c71401024.filter2b(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsFacedown()
end
function c71401024.filter2c(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c71401024.filter2d(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_SPELLCASTER) and c:IsSynchroSummonable(nil)
end
function c71401024.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71401024.filter2a,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	--[[
	local g=Duel.GetMatchingGroup(tp,c71401024.filter2a,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	--]]
end
function c71401024.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c71401024.filter2a,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		local cg=g:Filter(c71401024.filter2b,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		if cg:GetCount()>0 then Duel.ConfirmCards(1-tp,cg) end
		local mg=Duel.GetMatchingGroup(c71401024.filter2d,tp,LOCATION_EXTRA,0,nil)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND+LOCATION_EXTRA)
			and Duel.IsExistingMatchingCard(c71401024.filter2c,tp,LOCATION_MZONE,0,1,nil)
			and mg:GetCount()>0	and Duel.SelectYesNo(tp,aux.Stringid(71401024,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
		end
	end
end