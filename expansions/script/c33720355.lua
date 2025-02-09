--[[
深夜作业
Twilight Homework
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:Activation()
	--[[During the End Phase: The turn player applies these effects in sequence (skip over any that do not apply).
	● If the number of cards in their Deck is a prime number, they Special Summon 1 "Work Token" (Fiend/DARK/Level 4/ATK 1500/DEF 1500).
	● If the number of cards in their Extra Deck falls in the Fibonacci sequence, they draw 1 card.
	● If their LP cannot be divided by 50, they gain LP equal to half their opponent's LP.
	● If they control monsters whose combined Level/Rank/Link Rating can be divided by 13, they return all cards their opponent controls to the hand.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_TOKEN|CATEGORY_DRAW|CATEGORY_RECOVER|CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetRange(LOCATION_FZONE)
	e1:OPT()
	e1:SetFunctions(s.condition,nil,s.target,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.isPrime(n)
	if n==2 or n==3 then return true end
    if n<=1 or n>256 or n%2==0 then return false end
	
    local f=3
    while f*f<=n do
        if n%f==0 then
            return false
        end
        f=f+2
    end
    return true
end
function s.isFibonacci(n)
	if n<1 or n>256 then return false end
	if n<=3 then return true end
	local a,b=3,5
	while b<=n do
		if b==n then
			return true
		end
		a, b = b, a+ b
	end
	return false
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct1,ct2,ct3,ct4 = Duel.GetDeckCount(tp),Duel.GetExtraDeckCount(tp),Duel.GetLP(tp),Duel.Group(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetRatingAuto)
	local isPrime, isFibonacci, checkLP, checkStars  = s.isPrime(ct1), s.isFibonacci(ct2), ct3%50~=0, ct4>0 and ct4%13==0
	local g=Duel.Group(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	
	Duel.SetConditionalOperationInfo(isPrime,0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetConditionalOperationInfo(isPrime,0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetConditionalOperationInfo(isFibonacci,0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetConditionalOperationInfo(checkLP,0,CATEGORY_RECOVER,nil,0,tp,math.floor(Duel.GetLP(1-tp)/2 + 0.5))
	Duel.SetConditionalOperationInfo(checkStars,0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local brk=false
	if s.isPrime(Duel.GetDeckCount(tp)) and Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_WORK,0,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,TOKEN_WORK)
		brk=Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0
	end
	if s.isFibonacci(Duel.GetExtraDeckCount(tp)) then
		if brk then Duel.BreakEffect() end
		brk=Duel.Draw(tp,1,REASON_EFFECT)>0
	end
	if Duel.GetLP(tp)%50~=0 then
		if brk then Duel.BreakEffect() end
		local val=math.floor(Duel.GetLP(1-tp)/2 + 0.5)
		brk=Duel.Recover(tp,val,REASON_EFFECT)>0
	end
	
	local ct=Duel.Group(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetRatingAuto)
	if ct>0 and ct%13==0 then
		local g=Duel.Group(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
		if #g>0 then
			if brk then Duel.BreakEffect() end
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end