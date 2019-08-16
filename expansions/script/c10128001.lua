--奇妙物语 番茄大师
function c10128001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10128001,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c10128001.target)
	e1:SetOperation(c10128001.activate)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10128001,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10128001.sptg)
	e2:SetOperation(c10128001.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--remain field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e4) 
end
function c10128001.spfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6336) and c:GetSequence()<5 and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x6336,0x21,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH)
end
function c10128001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return eg:GetCount()==1 and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,e:GetHandler():GetCode(),0x6336,0x21,tc:GetBaseAttack(),tc:GetBaseDefense(),1,RACE_PLANT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_SZONE)
end
function c10128001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),eg:GetFirst()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x6336,0x21,tc:GetBaseAttack(),tc:GetBaseDefense(),1,RACE_PLANT,ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_EARTH,RACE_PLANT,1,tc:GetBaseAttack(),tc:GetBaseDefense())
	Duel.SpecialSummonStep(c,1,tp,tp,true,false,POS_FACEUP)
	--c:AddMonsterAttributeComplete()
	Duel.SpecialSummonComplete()
end
function c10128001.thfilter(c)
	return c:IsSetCard(0x6336) and c:IsAbleToHand() and not c:IsCode(10128001) and c:IsFaceup()
end
function c10128001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_ONFIELD)
end
function c10128001.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c10128001.thfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if tg:GetCount()<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10128001,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=tg:Select(tp,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end