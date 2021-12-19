--极光战姬 基尔娜布鲁
local m=40009615
local cm=_G["c"..m]
cm.named_with_AuroraBattlePrincess=1
function cm.AuroraBattlePrincess(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AuroraBattlePrincess
end
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,cm.mfilter,3,2)
	c:EnableReviveLimit()   
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.xccon1)
	e1:SetTarget(cm.xctg)
	e1:SetOperation(cm.xcop)
	c:RegisterEffect(e1) 
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.xccon2)
	c:RegisterEffect(e3)
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
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon2)
	e2:SetCost(cm.atkcost)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)   
end
function cm.mfilter(c)
	return cm.AuroraBattlePrincess(c)
end
function cm.xccon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetFlagEffect(m)>0 and not Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function cm.xccon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetFlagEffect(m)>0 and Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function cm.xctgfilter(c)
	return c:IsFaceup() and c:IsCode(40009623) 
end
function cm.xctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.xctgfilter,tp,LOCATION_FZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.xcop(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.GetMatchingGroup(cm.xctgfilter,tp,LOCATION_FZONE,0,nil)
	local g1=Duel.GetDecktopGroup(1-tp,3)
	if g0:GetCount()>0 and g1:GetCount()>0 then
		local g2=Duel.SelectMatchingCard(tp,cm.xctgfilter,tp,LOCATION_FZONE,0,1,1,nil)
		Duel.HintSelection(g2)
		--local sg=g1:RandomSelect(1-tp,1)
		local tc=g2:GetFirst()
		Duel.DisableShuffleCheck()
		Duel.Overlay(tc,g1)
	end
end
function cm.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD) 
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_FZONE,0,1,nil) and aux.dscon
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.xctgfilter,tp,LOCATION_FZONE,0,nil)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(tc:GetOverlayCount()*500)
	--e1:SetValue(cm.atkval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function cm.xctgfilter(c)
	return c:IsFaceup() and c:IsCode(40009623) 
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.xctgfilter,c:GetControler(),LOCATION_FZONE,0,nil,Duel.GetOverlayCount())*500
end
