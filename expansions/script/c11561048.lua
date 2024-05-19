--裁决之雷 依里
local m=11561048
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4,c11561048.lcheck)
	c:EnableReviveLimit()
	--count
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11561048)
	e1:SetCondition(c11561048.ctcon)
	e1:SetTarget(c11561048.cttg)
	e1:SetOperation(c11561048.ctop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11561048,0))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11571048)
	e2:SetCost(c11561048.ctcost2)
	e2:SetTarget(c11561048.cttg2)
	e2:SetOperation(c11561048.ctop2)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11561048,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetCost(c11561048.decost)
	e3:SetTarget(c11561048.detg)
	e3:SetOperation(c11561048.deop)
	c:RegisterEffect(e3)
	
	
end
function c11561048.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_ZOMBIE+RACE_FIEND)
end
function c11561048.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,3,REASON_COST)
end
function c11561048.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetLP(tp)<6001) or (Duel.IsExistingMatchingCard(c11561048.ssqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLP(tp)<4001) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,nil,1-tp,LOCATION_ONFIELD)
end
function c11561048.ssqfilter(c)
	return c:GetSequence()>4
end
function c11561048.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetLP(tp)<6001 then
		ops[off]=aux.Stringid(11561048,3)
		opval[off-1]=1
		off=off+1
	end
	if (Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) or Duel.IsExistingMatchingCard(c11561048.ssqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)) and Duel.GetLP(tp)<4001 then
		ops[off]=aux.Stringid(11561048,4)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetLP(tp)<2001 then
		ops[off]=aux.Stringid(11561048,5)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif opval[op]==2 then
	   local filter=0
	   for i=0,15 do
			if not Duel.IsExistingMatchingCard(c11561048.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,i,tp) then
				filter=filter|1<<(i+16)
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local flag=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,filter)
		Duel.Hint(HINT_ZONE,tp,flag)
		local seq=math.log(flag>>16,2)
		local dg=Duel.GetMatchingGroup(c11561048.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,seq,tp)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	elseif opval[op]==3 then
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

function c11561048.exmzfilter(c,seq)
	return (c:GetControler()==tp and c:GetSequence()==seq) or (c:GetControler()~=tp and c:GetSequence()==11-seq)
end
function c11561048.seqfilter(c,seq,tp)
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and loc==LOCATION_SZONE then return false end
	if seq==7 and loc==LOCATION_MZONE then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if c:GetControler()==tp and cseq<=4 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and ((c:GetControler()~=tp and (seq==1 and cseq==5 or seq==3 and cseq==6 or seq==cseq)) or (c:GetControler()==tp and (seq==1 and cseq==6 or seq==3 and cseq==5))) then return true end
	if cloc==LOCATION_MZONE and seq>=5 and loc==LOCATION_MZONE and Duel.IsExistingMatchingCard(c11561048.exmzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,seq) then
		return (c:GetControler()~=tp and (seq==5 and cseq==1 or seq==6 and cseq==3)) or (c:GetControler()==tp  and (seq==5 and cseq==3) or (seq==6 and cseq==1))
	end
	return (c:GetControler()~=tp and (cseq==seq or seq<5 and cseq<5 and cloc==loc and math.abs(cseq-seq)==1)) or (c:GetControler()==tp and seq>=5 and ((seq==5 and cseq==3) or (seq==6 and cseq==1)))
end
function c11561048.ctcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(100)
		return true
	end
end
function c11561048.cttg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c:GetLinkedGroupCount()>0 and Duel.CheckLPCost(tp,c:GetLinkedGroupCount()*2000,true)
	end
	Duel.PayLPCost(tp,c:GetLinkedGroupCount()*2000,true)
	e:SetLabel(c:GetLinkedGroupCount())
end
function c11561048.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x1,e:GetLabel())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end



function c11561048.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMaterialCount()>0
end
function c11561048.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetHandler():GetMaterialCount(),0,0x1)
end
function c11561048.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1,e:GetHandler():GetMaterialCount())
	end
end