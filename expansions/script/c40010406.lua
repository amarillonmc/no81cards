--清风之珠玉圣骑
local m=40010406
local cm=_G["c"..m]
cm.named_with_JewelPaladin=1
function cm.JewelPaladin(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_JewelPaladin
end
function cm.initial_effect(c)
	--spsummon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	e0:SetOperation(cm.jpop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)  
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2) 
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)	
end
function cm.jpfilter(c)
	return  c:IsType(TYPE_MONSTER)
end
function cm.jpop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.jpfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=-1 then return end
	--if Duel.GetFlagEffect(tp,m+2)>0 then return end
	if sg:GetCount()>0 and ft>0 then
		if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local g=Duel.SelectReleaseGroup(tp,cm.jpfilter,1,1,nil)
			Duel.Release(g,REASON_COST)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
			e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	else
		local g=Duel.SelectReleaseGroup(tp,cm.jpfilter,1,1,nil)
		Duel.Release(g,REASON_COST)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	--e:GetLabelObject():SetLabel(0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message("0")
	local rc=e:GetHandler():GetReasonCard()
	if rc then else rc=e:GetHandler():GetReasonEffect():GetHandler() end
	if rc then
		--Debug.Message("1")
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCountLimit(1)
		e1:SetLabelObject(rc)
		e1:SetOperation(cm.op2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local rc=e:GetLabelObject()
	--Debug.Message("2")
	if rc and rc==eg:GetFirst() and rc:GetSequence()==c:GetPreviousSequence() and rc:IsControler(tp) then
		--Debug.Message("3")
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,nil,0,0,tp,0)
	end
	e:Reset()
end
function cm.tgfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function cm.spfilter(c,e,tp)
	return cm.JewelPaladin(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)) or (Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and ft>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		local tg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		local tc=tg:GetFirst()
		if tc and Duel.Release(tc,REASON_COST) ~=0 and tc:IsLocation(LOCATION_GRAVE) then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			Duel.RegisterFlagEffect(tp,m,RESET_EVENT+0x1fe0000+RESET_CHAIN,EFFECT_FLAG_OATH,1)
		end
	end
	Duel.ResetFlagEffect(tp,m)
end

