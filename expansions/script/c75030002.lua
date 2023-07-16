--苍炎圣击者 奈菲尼
function c75030002.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_END_PHASE) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,75030002) 
	e1:SetCondition(function(e) 
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end) 
	e1:SetCost(c75030002.hspcost)
	e1:SetTarget(c75030002.hsptg) 
	e1:SetOperation(c75030002.hspop) 
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,15030002+EFFECT_COUNT_CODE_DUEL) 
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFlagEffect(tp,75030002)>=6 end)
	e2:SetTarget(c75030002.xxtg) 
	e2:SetOperation(c75030002.xxop) 
	c:RegisterEffect(e2) 
	if not c75030002.global_check then
		c75030002.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c75030002.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end 
function c75030002.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker() 
	if tc:IsSetCard(0x753) then 
		Duel.RegisterFlagEffect(tc:GetControler(),75030002,0,0,1) 
	end
end
function c75030002.hpbfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PYRO) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsCode(75030002) and not c:IsPublic()
end 
function c75030002.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75030002.hpbfil,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c75030002.hpbfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g) 
	Duel.ShuffleHand(tp)
end 
function c75030002.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c75030002.hthfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x753) and c:IsType(TYPE_SPELL+TYPE_TRAP) 
end 
function c75030002.hspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75030002,0)) then 
		Duel.BreakEffect() 
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)   
		Duel.Destroy(g,REASON_EFFECT) 
	end 
end 
function c75030002.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end 
function c75030002.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(75030002,1))
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(75030002) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0) 
	Duel.RegisterEffect(e1,tp) 
	--damage 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(HALF_DAMAGE)  
	e2:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0x753) end,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end) 
	Duel.RegisterEffect(e2,tp)
end 





