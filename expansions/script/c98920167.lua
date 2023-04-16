--恶魔娘 桃丽丝
function c98920167.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),2,99,c98920167.lcheck)
	c:EnableReviveLimit()
--effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920167,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,98920167)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c98920167.effcost)
	e4:SetTarget(c98920167.efftg)
	e4:SetOperation(c98920167.effop)
	c:RegisterEffect(e4)
--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920167,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,98920168)
	e2:SetCondition(c98920167.thcon)
	e2:SetTarget(c98920167.thtg)
	e2:SetOperation(c98920167.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_RELEASE)
	e3:SetCondition(c98920167.drcon)
	c:RegisterEffect(e3)
end
function c98920167.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x174)
end
function c98920167.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(98920167)==0 end
	e:GetHandler():RegisterFlagEffect(98920167,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
--option 1
function c98920167.costfilter1(c,e,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and Duel.GetMZoneCount(tp,c)>0 and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c98920167.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c98920167.spfilter1(c,e,tp)
	return c:IsSetCard(0x174) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--option 2
function c98920167.costfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsReleasable()
end
function c98920167.thfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
--option both
function c98920167.costfilter3(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x174) and Duel.GetMZoneCount(tp,c)>0 and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c98920167.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c98920167.spfilter2(c,e,tp)
	return c98920167.spfilter1(c,e,tp) and Duel.IsExistingMatchingCard(c98920167.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c98920167.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c98920167.costfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c98920167.costfilter2,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c98920167.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local b3=Duel.IsExistingMatchingCard(c98920167.costfilter3,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local op=0
	if b1 and b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(98920167,1),aux.Stringid(98920167,2),aux.Stringid(98920167,3))
	elseif b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(98920167,1),aux.Stringid(98920167,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(98920167,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(98920167,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c98920167.costfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		e:SetLabelObject(g:GetFirst())
		Duel.Release(g,REASON_COST)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c98920167.costfilter2,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Release(g,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c98920167.costfilter3,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		e:SetLabelObject(g:GetFirst())
		Duel.Release(g,REASON_COST)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function c98920167.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local cc=e:GetLabelObject()
	local res=0
	if op~=1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98920167.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,cc)
		if g:GetCount()>0 then
			res=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,c98920167.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			if op==2 and res~=0 then Duel.BreakEffect() end
			Duel.SSet(tp,sg:GetFirst())
		end
	end
end
function c98920167.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp)))
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c98920167.drcon(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c98920167.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c98920167.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end