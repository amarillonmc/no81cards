--核心硬币 鹰雀鹫联组
function c32100006.initial_effect(c)
	aux.AddCodeList(c,32100002)
	--spsummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCost(c32100006.spcost)
	e1:SetTarget(c32100006.sptg)
	e1:SetOperation(c32100006.spop)
	c:RegisterEffect(e1) 
	--des 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(32100006,1)) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1)  
	e1:SetTarget(c32100006.destg)
	e1:SetOperation(c32100006.desop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetLabelObject(e1) 
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c==e:GetHandler():GetEquipTarget() end) 
	e2:SetCondition(function(e) 
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsCode(32100002) and e:GetHandler():GetSequence()==1 end)
	c:RegisterEffect(e2)
	--atk  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(500)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetLabelObject(e1) 
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c==e:GetHandler():GetEquipTarget() end) 
	e2:SetCondition(function(e) 
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsCode(32100002) and e:GetHandler():GetSequence()==2 end)
	c:RegisterEffect(e2)  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32100006,2))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c32100006.tgtg)
	e1:SetOperation(c32100006.tgop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetLabelObject(e1) 
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c==e:GetHandler():GetEquipTarget() end) 
	e2:SetCondition(function(e) 
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsCode(32100002) and e:GetHandler():GetSequence()==2 end)
	c:RegisterEffect(e2)  
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32100006,3)) 
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1)  
	e1:SetTarget(c32100006.drtg)
	e1:SetOperation(c32100006.drop) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetLabelObject(e1) 
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c==e:GetHandler():GetEquipTarget() end) 
	e2:SetCondition(function(e) 
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsCode(32100002) and e:GetHandler():GetSequence()==3 end)
	c:RegisterEffect(e2)
end
c32100006.SetCard_HR_Corecoin=true 
function c32100006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToGraveAsCost() and c.SetCard_HR_Corecoin and c:IsType(TYPE_MONSTER) end,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToGraveAsCost() and c.SetCard_HR_Corecoin and c:IsType(TYPE_MONSTER) end,tp,LOCATION_HAND,0,2,2,e:GetHandler()) 
	g:AddCard(e:GetHandler()) 
	Duel.SendtoGrave(g,REASON_COST) 
end 
function c32100006.spfilter(c,e,tp)
	return c:IsCode(32100002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32100006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32100006.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c32100006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32100006.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c32100006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:GetAttack()<1000 end,tp,0,LOCATION_MZONE,nil) 
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end
function c32100006.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:GetAttack()<1000 end,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
		Duel.Destroy(g,REASON_EFFECT) 
	end 
end 
function c32100006.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:IsDefensePos() end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,d,1,0,0)
end
function c32100006.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d:IsRelateToBattle() and d:IsDefensePos() then
		Duel.SendtoGrave(d,REASON_EFFECT) 
	end
end
function c32100006.drtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c32100006.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT) 
end 
