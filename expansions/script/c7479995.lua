--地中族邪界兽·阿尔沃海龙
local s,id,o=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(s.cost)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetHintTiming(TIMING_MAIN_END,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCost(s.poscost)
	e3:SetCondition(s.poscon)
	e3:SetTarget(s.postg)
	e3:SetOperation(s.posop)
	c:RegisterEffect(e3)
end
function s.fselect(g)
	return g:GetClassCount(Card.GetLocation)==g:GetCount()
end
function s.thfilter(c)
	return c:IsSetCard(0x10ed) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		local sg=g:SelectSubGroup(tp,s.fselect,false,1,2)
		if sg and sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then return false end
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.settarget)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetValue(POS_FACEDOWN_DEFENSE)
	Duel.RegisterEffect(e3,tp)
end
function s.settarget(e,c)
	return c:IsSummonLocation(LOCATION_HAND) and c:IsFaceup()
end
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.posfilter1(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function s.posfilter2(c)
	return (c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()) or c:IsFacedown()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(s.posfilter1,tp,LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(s.posfilter2,tp,LOCATION_MZONE,0,1,nil)) and e:GetHandler():GetFlagEffect(id)==0 end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.posfilter2,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.posfilter1,tp,LOCATION_MZONE,0,1,nil)
	local op=2
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,3))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,4))+1
	end
	if op==0 then
		local g2=Duel.GetMatchingGroup(s.posfilter2,tp,LOCATION_MZONE,0,nil)
		if g2:GetCount()>0 then
			Duel.ChangePosition(g2,POS_FACEUP_DEFENSE)
		end
	elseif op==1 then
		local g2=Duel.GetMatchingGroup(s.posfilter1,tp,LOCATION_MZONE,0,nil)
		if g2:GetCount()>0 then
			Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE)
		end
	end
end
function s.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsFacedown() then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
	end
end
