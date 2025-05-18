--稀世的天才
function c60158001.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,nil,c60158001.lcheck)
	
	--2xg-1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60158001,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c60158001.e1con)
	e1:SetCost(c60158001.e1cost)
	e1:SetTarget(c60158001.e1tg)
	e1:SetOperation(c60158001.e1op)
	c:RegisterEffect(e1)
	--2xg-2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60158001,5))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c60158001.e4con)
	e4:SetCost(c60158001.e4cost)
	e4:SetTarget(aux.nbtg)
	e4:SetOperation(c60158001.e4op)
	c:RegisterEffect(e4)
	
	--1xg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60158001,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	--e2:SetCondition(c60158001.e2con)
	e2:SetCost(c60158001.e2cost)
	e2:SetTarget(c60158001.e2tg)
	e2:SetOperation(c60158001.e2op)
	c:RegisterEffect(e2)
	--1xg-二速
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60158001,6))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	--e5:SetCondition(c60158001.e5con)
	e5:SetCost(c60158001.e2cost)
	e5:SetTarget(c60158001.e5tg)
	e5:SetOperation(c60158001.e2op)
	c:RegisterEffect(e5)
	
	
	--3xg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60158001,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,60158001)
	e3:SetCondition(c60158001.e3con)
	e3:SetTarget(c60158001.e3tg)
	e3:SetOperation(c60158001.e3op)
	c:RegisterEffect(e3)
end

--link summon

function c60158001.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c60158001.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==1
end

--1xg

function c60158001.e1costf(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c60158001.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60158001.e1costf,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60158001.e1costf,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:GetHandler():RegisterFlagEffect(6018001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c60158001.e2con(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(60158210)
end
function c60158001.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 and not e:GetHandler():IsHasEffect(60158210) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158001,4))
end
function c60158001.e5con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(60158210)
end
function c60158001.e5tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 and e:GetHandler():IsHasEffect(60158210) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158001,4))
end
function c60158001.e2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()~=0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--2xg

function c60158001.e1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c60158001.e2costf(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c60158001.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60158001.e2costf,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():GetFlagEffect(60158001)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60158001.e2costf,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(60158001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158001,0))
end
function c60158001.e4cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60158001.e2costf,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():GetFlagEffect(60158001)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60158001.e2costf,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(60158001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158001,5))
end
function c60158001.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c60158001.e1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end


function c60158001.e4con(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c60158001.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60158001.e4op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

--3xg

function c60158001.e3con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()==1-tp
end
function c60158001.e3tgf(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c:IsFaceup()
end
function c60158001.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c60158001.e3tgf,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158001,2))
end
function c60158001.e3op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60158001.e3tgf,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end