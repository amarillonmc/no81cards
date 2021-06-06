--罗德岛·重装干员-铸铁
function c79029201.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()  
	--equip  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79029201)
	e1:SetCost(c79029201.ecost)
	e1:SetTarget(c79029201.etg)
	e1:SetOperation(c79029201.eop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27548199,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,09029201)
	e2:SetCondition(c79029201.discon)
	e2:SetCost(c79029201.discost)
	e2:SetTarget(c79029201.distg)
	e2:SetOperation(c79029201.disop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,19029201)
	e3:SetTarget(c79029201.desreptg)
	e3:SetValue(c79029201.desrepval)
	e3:SetOperation(c79029201.desrepop)
	c:RegisterEffect(e3)
	--defense attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DEFENSE_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
c79029201.material_type=TYPE_SYNCHRO
function c79029201.ecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c79029201.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c79029201.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Debug.Message("倾覆吧！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029201,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,0,1,1,nil,tp,c)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(1-tp,tc,c) then return end   
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c79029201.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c79029201.eqlimit(e,c)
	return e:GetOwner()==c
end
function c79029201.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79029201.disfil(c,e)
	return c:GetEquipTarget()==e:GetHandler()
end
function c79029201.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029201.disfil,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e) end
	local g=Duel.SelectMatchingCard(tp,c79029201.disfil,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e)
	Duel.SendtoGrave(g,REASON_COST) 
end
function c79029201.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c79029201.disop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("休想再进一步。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029201,1))
	Duel.NegateActivation(ev)
end
function c79029201.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c79029201.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c79029201.repfilter,1,nil,tp)
		and c:GetEquipGroup():Filter(Card.IsAbleToGrave,nil):GetCount()>0 end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c79029201.desrepval(e,c)
	return c79029201.repfilter(c,e:GetHandlerPlayer())
end
function c79029201.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(Card.IsAbleToGrave,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Debug.Message("让你们见识一下米诺斯的战技！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029201,2))
	Duel.Recover(tp,1000,REASON_EFFECT)	
	Duel.Hint(HINT_CARD,0,79029201)
end






