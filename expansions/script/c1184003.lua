--饮食艺术·狸子面包
function c1184003.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1184003,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,1184003)
	e1:SetTarget(c1184003.tg1)
	e1:SetOperation(c1184003.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1184003,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,1184003)
	e2:SetCost(c1184003.cost2)
	e2:SetTarget(c1184003.tg1)
	e2:SetOperation(c1184003.op1)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1184003,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1184003.tg3)
	e3:SetOperation(c1184003.op3)
	c:RegisterEffect(e3)
--
end
--
function c1184003.tfilter1_1(c)
	return c:IsSetCard(0x3e12) and c:IsType(TYPE_MONSTER)
		and not c:IsForbidden()
end
function c1184003.tfilter1_2(c)
	return c:IsSetCard(0x3e12) and c:IsFaceup()
end
function c1184003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE,0)
		local dt=Duel.GetMatchingGroup(c1184003.tfilter1_1,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)
		local mt=Duel.GetMatchingGroupCount(c1184003.tfilter1_2,tp,LOCATION_MZONE,0,nil)
		return mt>0 and dt>=mt and ft>=mt
	end
end
--
function c1184003.ofilter1(sg)
	return sg:GetClassCount(Card.GetCode)==sg:GetCount()
end
function c1184003.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE,0)
	local dg=Duel.GetMatchingGroup(c1184003.tfilter1_1,tp,LOCATION_DECK,0,nil)
	local dt=dg:GetClassCount(Card.GetCode)
	local mt=Duel.GetMatchingGroupCount(c1184003.tfilter1_2,tp,LOCATION_MZONE,0,nil)
	if mt>0 and dt>=mt and ft>=mt then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local sg=dg:SelectSubGroup(tp,c1184003.ofilter1,false,mt,mt)
		for tc in aux.Next(sg) do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetCode(EFFECT_CHANGE_TYPE)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1_1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1_1)
		end
	end
end
--
function c1184003.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
--
function c1184003.tfilter3(c)
	return c:IsSetCard(0x3e12) and c:IsAbleToHand()
end
function c1184003.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1184003.tfilter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c1184003.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1184003.tfilter3,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
