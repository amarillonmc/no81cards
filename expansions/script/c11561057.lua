--朱色皇威 伊利亚
local m=11561057
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--link summon
	aux.AddLinkProcedure(c,nil,2,5,c11561057.lcheck)
	c:EnableReviveLimit()
	--count
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11561057.ctcon)
	e1:SetTarget(c11561057.cttg)
	e1:SetOperation(c11561057.ctop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11561057,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetRange(0xff)
	e2:SetCondition(c11561057.clcon)
	e2:SetOperation(c11561057.debug)
	c:RegisterEffect(e2)
	--d1
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c11561057.descost)
	e3:SetTarget(c11561057.destg2)
	e3:SetOperation(c11561057.desop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,11561057)
	e4:SetCondition(c11561057.spcon)
	e4:SetTarget(c11561057.sptg)
	e4:SetOperation(c11561057.spop)
	c:RegisterEffect(e4)
	if not c11561057.global_check then
		c11561057.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
		ge1:SetTargetRange(1,1)
		ge1:SetCondition(c11561057.clcon)
		ge1:SetValue(1)
		Duel.RegisterEffect(ge1,0)
		Duel.RegisterEffect(ge1,1)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCondition(c11561057.lpcon)
		ge2:SetOperation(c11561057.Lpop)
		Duel.RegisterEffect(ge2,0)
		Duel.RegisterEffect(ge2,1)
	end
end
function c11561057.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsPreviousPosition(POS_FACEUP) or c:IsFaceupEx()) and c:IsPreviousControler(tp)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c11561057.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,3000)
end
function c11561057.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler() 
	Duel.Damage(tp,3000,REASON_EFFECT)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ct=math.floor(math.abs(Duel.GetLP(tp)-8000)/2000)
		e:GetHandler():AddCounter(0x1,ct)
		if Duel.GetLP(tp)<2001 then 
			Duel.BreakEffect()
		local cg1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil,e)
		local cg2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil,e)
		local off=1
		local ops={}
		local opval={}
		local res
		if #cg1>0 then
			ops[off]=aux.Stringid(11561057,6)
			opval[off-1]=1
			off=off+1
		end
		if #cg2>0 then
			ops[off]=aux.Stringid(11561057,7)
			opval[off-1]=2
			off=off+1
		end
		if off==1 then return end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
		res=Duel.Destroy(cg1,REASON_EFFECT)
		elseif opval[op]==2 then
		res=Duel.Destroy(cg2,REASON_EFFECT)
		end
		local flag=Duel.GetFlagEffectLabel(tp,11561051)
		local dun=res*500
		if flag then
			Duel.SetFlagEffectLabel(tp,11561051,flag+dun)
		else
			Duel.RegisterFlagEffect(tp,11561051,RESET_EVENT+RESETS_STANDARD,0,1,dun)
		end
		end
	end
end
function c11561057.lkkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,15000694)~=0
end
function c11561057.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c11561057.destg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local b1=Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_COST)
	local b2=Duel.IsCanRemoveCounter(tp,1,0,0x1,2,REASON_COST)
	local b3= Duel.IsCanRemoveCounter(tp,1,0,0x1,3,REASON_COST)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return b1 or b2 or b3
	end
	e:SetLabel(0)
	local off=1
	local ops={}
	if b1 then
		ops[off]=1
		off=off+1
	end
	if b2 then
		ops[off]=2
		off=off+1
	end
	if b3 then
		ops[off]=3
		off=off+1
	end
	local num
	num=Duel.AnnounceNumber(tp,table.unpack(ops))
	Duel.RemoveCounter(tp,1,0,0x1,num,REASON_COST)
	e:SetLabel(num)
	if ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) or (seq==5 and (Duel.CheckLocation(tp,LOCATION_MZONE,0) or Duel.CheckLocation(tp,LOCATION_MZONE,2))) or (seq==6 and (Duel.CheckLocation(tp,LOCATION_MZONE,2) or Duel.CheckLocation(tp,LOCATION_MZONE,4)))) and Duel.SelectYesNo(tp,aux.Stringid(11561057,4)) then 
		local flag=0
		if seq>0 and seq<5 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
		if seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,0) then flag=flag|(1<<(0)) end
		if seq==5 or seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,2) then flag=flag|(1<<(2)) end
		if seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,4) then flag=flag|(1<<(4)) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~flag)
		local nseq=math.log(s,2)
		Duel.MoveSequence(c,nseq) 
	end  
