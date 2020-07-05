--天灾信使·狙击干员-普罗旺斯
function c79029106.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3,c79029106.ovfilter,aux.Stringid(22,0))
	c:EnableReviveLimit()   
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23232295,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c79029106.atkcost)
	e1:SetOperation(c79029106.atkop)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c79029106.lzop)
	e1:SetTarget(c79029106.lztg)
	c:RegisterEffect(e1)
	--Negate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_NEGATE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c79029106.discon)
	e5:SetCost(c79029106.discost)
	e5:SetTarget(c79029106.distg)
	e5:SetOperation(c79029106.disop)
	c:RegisterEffect(e5)
end
function c79029106.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsRank(8)
end
function c79029106.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029106.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
		e1:SetValue(c:GetAttack()*2)
		c:RegisterEffect(e1)
	end
end
function c79029106.drfilter(c,e,tp)
	return c:IsReason(REASON_COST) and c:IsPreviousLocation(LOCATION_OVERLAY) and c:GetPreviousSequence()==e:GetHandler():GetSequence() and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029106.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c79029106.drfilter,1,nil,e,tp)  end
end
function c79029106.lzop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c79029106.drfilter,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c79029106.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79029106.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c79029106.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c79029106.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	Duel.Destroy(eg,REASON_EFFECT)
end

