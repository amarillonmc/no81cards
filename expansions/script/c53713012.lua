local m=53713012
local cm=_G["c"..m]
cm.name="爱丽丝役 Web"
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(0xff)
	e0:SetCost(cm.spcost)
	e0:SetOperation(cm.spcop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.fscon)
	e1:SetOperation(cm.fsop)
	c:RegisterEffect(e1)
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e2:SetCode(EFFECT_SPSUMMON_PROC)
	--e2:SetRange(LOCATION_EXTRA)
	--e2:SetCondition(cm.hspcon)
	--e2:SetOperation(cm.hspop)
	--sc:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	e4:SetCondition(cm.con)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(m)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.fakefilter(c)
	return c:GetSequence()>4
end
function cm.tffilter(c,tp)
	return bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetMatchingGroupCount(cm.fakefilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)<2)
end
function cm.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION then
		e:SetLabel(1)
		return Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	else
		e:SetLabel(0)
		return true
	end
end
function cm.spcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return true end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		tc=g:GetNext()
	end
end
function cm.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	if gc then return false end
	local c=e:GetHandler()
	local tp=c:GetControler()
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,Group.CreateGroup(),c) then return false end
	local chkf=(chkfnf & 0xff)
	return chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(chkf)>-1
end
function cm.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	Duel.SetFusionMaterial(Group.CreateGroup())
end
function cm.hspfilter(c,tp,sc)
	return c:IsFaceup() and c:IsOriginalSetCard(0x1535) and bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 and c:GetFlagEffect(53713012)==0 and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL) and c:IsAbleToHandAsCost()
end
function cm.hspcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cm.hspfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil,tp,c)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.hspfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.cfilter(c,tp)
	return c:IsOriginalSetCard(0x535) and c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetOriginalCodeRule())
end
function cm.filter(c,code)
	return c:IsSetCard(0x1535) and c:IsType(TYPE_TRAP) and c:IsSSetable(true) and not c:IsOriginalCodeRule(code)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	e:SetValue(sg:GetFirst():GetOriginalCodeRule())
	Duel.SendtoGrave(sg,REASON_COST)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e:GetValue())
	if g:GetCount()>0 and Duel.SSet(tp,g:GetFirst())~=0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end
