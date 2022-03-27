local m=189106
local cm=_G["c"..m]
cm.name="菲亚梅塔-永炎凤凰人"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,function(c)return c:IsFusionSetCard(0xc008) and c:IsLevelAbove(6)end,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc008),true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetValue(60461804)
	c:RegisterEffect(e0)
	local e00=e0:Clone()
	e00:SetCode(EFFECT_ADD_SETCODE)
	e00:SetValue(0xc008)
	c:RegisterEffect(e00)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e)return Duel.GetLP(e:GetHandlerPlayer())>=6000 end)
	e1:SetValue(2500)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.seqtg)
	e2:SetOperation(cm.seqop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,m+100)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 end)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(0xff)
	e4:SetTargetRange(1,0)
	e4:SetLabelObject(e2)
	e4:SetTarget(function(e,te,tp)return te==e:GetLabelObject()end)
	e4:SetCost(cm.costchk)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(0x10000000+m)
	e6:SetRange(0xff)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
end
cm.material_setcode=0xc008
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and e:GetHandler():GetFlagEffect(m)==0 end
end
function cm.desfilter(c,tp,seq)
	local sseq=c:GetSequence()
	if c:IsControler(tp) then return sseq==5 and seq==3 or sseq==6 and seq==1 end
	if c:IsLocation(LOCATION_SZONE) then return sseq<5 and sseq==seq end
	if sseq<5 then return math.abs(sseq-seq)==1 or sseq==seq end
	if sseq>=5 then return sseq==5 and seq==1 or sseq==6 and seq==3 end
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
	if c:GetSequence()==seq then
		Duel.BreakEffect()
		local t1=Group.__add(c:GetColumnGroup(),c)
		local t2=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_ONFIELD,nil,tp,4-seq)
		if #t2==0 or Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))==0 then
			Duel.HintSelection(t1)
			Duel.Destroy(t1,REASON_EFFECT)
		else
			Duel.HintSelection(t2)
			Duel.Destroy(t2,REASON_EFFECT)
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		end
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then e1:SetReset(RESET_PHASE+PHASE_STANDBY,2) else e1:SetReset(RESET_PHASE+PHASE_STANDBY) end
	Duel.RegisterEffect(e1,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xc008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
function cm.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,m)
	return Duel.CheckLPCost(tp,ct*800)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,800)
end
