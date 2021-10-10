--AKF-光辟的使徒
function c82566600.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(c82566600.shining),aux.FilterBoolFunction(c82566600.nightingale),1,false,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST) 
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c82566600.splimit)
	c:RegisterEffect(e1)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82566600,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c82566600.cardnamecon)
	e2:SetOperation(c82566600.cardnameoperation)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82566600,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c82566600.adcost)
	e3:SetCountLimit(1,82566600)
	e3:SetTarget(c82566600.target)
	e3:SetOperation(c82566600.activate)
	e3:SetValue(c82566600.rdval)
	c:RegisterEffect(e3)
end
function c82566600.spfilter(c,e,tp)
	return not c:IsSetCard(0xa825) and c:IsType(TYPE_MONSTER) and 
			 c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c82566600.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c82566600.spfilter(chkc,e,tp) end
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c82566600.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c82566600.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c82566600.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c82566600.filter(c)
	return c:IsFaceup()
end
function c82566600.rdval(e)
	return e:GetHandler():GetAttack()/2
end
function c82566600.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,4,REASON_COST)
end
function c82566600.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c82566600.filter,tp,LOCATION_MZONE,0,e:GetHandler())
	local nsg=sg:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c82566600.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,nsg,tp,0)
end
function c82566600.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82567786.filter,tp,LOCATION_MZONE,0,e:GetHandler())
	local ag=Duel.GetMatchingGroup(c82567786.filter,tp,LOCATION_MZONE,0,nil)
	local atk=c82566600.rdval(e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	if not c:IsRelateToEffect(e) then return false end
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end 
	local ac=ag:GetFirst()
	while ac do
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c82566600.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ac:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetValue(1)
		ac:RegisterEffect(e3)
		ac=ag:GetNext()
	end
end
function c82566600.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER)
end
function c82566600.cardnamecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMaterialCount()==2 
end
function c82566600.shining(c)
	return c:IsFusionCode(82567853,82567855)
end
function c82566600.nightingale(c)
	return c:IsFusionCode(82567786,82567787,82568087,82568086) 
end
function c82566600.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c82566600.cardnameoperation(e,se,sp,st)
	if not e:GetHandler():GetMaterialCount()==2 then return false end
	local mat=e:GetHandler():GetMaterial()
	local mat1=mat:GetFirst()
	local mat2=mat:GetFirst()
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_CODE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetValue(mat1:GetCode())
	e:GetHandler():RegisterEffect(e4)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_ADD_CODE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	e5:SetValue(mat2:GetCode())
	e:GetHandler():RegisterEffect(e5)
end