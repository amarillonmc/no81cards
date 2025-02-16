--苍炎召风者 塞内利奥
function c75030003.initial_effect(c)
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
	e1:SetCountLimit(1,75030003) 
	e1:SetCost(c75030003.hspcost)
	e1:SetTarget(c75030003.hsptg) 
	e1:SetOperation(c75030003.hspop) 
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,15030003+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFlagEffect(tp,75030003)>=6 end)  
	e2:SetTarget(c75030003.xxtg) 
	e2:SetOperation(c75030003.xxop) 
	c:RegisterEffect(e2) 
	if not c75030003.global_check then
		c75030003.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c75030003.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end 
function c75030003.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker() 
	if tc:IsSetCard(0x753) then 
		Duel.RegisterFlagEffect(tc:GetControler(),75030003,0,0,1) 
	end
end
function c75030003.hpbfil(c) 
	return c:IsType(TYPE_MONSTER)  and c:IsRace(RACE_PYRO) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsCode(75030003) and not c:IsPublic()
end 
function c75030003.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75030003.hpbfil,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c75030003.hpbfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g) 
	Duel.ShuffleHand(tp)
end 
function c75030003.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c75030003.hthfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x753) and not c:IsCode(75030003)
end 
function c75030003.hspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c75030003.hthfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75030003,0)) then 
		Duel.BreakEffect() 
		local g=Duel.SelectMatchingCard(tp,c75030003.hthfil,tp,LOCATION_DECK,0,1,1,nil)   
		Duel.SendtoHand(g,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,g)  
	end 
end 
function c75030003.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end 
function c75030003.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(75030003,1))
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(75030003) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0) 
	Duel.RegisterEffect(e1,tp) 
	--damage 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c75030003.damcon)
	e2:SetOperation(c75030003.damop)
	Duel.RegisterEffect(e2,tp) 
end 
function c75030003.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ac,bc=Duel.GetBattleMonster(tp)
	return ep~=tp and ac and ac:IsSetCard(0x753) 
end
function c75030003.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev+800) 
end




