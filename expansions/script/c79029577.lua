--咒星壳·噩兆
function c79029577.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c79029577.efilter)
	e2:SetCondition(c79029577.imcon)
	c:RegisterEffect(e2)   
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79029577)
	e1:SetCondition(c79029577.condition)
	e1:SetTarget(c79029577.target)
	e1:SetOperation(c79029577.operation)
	c:RegisterEffect(e1)  
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(79029577,0))
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c79029577.target1)
	e2:SetOperation(c79029577.operation1)
	c:RegisterEffect(e2)  
end
function c79029577.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029577.fil(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x110)
end
function c79029577.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetMaterial():IsExists(c79029577.fil,1,nil)
end
function c79029577.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79029577.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79029577.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and Duel.Destroy(rc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Equip(tp,rc,c)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c79029577.eqlimit)
		rc:RegisterEffect(e1)
		local cid=c:CopyEffect(rc:GetOriginalCode(),0,1)
		--
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(41209827,3))
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetLabelObject(c)
		e2:SetLabel(cid)
		e2:SetOperation(c79029577.rstop)
		rc:RegisterEffect(e2)
	--substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(1)
	rc:RegisterEffect(e2)   
	end
end
function c79029577.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if not c:IsLocation(LOCATION_ONFIELD) then return end
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	e:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c79029577.eqlimit(e,c)
	return e:GetOwner()==c
end
function c79029577.repfilter(c,e,tp)
	return c:IsFaceup() and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and c==e:GetHandler():GetEquipTarget()
end
function c79029577.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c79029577.repfilter,1,nil,e,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c79029577.repval(e,c)
	return c79029577.repfilter(c,e:GetHandlerPlayer())
end
function c79029577.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
function c79029577.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c79029577.operation1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT) then
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	elseif Duel.GetCurrentPhase()==PHASE_MAIN1 then
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	elseif Duel.GetCurrentPhase()==PHASE_BATTLE then
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	elseif Duel.GetCurrentPhase()==PHASE_MAIN2 then
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end  
	end
end



