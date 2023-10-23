local m=53796147
local cm=_G["c"..m]
cm.name="电子光虫-开关马陆"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(cm.xyzlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(cm.scost)
	e1:SetTarget(cm.stg)
	e1:SetOperation(cm.sop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.adjustop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(cm.efcon)
	e3:SetOperation(cm.efop)
	c:RegisterEffect(e3)
end
function cm.xyzlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_INSECT)
end
function cm.cfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToRemoveAsCost() and c:IsFaceupEx()
end
function cm.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.__add(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil),Duel.GetOverlayGroup(tp,1,0):Filter(cm.cfilter,nil))
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_COST)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		e:GetHandler():CreateRelation(tc,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
		e:SetLabelObject(tc)
	end
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonable(true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsSummonable(true,nil) then return end
	local tc=e:GetLabelObject()
	if not tc or tc:GetFlagEffect(m)==0 or not c:IsRelateToCard(tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetOwnerPlayer(tp)
	e1:SetLabelObject(tc)
	e1:SetOperation(cm.spop)
	e1:SetReset(RESET_EVENT+0xfc0000)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetLabelObject(tc)
	e2:SetOperation(cm.checkop)
	Duel.RegisterEffect(e2,tp)
	tc:CreateEffectRelation(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_NEGATED)
	e3:SetLabelObject(e2)
	e3:SetOperation(cm.rstop)
	Duel.RegisterEffect(e3,tp)
	Duel.Summon(tp,c,true,nil)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) and tc:GetFlagEffect(m)>0 then
		e:GetOwner():RegisterFlagEffect(m+500,RESET_EVENT+0x1fc0000,0,1)
		tc:CreateRelation(e:GetOwner(),RESET_EVENT+RESETS_STANDARD)
	end
	e:Reset()
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local p=e:GetOwnerPlayer()
	if c:GetFlagEffect(m+500)>0 and tc:IsRelateToCard(c) and Duel.GetMZoneCount(p)>0 then Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEUP) end
	e:Reset()
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)==0 then c:RegisterFlagEffect(m,RESET_EVENT+0x17c0000,0,1) end
	local flag=c:GetFlagEffectLabel(m)
	if c:IsPosition(POS_ATTACK) then flag=flag|POS_ATTACK end
	if c:IsPosition(POS_DEFENSE) then flag=flag|POS_DEFENSE end
	c:SetFlagEffectLabel(m,flag)
end
function cm.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local label=c:GetFlagEffectLabel(m) or 0
	if label&POS_ATTACK~=0 then
		local e0=Effect.CreateEffect(rc)
		e0:SetDescription(aux.Stringid(m,1))
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_SOLVING)
		e0:SetRange(LOCATION_MZONE)
		e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e0:SetCondition(cm.negcon)
		e0:SetOperation(cm.negop)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e0,true)
	end
	if label&POS_DEFENSE~=0 then
		local e1=Effect.CreateEffect(rc)
		e1:SetDescription(aux.Stringid(m,4))
		e1:SetCategory(CATEGORY_POSITION)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetTarget(cm.postg)
		e1:SetOperation(cm.posop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1,true)
		local e1_1=e1:Clone()
		e1_1:SetCode(EVENT_SPSUMMON_SUCCESS)
		rc:RegisterEffect(e1_1,true)
		rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and rc:IsDefensePos() and Duel.IsChainDisablable(ev) and e:GetHandler():GetFlagEffect(m+250)==0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(m+250,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.posfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsCanChangePosition()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.posfilter,1,nil,1-tp) end
	local g=eg:Filter(cm.posfilter,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	if #g>1 then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE) tc=g:Select(tp,1,1,nil):GetFirst() end
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
end
