--海滩时光 甘城猫猫&猫羽雫
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,s.lcheck)
	c:EnableReviveLimit()
	--Search or Remove 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--atk and def up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,id-70000000)
	e2:SetCondition(s.adcon)
	e2:SetCost(s.adcost)
	e2:SetTarget(s.adtg)
	e2:SetOperation(s.adop)
	c:RegisterEffect(e2)
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x52c4)
end
function s.thfilter(c)
	return c:IsSetCard(0x52c4) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.rmfilter(c)
	return c:IsSetCard(0x52c4) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,sel+1))
	if sel==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK,0,1,2,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function s.adcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x52c4)
end
function s.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.ConfirmCards(1-tp,c)
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end
function s.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lab=0
	if re:IsHasCategory(CATEGORY_TOGRAVE) then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
		lab=1
	end
	e:SetLabel(lab)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x52c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function s.adop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x52c4))
	e1:SetValue(500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil,e,tp)
	if g1:GetCount()>0 and e:GetLabel()==1 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=g1:Select(tp,1,1,nil)
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
	end
end