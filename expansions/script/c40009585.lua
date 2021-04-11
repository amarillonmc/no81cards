--天枪的骑士 勒克斯 
function c40009585.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009585,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40009585)
	e1:SetCost(c40009585.spcost)
	e1:SetCondition(c40009585.spcon1)
	e1:SetTarget(c40009585.sptg)
	e1:SetOperation(c40009585.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c40009585.spcon2)
	c:RegisterEffect(e2)  
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009585,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,40009586)
	e3:SetTarget(c40009585.drtg)
	e3:SetOperation(c40009585.drop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)	
end
function c40009585.cfilter2(c)
	return c:IsFaceup() and c:IsCode(40009559)
end
function c40009585.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return  not Duel.IsExistingMatchingCard(c40009585.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c40009585.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40009585.cfilter2,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c40009585.cfilter(c)
	return c:IsRace(RACE_WARRIOR) and not c:IsPublic()
end
function c40009585.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009585.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c40009585.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c40009585.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40009585.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c40009585.drfilter(c)
	return c:IsLevelAbove(8) and not c:IsPublic()
end
function c40009585.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009585.drfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end

	--local g=Duel.GetMatchingGroup(c40009585.drfilter,tp,LOCATION_HAND,0,nil)
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	--local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	--Duel.ConfirmCards(1-tp,sg)
	--Duel.ShuffleHand(tp)
   -- Duel.SetTargetPlayer(tp)
	--Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	--Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c40009585.drop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then ct=1 end
	if ct==2 then ct=2 end
	if ct>3 then ct=3 end
	local g=Duel.GetMatchingGroup(c40009585.drfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	if sg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.Draw(tp,sg:GetCount(),REASON_EFFECT)
	end
end



