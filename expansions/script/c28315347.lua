--闪耀的迷光 芹泽朝日
function c28315347.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--ash spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28315347,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28315347)
	e1:SetTarget(c28315347.spstg)
	e1:SetOperation(c28315347.spsop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28315347,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38315347)
	e2:SetCost(c28315347.spcost)
	e2:SetTarget(c28315347.sptg)
	e2:SetOperation(c28315347.spop)
	c:RegisterEffect(e2)
	--position
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(28315347,3))
	e5:SetCategory(CATEGORY_POSITION+CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	--e5:SetCountLimit(2)
	e5:SetTarget(c28315347.potg)
	e5:SetOperation(c28315347.poop)
	c:RegisterEffect(e5)
c28315347.shinycounter=true
end
function c28315347.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28315347.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		c:AddCounter(0x1283,2)
	end
end
function c28315347.chkfilter(c)
	return c:IsCode(28335405) and not c:IsPublic()
end
function c28315347.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsCanRemoveCounter(tp,1,0,0x1283,3,REASON_COST)
	local b2=Duel.IsExistingMatchingCard(c28315347.chkfilter,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return b1 or b2 end
	if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(28315347,1),aux.Stringid(28315347,2))==0) then
		Duel.RemoveCounter(tp,1,0,0x1283,3,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local cg=Duel.SelectMatchingCard(tp,c28315347.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleHand(tp)
	end
end
function c28315347.spfilter(c,e,tp)
	return c:IsLevel(3) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c28315347.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315347.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c28315347.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28315347.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c28315347.pofilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function c28315347.potg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315347.pofilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanAddCounter(0x1283,1) and Duel.GetCurrentChain()==1 end
	--e:GetHandler():RegisterFlagEffect(28315347,RESET_CHAIN,0,1)
	local g=Duel.GetMatchingGroup(c28315347.pofilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c28315347.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c28315347.pofilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if Duel.ChangePosition(g,POS_FACEUP_ATTACK)==1 and c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x1283,1)
	end
end
