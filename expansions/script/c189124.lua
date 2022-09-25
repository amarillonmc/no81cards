--空牙团的大副 贝特
function c189124.initial_effect(c)
	--token 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,189124)
	e1:SetTarget(c189124.sptg)
	e1:SetOperation(c189124.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--Destroy 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e3:SetRange(LOCATION_GRAVE) 
	e3:SetCountLimit(1,289124) 
	e3:SetCondition(c189124.dscon) 
	e3:SetCost(aux.bfgcost)   
	e3:SetTarget(c189124.dstg) 
	e3:SetOperation(c189124.dsop) 
	c:RegisterEffect(e3)  
end
function c189124.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if chk==0 then return ft1>0 and ft2>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,189125,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FISH,ATTRIBUTE_WATER,POS_FACEUP_ATTACK,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,189125,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FISH,ATTRIBUTE_WATER,POS_FACEUP_ATTACK,1-tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
end
function c189124.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if ft1<=0 or ft2<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,189125,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FISH,ATTRIBUTE_WATER,POS_FACEUP_ATTACK,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,189125,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FISH,ATTRIBUTE_WATER,POS_FACEUP_ATTACK,1-tp) then
		local token=Duel.CreateToken(tp,189125)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		local token=Duel.CreateToken(tp,189125)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
		Duel.SpecialSummonComplete()
	end
end 
function c189124.ckfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x114) 
end 
function c189124.dscon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(c189124.ckfil,tp,LOCATION_MZONE,0,1,nil) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)  
end 
function c189124.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end 
	local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2) 
	Duel.SetTargetCard(g1) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,g2:GetCount(),0,0)  
end 
function c189124.dsop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) 
	local dg=g:Filter(Card.IsRelateToEffect,nil,e) 
	if dg:GetCount()>0 then 
	Duel.Destroy(dg,REASON_EFFECT)
	end 
end 










