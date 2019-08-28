--吸血鬼
function c88990284.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),5,2)
	c:EnableReviveLimit()
	--charge
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88990284,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c88990284.mattg)
	e1:SetOperation(c88990284.matop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6039967,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c88990284.atkcon)
	e2:SetCost(c88990284.atkcost)
	e2:SetOperation(c88990284.atkop)
	c:RegisterEffect(e2)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88990284,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c88990284.spcon)
	e4:SetTarget(c88990284.sptg)
	e4:SetOperation(c88990284.spop)
	c:RegisterEffect(e4)
end
function c88990284.matfilter(c,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))  
	   and not c:IsType(TYPE_TOKEN) and c:IsSetCard(0x8e) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c88990284.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE) and c88990284.matfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c88990284.matfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c88990284.matfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,e:GetHandler(),tp)
	
end
function c88990284.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c88990284.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88990284.atkcon(e,tp,eg,ep,ev,re,r,rp)
      return Duel.GetAttackTarget()
	and (Duel.GetAttacker():IsControler(tp) and Duel.GetAttacker():IsRace(RACE_ZOMBIE)
	or Duel.GetAttackTarget():IsControler(tp) and Duel.GetAttackTarget():IsRace(RACE_ZOMBIE))
end
function c88990284.atkop(e,tp,eg,ep,ev,re,r,rp)
local c=Duel.GetAttacker()
	if c:IsControler(1-tp) then c=Duel.GetAttackTarget() end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c:GetBaseDefense()*2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e2)
	end

function c88990284.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=eg:GetFirst()
    return rc:IsRelateToBattle() and rc:IsSetCard(0x8e) and rc:IsFaceup() and rc:IsControler(tp)
end
function c88990284.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and bc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end		
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88990284.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
      Duel.SpecialSummon(Group.FromCards(c,tc),0,tp,tp,false,false,POS_FACEUP)
    end
end

