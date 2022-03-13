local m=15000810
local cm=_G["c"..m]
cm.name="空中都市 赛德尼纲"
function cm.initial_effect(c)
	c:EnableCounterPermit(0xf3c)
	c:SetCounterLimit(0xf3c,8)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(15000810)
	e1:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e1)
	--Add Counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.countercon)
	e3:SetOperation(cm.counterop)
	c:RegisterEffect(e3)
	--Remove counter replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_RCOUNTER_REPLACE+0xf3c)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.rcon)
	e4:SetOperation(cm.rop)
	c:RegisterEffect(e4)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1,15000810)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	if not cm.global_effect then
		cm.global_effect=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetCondition(cm.chcon)
		ge1:SetOperation(cm.chop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.counterfilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.countercon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.counterfilter,1,nil)
end
function cm.counterop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xf3c,1)
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActivated() and bit.band(r,REASON_COST)~=0 and ep==e:GetOwnerPlayer() and e:GetHandler():GetCounter(0xf3c)>=ev
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0xf3c,ev,REASON_EFFECT)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3f3c) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)~=0) or (c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)~=0))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_PENDULUM) and rc:IsAttribute(ATTRIBUTE_WIND) and re:GetOperation() and re:IsActivated()
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local op=re:GetOperation()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(15000810)
	e1:SetTargetRange(1,0)
	e1:SetOperation(op)
	e1:SetLabelObject(re)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,0)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.selfilter(c)
	return c:GetEffectCount(15000810)~=0 and not c:IsDisabled()
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=Duel.IsPlayerAffectedByEffect(0,15000810)
	if not se then se=Duel.IsPlayerAffectedByEffect(1,15000810) end
	local op=nil
	if se then
		local x=1
		for _,i in ipairs{Duel.IsPlayerAffectedByEffect(0,15000810)} do
			if i:GetLabelObject()==e and x~=0 then
				op=i:GetOperation()
				i:Reset()
				x=0
			end
		end
	end
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	local ag=Duel.GetMatchingGroup(cm.selfilter,tp,LOCATION_FZONE,LOCATION_FZONE,nil)
	if ag:GetCount()==0 then return end
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and seq<=4 and ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))) and Duel.SelectYesNo(tp,aux.Stringid(15000810,0)) then
		Duel.BreakEffect()
		if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
			or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
			local flag=0
			if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
			if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
			flag=bit.bxor(flag,0xff)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
			local nseq=0
			if s==1 then nseq=0
			elseif s==2 then nseq=1
			elseif s==4 then nseq=2
			elseif s==8 then nseq=3
			else nseq=4 end
			Duel.MoveSequence(c,nseq)
		end
	end
	if c:IsLocation(LOCATION_PZONE) and c:IsFaceup() and ((Duel.GetFieldCard(tp,LOCATION_PZONE,0)==c and Duel.CheckLocation(tp,LOCATION_PZONE,1)) or (Duel.GetFieldCard(tp,LOCATION_PZONE,1)==c and Duel.CheckLocation(tp,LOCATION_PZONE,0)) and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,c)) and Duel.SelectYesNo(tp,aux.Stringid(15000810,0)) then
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,c) then return end
		if Duel.GetFieldCard(tp,LOCATION_PZONE,0)==c and Duel.CheckLocation(tp,LOCATION_PZONE,1) then
			Duel.MoveSequence(c,4)
		elseif Duel.GetFieldCard(tp,LOCATION_PZONE,1)==c and Duel.CheckLocation(tp,LOCATION_PZONE,0) then
			Duel.MoveSequence(c,0)
		end
	end
end