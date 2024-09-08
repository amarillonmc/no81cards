--大贤良师
local m=88881085
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--indes
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_RELEASE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetTarget(cm.pentg)
	e5:SetOperation(cm.penop)
	c:RegisterEffect(e5)
	--  
	local e6=Effect.CreateEffect(c)  
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)  
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(cm.op)  
	c:RegisterEffect(e6)  
	if not cm.global_flag then
		cm.global_flag=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_CHAINING)
		ge0:SetOperation(cm.regop)
		Duel.RegisterEffect(ge0,0)
	end
	cm.onfield_effect=e3
	cm.SetCard_diyuemo=true
end
function cm.op(e,tp,eg,ep,ev,re,r,rp) 
	Debug.Message("雷池铸剑，今霜刃即成，当振天下于大白！")
	Debug.Message("融合召唤！等级12！大贤良师！")
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m,0,0,0)
	Duel.RegisterFlagEffect(1,m,0,0,0)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.sprfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsReleasable() and c:IsType(TYPE_MONSTER)
end
function cm.sprfilter1(c)
	return c:IsCode(88800020) and c:IsReleasable() and c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local flag=Duel.GetFlagEffect(tp,m)
	return 
	(flag>=36 or Duel.IsExistingMatchingCard(cm.sprfilter,tp,LOCATION_MZONE,0,36-flag,nil)) and Duel.IsExistingMatchingCard(cm.sprfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local flag=Duel.GetFlagEffect(tp,m)
	local g=Group.CreateGroup()
	if flag>=36 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=Duel.SelectMatchingCard(tp,cm.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	else
		local g1=Duel.SelectMatchingCard(tp,cm.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil)
		local g2=Duel.SelectMatchingCard(tp,cm.sprfilter,tp,LOCATION_MZONE,0,36-flag,36-flag,g1)
		g=Group.__add(g1,g2)
	end
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eeg=Duel.GetMatchingGroupCount(Card.IsReleasable,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 and eeg>0 end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,g:GetCount(),0,0)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.Release(g,REASON_EFFECT)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousPosition(POS_FACEUP)
end