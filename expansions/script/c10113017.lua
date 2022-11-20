--食腐鼠
function c10113017.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113017,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,10113017)
	e1:SetCost(c10113017.cost)
	e1:SetTarget(c10113017.target)
	e1:SetOperation(c10113017.operation)
	c:RegisterEffect(e1)   
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113017,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCost(c10113017.drcost)
	e2:SetTarget(c10113017.drtg)
	e2:SetOperation(c10113017.drop)
	c:RegisterEffect(e2)
end
function c10113017.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10113017.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c10113017.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10113017.dcfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectMatchingCard(tp,c10113017.dcfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c10113017.dcfilter(c)
	return c:IsCode(10113017) and c:IsAbleToDeckAsCost() and c:IsFaceup()
end
function c10113017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10113017.cfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10113017.cfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp,c)
end
function c10113017.cfilter2(c,e,tp,rc)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10113017.filter,tp,0x13,0,1,c,e,tp,rc)
end
function c10113017.filter(c,e,sp,rc)
	return c:IsCode(10113017) and c:IsCanBeSpecialSummoned(e,0,sp,false,false) and c~=rc
end
function c10113017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   e:SetLabel(0)
	return Duel.IsExistingMatchingCard(c10113017.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c10113017.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local rg2=Duel.SelectMatchingCard(tp,c10113017.cfilter2,tp,LOCATION_GRAVE,0,1,1,rg:GetFirst(),e,tp,rg:GetFirst())
	rg:Merge(rg2)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c10113017.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10113017.filter),tp,0x13,0,1,1,nil,e,tp,nil)
	if sg:GetCount()>0 then
	   Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end