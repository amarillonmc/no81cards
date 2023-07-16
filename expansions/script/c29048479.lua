--方舟骑士-空弦
c29048479.named_with_Arknight=1
local m=29048479
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,cm.syf,1,99)
	c:EnableReviveLimit()
	--Effect 1
	local e02=Effect.CreateEffect(c)
	e02:SetDescription(aux.Stringid(m,0))
	e02:SetCategory(CATEGORY_DESTROY)
	e02:SetType(EFFECT_TYPE_QUICK_O)
	e02:SetCode(EVENT_FREE_CHAIN)
	e02:SetRange(LOCATION_MZONE)
	e02:SetCountLimit(1,m)
	e02:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e02:SetTarget(cm.destg)
	e02:SetOperation(cm.desop)
	c:RegisterEffect(e02)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
	local e12=e2:Clone()
	e12:SetValue(cm.tval)
	c:RegisterEffect(e12)
	--synchro level
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SYNCHRO_LEVEL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(cm.slevel)
	c:RegisterEffect(e4)
end
function cm.slevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	return (6<<16)+lv
end
--synchro summon rule filter
function cm.syf(c,syc)
	local setcard=(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
	return c:GetSynchroLevel(syc)>0 and setcard and c:IsCanBeSynchroMaterial(syc)
end
--Effect 1
function cm.df(c,tp)
	if c:IsLocation(LOCATION_FZONE) then return false end
	local seq=c:GetSequence()
	local zzchk=false
	if c:IsLocation(LOCATION_MZONE) then
		zzchk=true
	end
	return  Duel.IsExistingMatchingCard(cm.zf,tp,0,LOCATION_ONFIELD,1,nil,tp,seq,zzchk)
end
function cm.zf(c,tp,seq,zzchk)
	local sseq=c:GetSequence()
	if zzchk==true then
		if seq>4 then
			if seq==5 then
				return c:IsLocation(LOCATION_MZONE) and sseq==1
			else
				return c:IsLocation(LOCATION_MZONE) and sseq==3 
			end
		else
			local seqchk1
			if seq==4 then
				seqchk1=(c:IsLocation(LOCATION_SZONE) and sseq==4) or (c:IsLocation(LOCATION_MZONE) and sseq==3)
			elseif seq==3 then
				seqchk1=(c:IsLocation(LOCATION_SZONE) and sseq==3) or (c:IsLocation(LOCATION_MZONE) and (sseq==4 or sseq==2)) or (c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and sseq==6)
			elseif seq==2 then
				seqchk1=(c:IsLocation(LOCATION_SZONE) and sseq==2) or (c:IsLocation(LOCATION_MZONE) and (sseq==3 or sseq==1))
			elseif seq==1 then
				seqchk1=(c:IsLocation(LOCATION_SZONE) and sseq==1) or (c:IsLocation(LOCATION_MZONE) and (sseq==2 or sseq==0)) or (c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and sseq==5)
			elseif seq==0 then
				seqchk1=(c:IsLocation(LOCATION_SZONE) and sseq==0) or (c:IsLocation(LOCATION_MZONE) and sseq==1)
			end
			return seqchk1
		end
	else
		local seqchk2
		if seq==4 then
			seqchk2=(c:IsLocation(LOCATION_MZONE) and sseq==4) or (c:IsLocation(LOCATION_MZONE) and sseq==3)
		elseif seq==3 then
			seqchk2=(c:IsLocation(LOCATION_MZONE) and sseq==3) or (c:IsLocation(LOCATION_SZONE) and (sseq==4 or sseq==2))
		elseif seq==2 then
			seqchk2=(c:IsLocation(LOCATION_MZONE) and sseq==2) or (c:IsLocation(LOCATION_SZONE) and (sseq==3 or sseq==1))
		elseif seq==1 then
			seqchk2=(c:IsLocation(LOCATION_MZONE) and sseq==1) or (c:IsLocation(LOCATION_SZONE) and (sseq==2 or sseq==0))
		elseif seq==0 then
			seqchk2=(c:IsLocation(LOCATION_MZONE) and sseq==0) or (c:IsLocation(LOCATION_MZONE) and sseq==1) 
		end
		return seqchk2
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.df,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,1-tp,LOCATION_ONFIELD)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.df,tp,0,LOCATION_ONFIELD,nil,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tag=g:Select(tp,1,1,nil)
	if #tag==0 then return end
	Duel.HintSelection(tag)
	local tc=tag:GetFirst()
	local seq=tc:GetSequence()
	local zzchk=false
	if tc:IsLocation(LOCATION_MZONE) then
		zzchk=true
	end
	if Duel.Destroy(tc,REASON_EFFECT)==0 then return false end
	local dg=Duel.GetMatchingGroup(cm.zf,tp,0,LOCATION_ONFIELD,nil,tp,seq,zzchk)
	if #dg==0 then return false end
	Duel.BreakEffect()
	local ct=3
	local dsg
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		dsg=dg:Select(tp,1,1,nil)
		Duel.HintSelection(dsg)
		if Duel.Destroy(dsg,REASON_EFFECT)>0 then
			dg:Sub(dsg)
			ct=ct-1
		else
			if dg:FilterCount(aux.TRUE,dsg)>0 then 
				ct=ct-1
			else
				ct=0
			end
		end   
	until ct==0   
end
--Effect 2
function cm.val(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end 
function cm.tval(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end 