--黑塔魔镜
function c60158208.initial_effect(c)
	aux.AddCodeList(c,60158001)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	--改卡名
	--aux.EnableChangeCode(c,60158001,LOCATION_SZONE,c60158208.e1con)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetCondition(c60158208.condition)
	e1:SetValue(60158001)
	c:RegisterEffect(e1)
	
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60158208,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c60158208.e1cost)
	e1:SetTarget(c60158208.e1tg)
	e1:SetOperation(c60158208.e1op)
	c:RegisterEffect(e1)
	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60158208,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,60158208)
	e2:SetTarget(c60158208.e2tg)
	e2:SetOperation(c60158208.e2op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end

	--改卡名
function c60158208.e1conf(c)
	return c:IsCode(60158001) and c:IsFaceup()
end
function c60158208.e1con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c60158208.e1conf,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function c60158208.cfilter(c)
	return c:IsFaceup() and c:IsCode(60158001)
end
function c60158208.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():GetLocation()==LOCATION_SZONE and not Duel.IsExistingMatchingCard(c60158208.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

	--to hand
function c60158208.e1costf(c,tp)
	return aux.IsCodeListed(c,60158001) and not c:IsCode(60158208) and c:IsAbleToGraveAsCost()
		and ((c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()) or (c:IsFaceup() or c:IsFacedown()))
end
function c60158208.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60158208.e1costf,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60158208.e1costf,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c60158208.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60158208.e1op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

	--spsummon
function c60158208.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc=e:GetHandler()
	local sccode=sc:GetCode()
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsPlayerCanSpecialSummonMonster(tp,sccode,0,TYPES_EFFECT_TRAP_MONSTER,1500,1500,2,RACE_MACHINE,ATTRIBUTE_WATER)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sc,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60158208.e2op(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetHandler()
	local sccode=sc:GetCode()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,sccode,0,TYPES_EFFECT_TRAP_MONSTER,1500,1500,2,RACE_MACHINE,ATTRIBUTE_WATER) then return end
	if not (sc:IsLocation(LOCATION_GRAVE) or (sc:IsLocation(LOCATION_REMOVED) and sc:IsFaceup())) then return end
	if sc:IsType(TYPE_SPELL) then 
		sc:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL,ATTRIBUTE_WATER,RACE_MACHINE,2,1500,1500) 
	elseif sc:IsType(TYPE_TRAP) then
		sc:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP,ATTRIBUTE_WATER,RACE_MACHINE,2,1500,1500)
	else
		return false 
	end
	sc:CancelToGrave()
	Duel.SpecialSummon(sc,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(60158208,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(60158101)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e1)
	--cannot link material
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetValue(c60158208.lmlimit)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e2)
end
function c60158208.lmlimit(e,c)
	if not c then return false end
	return not (c:IsCode(60158001) or c:IsCode(60158101))
end