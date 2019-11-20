--DEM 鸢一折纸 莫德雷德
function c33400435.initial_effect(c)
	  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc343),6,2)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400435,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c33400435.eqcon)
	e2:SetTarget(c33400435.eqtg)
	e2:SetOperation(c33400435.eqop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400435,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCountLimit(1,33400435)
	e3:SetCondition(c33400435.atkcon)
	e3:SetCost(c33400435.atkcost)
	e3:SetOperation(c33400435.atkop)
	c:RegisterEffect(e3)
   --actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetCondition(c33400435.actcon)
	c:RegisterEffect(e4)
end
function c33400435.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400435.filter(c,e,tp,ec)
	return c:IsCode(33400460)  and c:CheckEquipTarget(ec)and c:CheckUniqueOnField(tp)
end
function c33400435.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c33400435.filter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,0,0,0,0)
end
function c33400435.eqop(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsExistingMatchingCard(c33400435.filter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,e:GetHandler())
	or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0  then return false end
	local g=Duel.GetMatchingGroup(c33400435.filter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:Select(tp,1,1,nil)
	local tc=g1:GetFirst() 
	 Duel.Equip(tp,tc,e:GetHandler())
end

function c33400435.atkcon(e,tp,eg,ep,ev,re,r,rp)
local zg=e:GetHandler():GetEquipGroup()
	return e:GetHandler():GetBattleTarget()~=nil and zg:IsExists(Card.IsSetCard,1,nil,0x6343) 
end
function c33400435.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST)  end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33400435.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetHandler():GetBattleTarget():GetAttack()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end

function c33400435.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400435.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400435.actcon(e)
local tc=e:GetHandler():GetBattleTarget()
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() and (tc:IsSetCard(0x341) or (Duel.IsExistingMatchingCard(c33400435.cccfilter1,tp,LOCATION_SZONE,0,1,nil) or 
	Duel.IsExistingMatchingCard(c33400435.cccfilter2,tp,LOCATION_MZONE,0,1,nil)))
end
