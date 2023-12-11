--一念之间
function c13090000.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,13090000) 
	e1:SetTarget(c13090000.tktg)
	e1:SetOperation(c13090000.tkop)
	c:RegisterEffect(e1)	
	--
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,23090000)  
	e2:SetCondition(c13090000.xtkcon) 
	e2:SetCost(c13090000.xtkcost)
	e2:SetTarget(c13090000.xtktg)
	e2:SetOperation(c13090000.xtkop)
	c:RegisterEffect(e2)   
end 
function c13090000.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,13090001,nil,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT)) or Duel.IsExistingMatchingCard(tp,c13090000.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c13090000.thfilter(c)
	return c:IsSetCard(0xe08) and c:IsAbleToHand()
end
function c13090000.tkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local op=0
		local off=1
		local ops={}
		local opval={}
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,13090001,nil,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT)
		local b2=Duel.IsExistingMatchingCard(c13090000.thfilter,tp,LOCATION_DECK,0,1,nil) 
		if b1 then
			ops[off]=aux.Stringid(13015711,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(13015711,1)
			opval[off-1]=2
			off=off+1
		end
	local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
	local token=Duel.CreateToken(tp,13090001)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	 elseif opval[op]==2 then
	 local cg=Duel.SelectMatchingCard(tp,c13090000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	 Duel.SendtoHand(cg,nil,REASON_EFFECT)
	 Duel.ConfirmCards(1-tp,cg)
	 end
end
function c13090000.xtkcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSummonLocation(LOCATION_EXTRA) and c:IsRace(RACE_FIEND) end,tp,LOCATION_MZONE,0,1,nil) 
end 
function c13090000.xtkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckOrExtraAsCost() and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToDeckAsCost() end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToDeckAsCost() end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler()) 
	g:AddCard(e:GetHandler()) 
	Duel.SendtoDeck(g,nil,2,REASON_COST) 
end 
function c13090000.xtktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,13090002,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c13090000.xtkop(e,tp,eg,ep,ev,re,r,rp) 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,13090002,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,13090002)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end





