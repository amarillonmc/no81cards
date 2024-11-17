--漆黑噤默-罗兰
function c65820000.initial_effect(c)
	--特招检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65820000,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65820000)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c65820000.target1)
	e1:SetOperation(c65820000.activate1)
	c:RegisterEffect(e1)
	--对方回合手发速攻
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65820000,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa32))
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	--自诉
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c65820000.splimit)
	c:RegisterEffect(e3)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e7)
	--速攻发动检索
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(65820000,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,65820000)
	e4:SetCondition(c65820000.setcon)
	e4:SetTarget(c65820000.settg)
	e4:SetOperation(c65820000.setop)
	c:RegisterEffect(e4)
	--加攻、守
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c65820000.value)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
end



function c65820000.filter(c)
	return (c:IsSetCard(0xa32) or c:IsCode(65820005)) and c:IsAbleToHand() and aux.NecroValleyFilter()
end
function c65820000.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65820000.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c65820000.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65820000.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c65820000.setcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0xa32) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c65820000.setfilter(c,rc)
	return c:IsSetCard(0xa32) and c:IsAbleToHand() and aux.NecroValleyFilter()
end
function c65820000.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65820000.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,rc) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c65820000.setop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65820000.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,rc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c65820000.filter1(c,rc)
	return c:IsSetCard(0xa32) and c:IsFaceup()
end
function c65820000.value(e,c)
	return Duel.GetMatchingGroupCount(c65820000.filter1,c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*500
end


function c65820000.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsCode(65820005,65820010)
end
