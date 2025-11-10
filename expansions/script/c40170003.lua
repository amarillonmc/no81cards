--凶导之破弃
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(s.target)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,id)
	e4:SetCost(s.thcost)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)   
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,id)
	e4:SetCost(s.spcost)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)				  
	--act in set turn
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetCondition(s.actcon)
	c:RegisterEffect(e6)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end	
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:GetHandler():IsSetCard(0x145) then return end
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function s.actfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(2500) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.actcon(e)
	return e:GetHandler():GetFlagEffect(id)>0 or Duel.IsExistingMatchingCard(s.actfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.target(e,c)
	local ct=Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)
	return c:IsLevelAbove(1) and c:IsLevelAbove(ct)
end
function s.cfilter(c,tp)
	return (c:IsFaceup() or c:IsControler(tp)) and c:IsSetCard(0x145) 
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function s.thfilter(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x145) and not c:IsCode(code) and c:IsAbleToHand()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.cfilter,1,nil,tp) end
	local rg=Duel.SelectReleaseGroup(tp,s.cfilter,1,1,false,nil,nil,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.rfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x145) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode(),c:GetAttack(),c:GetDefense())
end
function s.spfilter(c,e,tp,code,atk,def)
	return c:IsSetCard(0x145) and c:IsAttack(atk) and c:IsDefense(def) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.rfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=Duel.SelectReleaseGroup(tp,s.rfilter,1,1,nil,e,tp):GetFirst()
	e:SetLabel(tc:GetCode(),tc:GetAttack(),tc:GetDefense())
	Duel.Release(tc,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end