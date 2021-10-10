--莱茵生命·行动-定点诊疗
function c79029241.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029241)
	e1:SetTarget(c79029241.target)
	e1:SetOperation(c79029241.activate)
	c:RegisterEffect(e1) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,790292419)
	e1:SetTarget(c79029241.target1)
	e1:SetOperation(c79029241.operation)
	c:RegisterEffect(e1)
	--ex p
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c79029241.exptg)
	e2:SetOperation(c79029241.expop)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c79029241.eqlimit)
	c:RegisterEffect(e3)
if not c79029241.global_check then
		c79029241.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)   
		ge1:SetTarget(c79029241.retg)
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c79029241.retg(e,c)
	return c:IsCode(79029241) and c:IsType(TYPE_EQUIP)
end
function c79029241.eqlimit(e,c)
	return c:IsSetCard(0xa900)
end
function c79029241.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xa900) 
end
function c79029241.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029241.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c79029241.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c79029241.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029241.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EQUIP+TYPE_SPELL)
		e1:SetReset(RESET_EVENT+EVENT_REMOVE)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c79029241.spfil(c,e,tp)
	return c:IsSetCard(0x1907) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c79029241.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c79029241.spfil,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,2,nil)
	local b3=Duel.IsExistingMatchingCard(c79029241.penfil,tp,LOCATION_DECK,0,2,nil,e,tp)
	if chk==0 then return b1 or (b2 and b3) end
	local op=0
	if b1 and b2 and b3 then
	op=Duel.SelectOption(tp,aux.Stringid(79029241,0),aux.Stringid(79029241,1))
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79029241,0)) 
	else
	op=Duel.SelectOption(tp,aux.Stringid(79029241,1))+1 
	end
	e:SetLabel(op)
	if op==0 then
	local g=Duel.SelectMatchingCard(tp,c79029241.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_DECK)
	else
	end
	local sg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,2,tp,LOCATION_PZONE)
end
function c79029241.ckfil(c)
	return c:IsSetCard(0x1907) and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c79029241.penfil(c)
	return c:IsSetCard(0x1907) and c:IsType(TYPE_PENDULUM)
end
function c79029241.penfil2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa900)
end
function c79029241.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
	local g=Duel.GetFirstTarget()
	Duel.SpecialSummon(g,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
	else
	local sg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.Destroy(sg,REASON_EFFECT)
	local g=Duel.SelectMatchingCard(tp,c79029241.penfil,tp,LOCATION_DECK,0,2,2,nil,e,tp)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c79029241.exptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:GetFirst()==e:GetHandler():GetEquipTarget() end
end
function c79029241.expop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(79029241,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCountLimit(1,79029241)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end










