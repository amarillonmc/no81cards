--轮回六道 切换
function c79011453.initial_effect(c)
	aux.AddCodeList(c,79011445)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND) 
	c:RegisterEffect(e2)
	--change 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetTarget(c79011453.actg) 
	e1:SetOperation(c79011453.acop)  
	c:RegisterEffect(e1) 
	--draw 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,79011453)   
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)   
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(79011445) end,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,nil) end)
	e2:SetCost(c79011453.drcost) 
	e2:SetTarget(c79011453.drtg) 
	e2:SetOperation(c79011453.drop) 
	c:RegisterEffect(e2)
end 
c79011453.SetCard_Pain_PBLK_Skill=true  
function c79011453.pcgfil(c,e,tp)
	return c:IsFaceup() and c.SetCard_Pain_PBLK 
end  
function c79011453.cspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c.SetCard_Pain_PBLK and c:GetSequence()==0 
end 
function c79011453.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local sc=Duel.GetFirstMatchingCard(c79011453.cspfil,tp,LOCATION_PZONE,0,nil,e,tp)
	if chk==0 then return Duel.IsExistingTarget(c79011453.pcgfil,tp,LOCATION_MZONE,0,1,nil,e,tp) and sc end 
	local g=Duel.SelectTarget(tp,c79011453.pcgfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sc,1,0,0)
end
function c79011453.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local sc=Duel.GetFirstMatchingCard(c79011453.cspfil,tp,LOCATION_PZONE,0,nil,e,tp)
	local tc=Duel.GetFirstTarget()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP)~=0 and tc and tc:IsRelateToEffect(e) then   
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)   
		Duel.MoveSequence(tc,0) 
	end 
end 
function c79011453.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST) 
end
function c79011453.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c79011453.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end




