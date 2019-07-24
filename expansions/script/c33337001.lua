--断码者 七
local m=33337001
local cm=_G["c"..m]
if not RSUNLINKVAL then
	RSUNLINKVAL=RSUNLINKVAL or {}
	rsukv=RSUNLINKVAL
function rsukv.UnLinkProcedure(c,...)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_REPEAT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetOperation(rsukv.disop(...))
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(rsukv.indestg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function rsukv.indestg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function rsukv.disop(...)
	local zone={...}
	return function(e,tp)
		local c=e:GetHandler()
		local seq=c:GetSequence()
		local fzone=0x0
		for _,v in ipairs(zone) do
			if v==1 then
				if seq==5 then fzone=fzone+0x100000 end
				if seq==6 then fzone=fzone+0x40000 end
				if seq==2 then fzone=fzone+0x20 end
				if seq==4 then fzone=fzone+0x40 end
			end
			if v==2 then
				if seq==5 then fzone=fzone+0x80000 end
				if seq==6 then fzone=fzone+0x20000 end
				if seq==1 then fzone=fzone+0x20 end
				if seq==3 then fzone=fzone+0x40 end
			end
			if v==3 then 
				if seq==5 then fzone=fzone+0x40000 end
				if seq==6 then fzone=fzone+0x10000 end
				if seq==0 then fzone=fzone+0x20 end
				if seq==2 then fzone=fzone+0x40 end
			end
			if v==4 then 
				if seq>0 and seq<5 then fzone=fzone+2^(seq-1) end
			end
			if v==5 then 
				if seq<4 then fzone=fzone+2^(seq+1) end
			end
			if v==6 then 
				if seq==5 then fzone=fzone+0x1 end
				if seq==6 then fzone=fzone+0x4 end
			end
			if v==7 then 
				if seq==5 then fzone=fzone+0x2 end
				if seq==6 then fzone=fzone+0x8 end
			end
			if v==8 then 
				if seq==5 then fzone=fzone+0x4 end
				if seq==6 then fzone=fzone+0x16 end
			end
		end
		return fzone
	end
end
rsukv.RegisterEffect2=Duel.RegisterEffect
rsukv.RegisterEffect=Card.RegisterEffect
function Card.RegisterEffect(c,e,force)
	local code=e:GetCode()
	local codetbl={ EFFECT_UPDATE_ATTACK,EFFECT_SET_ATTACK,EFFECT_SET_ATTACK_FINAL }
	for _,v in ipairs(codetbl) do
		if code==v then
			local value=e:GetValue()
			e:SetValue(rsukv.value(value))
		end
	end
	rsukv.RegisterEffect(c,e,force)
end
function Duel.RegisterEffect(e,tp)
	local code=e:GetCode()
	local codetbl={ EFFECT_UPDATE_ATTACK,EFFECT_SET_ATTACK,EFFECT_SET_ATTACK_FINAL }
	for _,v in ipairs(codetbl) do
		if code==v then
			local value=e:GetValue()
			e:SetValue(rsukv.value(value))
		end
	end
	rsukv.RegisterEffect2(e,tp)
end
function rsukv.value(value)
	return function(e,c,...)
		if c.UnLink then return 0 end
		return value 
	end
end

end

if cm then
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	--aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,99)
	aux.AddLinkProcedure(c,cm.matfilter,2,99)
	rsukv.UnLinkProcedure(c,2,7)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(function(e,tp) return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) end)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetTarget(cm.cttg)
	e4:SetOperation(cm.ctop)
	c:RegisterEffect(e4)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(function(e,tp) return e:GetHandler():GetLinkedGroupCount()>0 end)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.desreptg)
	e3:SetOperation(cm.desrepop)
	c:RegisterEffect(e3)
end
cm.UnLink=true 
function cm.matfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsLinkAbove(2)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged(false,zone) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil,false,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil,false,zone)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,0,0,zone)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e3:SetValue(LOCATION_DECKBOT)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DIRECT_ATTACK)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end
function cm.repfilter(c,e,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetLinkedGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(cm.repfilter,1,nil,e,tp)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local g=c:GetLinkedGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local sg=g:FilterSelect(tp,cm.repfilter,1,1,nil,e,tp)
		e:SetLabelObject(sg:GetFirst())
		sg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function cm.cfilter(c)
	return c:GetSequence()<5
end
function cm.filter(c,e,tp,zone1,zone2)
	return ((zone1>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone1)) or (zone2>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone2)))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone1=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	local zone2=bit.band(e:GetHandler():GetLinkedZone(1-tp),0x1f)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and cm.filter(chkc,e,tp,zone) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp,zone1,zone2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,zone1,zone2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local zone1=bit.band(c:GetLinkedZone(tp),0x1f)
	local zone2=bit.band(c:GetLinkedZone(1-tp),0x1f)
	if not tc or not tc:IsRelateToEffect(e) then return end
	local b1=zone1>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone1)
	local b2=zone2>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone2)
	if not b1 and not b2 then return end
	local p,zone=0,0
	if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
		p=tp zone=zone1
	else
		p=1-tp zone=zone2
	end
	if Duel.SpecialSummonStep(tc,0,tp,p,false,false,POS_FACEUP,zone) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e3:SetValue(LOCATION_DECKBOT)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DIRECT_ATTACK)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
	Duel.SpecialSummonComplete()
end


end
