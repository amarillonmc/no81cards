--Legend-Arms 诸神之主兽
function c16310055.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,16310045,16310050,true,true)
	aux.AddContactFusionProcedure(c,c16310055.cfilter,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c16310055.fsplimit)
	c:RegisterEffect(e0)
	if not c16310055.global_flag then
		c16310055.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c16310055.regop)
		Duel.RegisterEffect(ge1,0)
	end
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c16310055.target)
	e1:SetOperation(c16310055.operation)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(c16310055.atkval)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16310055,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16310055)
	e3:SetCondition(c16310055.negcon)
	e3:SetCost(c16310055.negcost)
	e3:SetTarget(aux.nbtg)
	e3:SetOperation(c16310055.negop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16310055,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_BATTLE_END)
	e4:SetCountLimit(1,16310055+1)
	e4:SetCondition(c16310055.spcon)
	e4:SetTarget(c16310055.sptg)
	e4:SetOperation(c16310055.spop)
	c:RegisterEffect(e4)
end
function c16310055.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(16310045) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),16310055,0,0,0)
		elseif tc:IsCode(16310050) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),16310055+1,0,0,0)
		end
	end
end
function c16310055.cfilter(c,fc)
	local tp=fc:GetControler()
	return c:IsFusionCode(16310045,16310050) and c:IsAbleToRemoveAsCost() and Duel.GetFlagEffect(tp,16310055)>0 and Duel.GetFlagEffect(tp,16310055+1)>0
end
function c16310055.fsplimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c16310055.eqfilter(c)
	return c:IsSetCard(0x3dc6) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:IsFaceupEx()
		and (c:IsAttack(0) or c:IsDefense(0))
end
function c16310055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(c16310055.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0)
end
function c16310055.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c16310055.eqfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if ft>g:GetCount() then ft=g:GetCount() end
	if ft==0 then return end
	local sg=g:Select(tp,ft,ft,nil)
	local tc=sg:GetFirst()
	while tc do
		if Duel.Equip(tp,tc,c,false) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c16310055.eqlimit)
			tc:RegisterEffect(e1)
		end
		tc=sg:GetNext()
	end
end
function c16310055.eqlimit(e,c)
	return e:GetOwner()==c
end
function c16310055.atkval(e,c)
	return e:GetHandler():GetEquipCount()-1
end
function c16310055.negcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function c16310055.negfilter(c)
	return (c:IsFaceup() or c:GetEquipTarget()) and c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c16310055.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16310055.negfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16310055.negfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c16310055.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c16310055.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c16310055.spfilter(c,e,tp)
	return c:GetEquipTarget()==e:GetHandler() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsSetCard(0x3dc6)
end
function c16310055.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16310055.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function c16310055.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16310055.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp,c)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(16310055,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc:RegisterFlagEffect(16310055,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c16310055.eqcon1(c))
		e1:SetOperation(c16310055.eqop1(c))
		Duel.RegisterEffect(e1,tp)
	end
end
function c16310055.eqcon1(mc)
	return
		function (e,tp,eg,ep,ev,re,r,rp)
			local tc=e:GetLabelObject()
			if mc:GetFlagEffectLabel(16310055)~=e:GetLabel() or tc:GetFlagEffectLabel(16310055)~=e:GetLabel() then
				e:Reset()
				return false
			else return true end
		end
end
function c16310055.eqop1(mc)
	return
		function (e,tp,eg,ep,ev,re,r,rp)
			local tc=e:GetLabelObject()
			if not Duel.Equip(tp,tc,mc) then return end
			local e1=Effect.CreateEffect(mc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetValue(c16310055.eqlimit1)
			e1:SetLabelObject(mc)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
end
function c16310055.eqlimit1(e,c)
	return e:GetLabelObject()==c
end