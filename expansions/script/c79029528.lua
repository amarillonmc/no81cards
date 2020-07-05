--CiNo.104 假面魔蹈士 虚无
function c79029528.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,5)
	c:EnableReviveLimit()
	--negate activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49456901,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_HANDES)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c79029528.condition)
	e1:SetCost(c79029528.cost)
	e1:SetTarget(c79029528.target)
	e1:SetOperation(c79029528.operation)
	c:RegisterEffect(e1)  
	--add card
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCost(c79029528.cost)
	e2:SetTarget(c79029528.actg)
	e2:SetOperation(c79029528.acop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(c79029528.sptg)
	e3:SetOperation(c79029528.spop)
	c:RegisterEffect(e3) 
end
c79029528.xyz_number=104
function c79029528.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
	and Duel.IsChainNegatable(ev)
end
function c79029528.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029528.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetChainLimit(c79029528.chlimit)
end
function c79029528.chlimit(e,ep,tp)
	return tp==ep
end
function c79029528.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT) and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0
		and Duel.SelectYesNo(tp,aux.Stringid(79029528,0)) then
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(1-tp,1)
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
	end
end
function c79029528.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetTargetCard(g)
end
function c79029528.acop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	local code=tc:GetOriginalCode()  
	local rc=Duel.CreateToken(tp,code)
		if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and (not rc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp)>0) then
			Duel.BreakEffect()
			Duel.Remove(rc,POS_FACEUP,REASON_RULE)
			Duel.SpecialSummon(rc,0,tp,tp,true,true,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,rc)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and rc:IsSSetable() then
			Duel.BreakEffect()
			Duel.Remove(rc,POS_FACEUP,REASON_RULE)
			Duel.SSet(tp,rc)
			Duel.ConfirmCards(1-tp,rc)
end
end
function c79029528.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x48) end
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0x48)
	Duel.SetTargetCard(g)
end
function c79029528.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsImmuneToEffect(e) then return end   
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)~=0 then
	Duel.Overlay(e:GetHandler(),tc)
end
end




