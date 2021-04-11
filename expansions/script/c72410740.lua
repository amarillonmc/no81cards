--苍蓝反叛者 坦忒菈
function c72410740.initial_effect(c)
	aux.AddCodeList(c,72410700,72411020)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c72410740.matfilter,2)
	--ml
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72410740,1))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c72410740.condition1)
	e1:SetTarget(c72410740.target1)
	e1:SetOperation(c72410740.operation1)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72410740,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e2:SetCondition(c72410740.condition2)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72410740,3))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,72410740)
	e3:SetCondition(c72410740.condition3)
	e3:SetTarget(c72410740.target3)
	e3:SetOperation(c72410740.operation3)
	c:RegisterEffect(e3)
end
--e1
function c72410740.matfilter(c)
	return c:IsLinkType(TYPE_EFFECT) and c:IsLinkRace(RACE_MACHINE)
end
function c72410740.condition1(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return c:GetMaterial():IsExists(Card.IsCode,1,nil,72410700) and c:IsSummonType(SUMMON_TYPE_LINK) and re:GetActivateLocation()==LOCATION_GRAVE and Duel.IsChainNegatable(ev)
end
function c72410740.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c72410740.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
--e2
function c72410740.condition2(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return c:GetMaterial():IsExists(Card.IsCode,1,nil,72410720) and c:IsSummonType(SUMMON_TYPE_LINK) 
end

--e3

function c72410740.filter3(c)
	return c:IsRace(RACE_MACHINE) and (not c:IsOnField() or c:IsFaceup())
end

function c72410740.condition3(e,c)
	return Duel.GetMatchingGroupCount(c72410740.filter3,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)>=5 and Duel.GetTurnPlayer()==e:GetHandlerPlayer() 
end
function c72410740.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c72410740.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
	end
end