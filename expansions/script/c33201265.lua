--混沌龙契 枪皇罗索夫
local m=33201265
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(0)
	c:RegisterEffect(e0)
	--neg
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.negcon)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(cm.sscon)
	e2:SetTarget(cm.sstg)
	e2:SetOperation(cm.ssop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	--atk check
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.VHisc_DragonCovenant=true

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,0,0,1)
	Duel.RegisterFlagEffect(1-tp,m,0,0,1)
end

function cm.cfilter(c,tp)
	return c:IsControler(1-tp)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and e:GetHandler():GetEquipGroup():IsExists(function(ec) return ec.VHisc_DragonRelics end,1,nil)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local neg=eg:Filter(cm.cfilter,nil,tp)
	if neg:GetCount()>0 then
		local c=e:GetHandler()
		for tc in aux.Next(neg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e1:SetTarget(cm.distg)
			e1:SetLabelObject(tc)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(cm.discon)
			e2:SetOperation(cm.disop)
			e2:SetLabelObject(tc)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

function cm.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetFlagEffect(tp,m)>=10 and not Duel.CheckPhaseActivity()
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end