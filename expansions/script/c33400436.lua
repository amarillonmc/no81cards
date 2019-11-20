--DEM 爱莲·米拉·梅瑟斯
function c33400436.initial_effect(c)
	 aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc343),8,3)
	 --Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400436,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c33400436.eqcon)
	e1:SetTarget(c33400436.eqtg)
	e1:SetOperation(c33400436.eqop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400436,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c33400436.atkcon)
	e2:SetCost(c33400436.atkcost)
	e2:SetOperation(c33400436.atkop)
	c:RegisterEffect(e2)
	--inm
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400436,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33400436)
	e3:SetCondition(c33400436.condition)
	e3:SetTarget(c33400436.destg)
	e3:SetOperation(c33400436.operation3)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetCondition(c33400436.actcon)
	c:RegisterEffect(e4)
end
function c33400436.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400436.filter(c,e,tp,ec)
	return c:IsCode(33400462)  and c:CheckEquipTarget(ec)and c:CheckUniqueOnField(tp)
end
function c33400436.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c33400436.filter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,0,0,0,0)
end
function c33400436.eqop(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsExistingMatchingCard(c33400436.filter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,e:GetHandler())
	or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0  then return false end
	local g=Duel.GetMatchingGroup(c33400436.filter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:Select(tp,1,1,nil)
	local tc=g1:GetFirst() 
	 Duel.Equip(tp,tc,e:GetHandler())
end

function c33400436.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetAttack()<c:GetBaseAttack()and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x6343)
end
function c33400436.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST)  end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33400436.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(3000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

function c33400436.cfilter2(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==1-tp
end
function c33400436.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33400436.cfilter2,1,nil,tp)
end
function c33400436.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,0,0,0)
end
function c33400436.operation3(e,tp,eg,ep,ev,re,r,rp)
   if Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

function c33400436.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end