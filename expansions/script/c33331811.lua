--虚景创成 精神炼金
function c33331811.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(33331811,1))
	e1:SetCategory(CATEGORY_DRAW) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,33331811+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c33331811.accost1) 
	e1:SetTarget(c33331811.actg) 
	e1:SetOperation(c33331811.acop) 
	c:RegisterEffect(e1)  
	local e2=e1:Clone() 
	e2:SetDescription(aux.Stringid(33331811,2)) 
	e2:SetCost(c33331811.accost2) 
	c:RegisterEffect(e2) 
	--to grave 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOGRAVE) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_GRAVE) 
	e3:SetCost(aux.bfgcost) 
	e3:SetTarget(c33331811.tgtg) 
	e3:SetOperation(c33331811.tgop) 
	c:RegisterEffect(e3) 
end 
function c33331811.rlfil1(c) 
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsReleasable()
end 
function c33331811.accost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33331811.rlfil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end  
	local g=Duel.SelectMatchingCard(tp,c33331811.rlfil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil) 
	local x=Duel.Release(g,REASON_COST) 
	e:SetLabel(x) 
end 
function c33331811.rlfil2(c) 
	return  c:IsRace(RACE_WYRM) and c:IsReleasable() --and c:IsFaceup() 
end 
function c33331811.accost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33331811.rlfil2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end  
	local g=Duel.SelectMatchingCard(tp,c33331811.rlfil2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,2,nil) 
	local x=Duel.Release(g,REASON_COST) 
	e:SetLabel(x) 
end 
function c33331811.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(e:GetLabel()) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel()) 
end 
function c33331811.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	Duel.Draw(p,d,REASON_EFFECT) 
end 
function c33331811.tgfil(c) 
	return c:IsAbleToGrave() and c:IsSetCard(0x566) and not c:IsCode(33331811)
end 
function c33331811.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33331811.tgfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end 
function c33331811.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33331811.tgfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil) 
		Duel.SendtoGrave(dg,REASON_EFFECT) 
	end 
end 




