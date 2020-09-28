--宝具展开-虚荣的空中花园
function c9951328.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9951328+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9951328.activate)
	c:RegisterEffect(e1)
 --cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xba5))
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9951328.dircon)
	e1:SetTarget(c9951328.target)
	e1:SetOperation(c9951328.activate2)
	c:RegisterEffect(e1)
 --untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(c9951328.condition)
	e2:SetTarget(c9951328.etarget)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetCondition(c9951328.condition)
	e3:SetTarget(c9951328.etarget)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c9951328.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xba5) and c:IsAbleToHand()
end
function c9951328.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9951328.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9951328,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9951328.cfilter1(c)
	return c:IsFaceup() and c:IsLevelAbove(10) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xba5)
end
function c9951328.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c9951328.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9951328.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9951328,0xba5,0x21,4000,4000,10,RACE_MACHINE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9951328.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,9951328,0xba5,0x21,4000,4000,10,RACE_MACHINE,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_SPELL+TYPE_EFFECT)
	Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)
end
function c9951328.condition(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c9951328.etarget(e,c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c~=e:GetHandler()
end