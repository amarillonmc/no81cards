--神造遗物 幻体
function c72409085.initial_effect(c)
	aux.AddCodeList(c,72409000)
	aux.AddCodeList(c,72409025)
	c:SetUniqueOnField(1,0,72409085)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c72409085.target)
	e1:SetOperation(c72409085.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72409085,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetCountLimit(1)
	e2:SetCondition(c72409085.igcon)
	e2:SetTarget(c72409085.indtg)
	e2:SetOperation(c72409085.indop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c72409085.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72409085,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1)
	e4:SetCondition(c72409085.qccon)
	e4:SetTarget(c72409085.indtg)
	e4:SetOperation(c72409085.indop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c72409085.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c72409085.eqlimit)
	c:RegisterEffect(e6)
end
function c72409085.eqlimit(e,c)
	return c:IsSetCard(0xe729)
end
function c72409085.filter(c)
	return c:IsFaceup()  and c:IsSetCard(0xe729)
end
function c72409085.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c72409085.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72409085.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c72409085.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c72409085.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)  
	end
end
function c72409085.igcon(e)
	return not (e:GetHandler():IsCode(72409000,724090205) or Duel.IsPlayerAffectedByEffect(tp,72409155) or e:GetHandler():IsHasEffect(72409155)) and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end

function c72409085.qccon(e)
   return aux.dscon() and (e:GetHandler():IsCode(72409000,72409025) or Duel.IsPlayerAffectedByEffect(tp,72409155) or e:GetHandler():IsHasEffect(72409155)) and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end

function c72409085.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function c72409085.chfilter(c)
	return c:IsControlerCanBeChanged()
end
function c72409085.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local atk=e:GetOwner():GetAttack()
	local def=e:GetOwner():GetDefense()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,72409045,0,0x4011,atk,def,1,RACE_PSYCHO,ATTRIBUTE_DARK,POS_FACEUP) end
  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c72409085.indop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetOwner():GetAttack()
	local def=e:GetOwner():GetDefense()
	local eq=e:GetOwner()
	e:SetLabelObject(eq)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,72409045,0,0x4011,atk,def,1,RACE_PSYCHO,ATTRIBUTE_DARK,POS_FACEUP)then return end
	local token=Duel.CreateToken(tp,72409045)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetOwner())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
		   e2:SetValue(def)
			token:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
	if Duel.IsExistingMatchingCard(c72409085.eqfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e) and Duel.SelectYesNo(tp,aux.Stringid(72409085,2)) then
		local gqe=Duel.SelectMatchingCard(tp,c72409085.eqfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,10,nil,e)
		local tg=Group.GetFirst(gqe)
		while tg do
			if tg:CheckEquipTarget(token) and tg:IsFaceup() and token:IsFaceup() then
			Duel.Equip(tp,tg,token)
			tg=Group.GetNext(gqe)
			end
		end
	end
end


function c72409085.eqfilter(c,e)
	local eq=e:GetLabelObject()
	return c:IsSetCard(0x6729) and c:IsType(TYPE_EQUIP) and c:GetEquipTarget()==eq and not c:IsCode(72409085) 
end