end  
function c11561057.desfilther1(c,e)
	local seq=c:GetSequence()
	local sseq=e:GetHandler():GetSequence()
	return (seq<5 and sseq<5 and math.abs(4-sseq-seq)<=1) or (seq<5 and sseq==5 and seq>1) or (seq<3 and sseq==6) or (seq==6 and sseq<3) or (seq==5 and sseq>1 and sseq<5)
end
function c11561057.desop(e,tp,eg,ep,ev,re,r,rp)
	local at=e:GetLabel()
	local c=e:GetHandler()
	local res
	local cg1=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	local cg2=Duel.GetMatchingGroup(c11561057.desfilther1,tp,0,LOCATION_MZONE,nil,e)
	local cg3=Duel.GetMatchingGroup(c11561057.desfilther1,tp,0,LOCATION_ONFIELD,nil,e)
	if c:IsRelateToEffect(e) and at==1 and #cg1>0 and Duel.SelectYesNo(tp,aux.Stringid(11561057,5)) then
		local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		if #cg==0 then return end
		res=Duel.Destroy(cg,REASON_EFFECT)
	elseif  c:IsRelateToEffect(e) and at==2 and #cg2>0 and Duel.SelectYesNo(tp,aux.Stringid(11561057,5)) then
		local cg=Duel.GetMatchingGroup(c11561057.desfilther1,tp,0,LOCATION_MZONE,nil,e)
		local cg2=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		if #cg==0 then return end
		res=Duel.Destroy(cg,REASON_EFFECT)
	elseif  c:IsRelateToEffect(e) and at==3 and #cg3>0 and Duel.SelectYesNo(tp,aux.Stringid(11561057,5)) then
		local cg=Duel.GetMatchingGroup(c11561057.desfilther1,tp,0,LOCATION_ONFIELD,nil,e)
		if #cg==0 then return end
		res=Duel.Destroy(cg,REASON_EFFECT) end
	if res then
	local flag=Duel.GetFlagEffectLabel(tp,11561051)
	local dun=res*500
	if flag then
		Duel.SetFlagEffectLabel(tp,11561051,flag+dun)
	else
		Duel.RegisterFlagEffect(tp,11561051,RESET_EVENT+RESETS_STANDARD,0,1,dun)
	end
	end
end

function c11561057.debug(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local flag=Duel.GetFlagEffectLabel(tp,11561051)
	Debug.Message("护盾值"..flag)
end
function c11561057.clcon(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffectLabel(tp,11561051)
	return flag and flag>0
end
function c11561057.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=0
end
function c11561057.Lpop(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffectLabel(tp,11561051)
	if Duel.GetLP(tp)<=0 and flag then
		if Duel.GetFlagEffectLabel(tp,11561051)>=2000 then
		Duel.SetLP(tp,2000)
		c:SetFlagEffectLabel(11561051,flag-2000)
		elseif Duel.GetFlagEffectLabel(tp,11561051)<2000 then
		Duel.SetLP(tp,flag)
		Duel.SetFlagEffectLabel(tp,11561051,0)
		end
	end
end
function c11561057.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_ZOMBIE+RACE_FIEND)
end

function c11561057.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMaterialCount()>0
end
function c11561057.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetHandler():GetMaterialCount(),0,0x1)
end
function c11561057.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1,e:GetHandler():GetMaterialCount())
	end
end
