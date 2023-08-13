--古代的素材
function c98920530.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c98920530.cost)
	e1:SetTarget(c98920530.target)
	e1:SetOperation(c98920530.activate)
	c:RegisterEffect(e1)
end
function c98920530.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7) and c:IsAbleToGraveAsCost() and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0,TYPES_NORMAL_TRAP_MONSTER,c:GetAttack(),c:GetDefense(),c:GetOriginalLevel(),RACE_MACHINE,ATTRIBUTE_EARTH)
end
function c98920530.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920530.costfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98920530.costfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c98920530.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920530.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local lv=tc:GetLevel()
	local cd=tc:GetCode()
	local atk=tc:GetBaseAttack()
	local def=tc:GetBaseDefense()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,cd,0,TYPES_NORMAL_TRAP_MONSTER,atk,def,lv,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP,0,0,lv,atk,def)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cd)
	c:RegisterEffect(e1)
end