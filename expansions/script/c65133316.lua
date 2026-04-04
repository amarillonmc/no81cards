--将军是你们永远的光！
local s,id,o=GetID()
function s.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	aux.AddCodeList(c,65133150)
end
function s.handcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil,65133150)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,65133150)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.rmfilter),tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.rmfilter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.spfilter(c,e,tp)
	return c:IsCode(65133150) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local p=1-tp
	local hg=Duel.GetMatchingGroup(s.rmfilter,p,LOCATION_HAND,0,nil)
	local mg=Duel.GetMatchingGroup(s.rmfilter,p,LOCATION_MZONE,0,nil)
	local gg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.rmfilter),p,LOCATION_GRAVE,0,nil)
	if #hg>0 and #mg>0 and #gg>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
		local sg1=hg:Select(p,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
		local sg2=mg:Select(p,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
		local sg3=gg:Select(p,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)==3 then
			local spg=Duel.GetMatchingGroup(s.spfilter,p,LOCATION_HAND+LOCATION_DECK,0,nil,e,p)
			if #spg>0 and Duel.GetLocationCount(p,LOCATION_MZONE)>0 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
				local spc=spg:Select(p,1,1,nil):GetFirst()
				Duel.SpecialSummon(spc,0,p,p,true,false,POS_FACEUP)
			end
		end
	end
end
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsCode(65133150)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.thfilter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_REMOVED,0,nil)
	if #g1>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end
