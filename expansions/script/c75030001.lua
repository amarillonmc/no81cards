--苍炎追放者 艾琳西亚
function c75030001.initial_effect(c)
	--cannot be link material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,75030001) 
	e1:SetCost(c75030001.hspcost)
	e1:SetTarget(c75030001.hsptg) 
	e1:SetOperation(c75030001.hspop) 
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,15030001+EFFECT_COUNT_CODE_DUEL) 
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFlagEffect(tp,75030001)>=6 end)
	e2:SetTarget(c75030001.xxtg) 
	e2:SetOperation(c75030001.xxop) 
	c:RegisterEffect(e2) 
	if not c75030001.global_check then
		c75030001.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c75030001.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end 
function c75030001.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker() 
	if tc:IsSetCard(0x5751) then 
		Duel.RegisterFlagEffect(tc:GetControler(),75030001,0,0,1) 
	end
end
function c75030001.hpbfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PYRO) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsCode(75030001) and not c:IsPublic()
end 
function c75030001.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75030001.hpbfil,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c75030001.hpbfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g) 
	Duel.ShuffleHand(tp)
end 
function c75030001.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c75030001.hthfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x5751) and c:IsType(TYPE_SPELL+TYPE_TRAP) 
end 
function c75030001.hspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c75030001.hthfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75030001,0)) then 
		Duel.BreakEffect() 
		local g=Duel.SelectMatchingCard(tp,c75030001.hthfil,tp,LOCATION_DECK,0,1,1,nil)   
		Duel.SendtoHand(g,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,g)  
	end 
end 
function c75030001.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end 
function c75030001.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(75030001,1))
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(75030001) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0) 
	Duel.RegisterEffect(e1,tp) 
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c)
	return c:IsSetCard(0x5751) end) 
	e1:SetValue(function(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end end) 
	Duel.RegisterEffect(e1,tp) 
end 




