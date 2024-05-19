--只能可控机械骰子
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroMixProcedure(c,s.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.immop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.spstg)
	e2:SetOperation(s.spsop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_DICE)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	if not rc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) then return end
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_MZONE and rc:GetFlagEffect(id)==0 and (ex1 and dv1>0 or ex2 and dv2>0) then
		rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function s.matfilter1(c,syncard)
	return (c:IsTuner(syncard) or c:GetFlagEffect(id)>0) and (c.toss_dice or c.toss_coin)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function s.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d1,d2=Duel.TossDice(tp,2)
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	if d1==d2 then
		local off=1
		local ops={}
		local opval={}
		while off<7 do
			ops[off]=aux.Stringid(id,off)
			opval[off-1]=off
			off=off+1
		end
		local op1=Duel.SelectOption(tp,table.unpack(ops))
		local offo=1
		local opso={}
		local opvalo={}
		while offo<6 do
			if offo>=op1+1 then
				opso[offo]=aux.Stringid(id,offo+1)
				opvalo[offo-1]=offo
				offo=offo+1
			else
				opso[offo]=aux.Stringid(id,offo)
				opvalo[offo-1]=offo
				offo=offo+1
			end
		end
		local op2=Duel.SelectOption(tp,table.unpack(opso))
		if op2>=op1 then
			op2=op2+1
		end
		if opval[op1]==1 or opval[op2]==1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
		if opval[op1]==2 or opval[op2]==2 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			c:RegisterEffect(e3)
		end
		if opval[op1]==3 or opval[op2]==3 then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCode(EFFECT_UNRELEASABLE_SUM)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e4)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			c:RegisterEffect(e5)
		end
		if opval[op1]==4 or opval[op2]==4 then
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_IMMUNE_EFFECT)
			e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e6:SetRange(LOCATION_MZONE)
			e6:SetValue(s.efilter)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e6)
		end
		if opval[op1]==5 or opval[op2]==5 then
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e7:SetRange(LOCATION_MZONE)
			e7:SetCode(EFFECT_UPDATE_ATTACK)
			e7:SetValue(1500)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e7)
			local e8=e7:Clone()
			e8:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e8)
		end
		if opval[op1]==6 or opval[op2]==6 then
			local e8=Effect.CreateEffect(c)
			e8:SetDescription(aux.Stringid(id,6))
			e8:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
			e8:SetType(EFFECT_TYPE_QUICK_O)
			e8:SetCode(EVENT_CHAINING)
			e8:SetCountLimit(1)
			e8:SetRange(LOCATION_MZONE)
			e8:SetCondition(s.discon)
			e8:SetTarget(s.distg)
			e8:SetOperation(s.disop)
			e8:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e8)
		end
	else
		if d1==1 or d2==1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
		if d1==2 or d2==2 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			c:RegisterEffect(e3)
		end
		if d1==3 or d2==3 then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCode(EFFECT_UNRELEASABLE_SUM)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e4)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			c:RegisterEffect(e5)
		end
		if d1==4 or d2==4 then
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_IMMUNE_EFFECT)
			e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e6:SetRange(LOCATION_MZONE)
			e6:SetValue(s.efilter)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e6)
		end
		if d1==5 or d2==5 then
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e7:SetRange(LOCATION_MZONE)
			e7:SetCode(EFFECT_UPDATE_ATTACK)
			e7:SetValue(1500)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e7)
			local e8=e7:Clone()
			e8:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e8)
		end
		if d1==6 or d2==6 then
			local e8=Effect.CreateEffect(c)
			e8:SetDescription(aux.Stringid(id,6))
			e8:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
			e8:SetType(EFFECT_TYPE_QUICK_O)
			e8:SetCode(EVENT_CHAINING)
			e8:SetCountLimit(1)
			e8:SetRange(LOCATION_MZONE)
			e8:SetCondition(s.discon)
			e8:SetTarget(s.distg)
			e8:SetOperation(s.disop)
			e8:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e8)
		end
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and rc:IsDestructable()
		and Duel.SelectYesNo(tp,aux.Stringid(id,7)) then
		Duel.BreakEffect()
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function s.efilter(e,re)
	return re:IsActivated()
end
function s.dfilter(c,tp)
	return c:IsFaceupEx() and c:GetFlagEffect(id)>0 and Duel.GetMZoneCount(tp,c)>0
end
function s.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,tp)
	if chk==0 then return #g>1 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,aux.ExceptThisCard(e),tp)
	if Duel.Destroy(g,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end