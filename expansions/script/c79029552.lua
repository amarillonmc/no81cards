--烈星壳·炎魔
function c79029552.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,85475641),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_FIRE),1)
	c:EnableReviveLimit()   
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029552.lzcon)
	e1:SetTarget(c79029552.lztg)
	e1:SetOperation(c79029552.lzop)
	c:RegisterEffect(e1)  
	--send to grave 2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c79029552.tgcost)
	e2:SetTarget(c79029552.tgtg)
	e2:SetOperation(c79029552.tgop)
	c:RegisterEffect(e2)
end
function c79029552.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029552.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetHandler():GetMaterialCount()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,x,tp,LOCATION_DECK)
end
function c79029552.lzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetHandler():GetMaterialCount()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetDecktopGroup(tp,x)
	if Duel.SendtoGrave(g,REASON_EFFECT) then
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029552.efilter1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1) 
end
	if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029552.efilter2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1) 
end
	if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029552.efilter3)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1) 
end
	if  not e:GetHandler():GetMaterial():IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(79029552,0)) then
	local p=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not Duel.SendtoGrave(p,REASON_EFFECT) then return end
	if p:IsType(TYPE_MONSTER) then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029552.efilter1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)   
end
	if p:IsType(TYPE_SPELL) then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029552.efilter2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)   
end
	if p:IsType(TYPE_TRAP) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029552.efilter3)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1) 
end
end
end
end
function c79029552.efilter1(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end
function c79029552.efilter2(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c79029552.efilter3(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwner():IsControler(1-tp)
end
function c79029552.fil(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemoveAsCost()
end
function c79029552.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029552.fil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029552.fil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c79029552.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if chk==0 then return cg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,cg,cg:GetCount(),0,0)
end

function c79029552.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if cg:GetCount()>0 then
		Duel.BreakEffect()
		if Duel.SendtoGrave(cg,REASON_EFFECT)~=0 then 
	local seq=0
	local og=Duel.GetOperatedGroup()
	local tc=og:GetFirst()
	while tc do
		seq=bit.replace(seq,0x1,tc:GetPreviousSequence())
		tc=og:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetLabel(seq*0x10000)
	e1:SetOperation(c79029552.disop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
end
end
function c79029552.disop(e,tp)
	return e:GetLabel()
end



