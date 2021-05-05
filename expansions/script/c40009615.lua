--极光战姬 基尔娜布鲁
function c40009615.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xbf1b),3,2)
	c:EnableReviveLimit()   
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009615,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c40009615.xccon1)
	e1:SetTarget(c40009615.xctg)
	e1:SetOperation(c40009615.xcop)
	c:RegisterEffect(e1) 
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c40009615.xccon2)
	c:RegisterEffect(e3)
	if not c40009615.global_check then
		c40009615.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(40009615)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end 
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009615,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,40009615)
	e2:SetCondition(c40009615.spcon2)
	e2:SetCost(c40009615.atkcost)
	e2:SetOperation(c40009615.atkop)
	c:RegisterEffect(e2)   
end
function c40009615.xccon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetFlagEffect(40009615)>0 and not Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function c40009615.xccon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetFlagEffect(40009615)>0 and Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function c40009615.xctgfilter(c)
	return c:IsFaceup() and c:IsCode(40009623) 
end
function c40009615.xctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009615.xctgfilter,tp,LOCATION_FZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c40009615.xcop(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.GetMatchingGroup(c40009615.xctgfilter,tp,LOCATION_FZONE,0,nil)
	local g1=Duel.GetDecktopGroup(1-tp,3)
	if g0:GetCount()>0 and g1:GetCount()>0 then
		local g2=Duel.SelectMatchingCard(tp,c40009615.xctgfilter,tp,LOCATION_FZONE,0,1,1,nil)
		Duel.HintSelection(g2)
		--local sg=g1:RandomSelect(1-tp,1)
		local tc=g2:GetFirst()
		Duel.DisableShuffleCheck()
		Duel.Overlay(tc,g1)
	end
end
function c40009615.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD) 
end
function c40009615.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40009615.cfilter2,tp,LOCATION_FZONE,0,1,nil) and aux.dscon
end
function c40009615.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009615.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40009615.xctgfilter,tp,LOCATION_FZONE,0,nil)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	--e1:SetTarget(c40009615.atktg)
	e1:SetValue(tc:GetOverlayCount()*500)
	--e1:SetValue(c40009615.atkval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function c40009615.atktg(e,c)
	return c:IsSetCard(0xb5)
end
function c40009615.xctgfilter(c)
	return c:IsFaceup() and c:IsCode(40009623) 
end
function c40009615.atkval(e,c)
	return Duel.GetMatchingGroupCount(c40009615.xctgfilter,c:GetControler(),LOCATION_FZONE,0,nil,Duel.GetOverlayCount())*500
end
