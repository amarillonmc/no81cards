--98374838
function c98374838.initial_effect(c)
	c:SetSPSummonOnce(98374838)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98374838,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c98374838.settg)
	e1:SetOperation(c98374838.setop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98374838.repcon)
	e2:SetTarget(c98374838.reptg)
	e2:SetValue(c98374838.repval)
	e2:SetOperation(c98374838.repop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(0,LOCATION_ONFIELD)
	e3:SetCondition(c98374838.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e0=e3:Clone()
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e0)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetHintTiming(0,TIMING_DRAW+TIMINGS_CHECK_MONSTER)
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,98374838)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c98374838.spcon)
	e4:SetCost(c98374838.spcost)
	e4:SetTarget(c98374838.sptg)
	e4:SetOperation(c98374838.spop)
	c:RegisterEffect(e4)
end
function c98374838.setfilter(c)
	return c:IsSetCard(0x3af2) and c:IsSSetable()
end
function c98374838.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98374838.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c98374838.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e)):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,c98374838.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc then Duel.SSet(tp,sc) end
end
function c98374838.repcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c98374838.dfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c98374838.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c98374838.dfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c98374838.repval(e,c)
	return c98374838.dfilter(c,e:GetHandlerPlayer())
end
function c98374838.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Hint(HINT_CARD,0,98374838)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
end
function c98374838.indcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c98374838.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function c98374838.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c98374838.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetSequence()>=5 and e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98374838.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local ct2=Duel.GetDecktopGroup(1-tp,ct1):FilterCount(Card.IsAbleToRemove,nil)
	if chk==0 then return ct1>0 and ct2>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct1,1-tp,LOCATION_DECK)
end
function c98374838.spfilter(c,e,tp)
	return c:IsSetCard(0x3af2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98374838.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local ct2=Duel.GetDecktopGroup(1-tp,ct1):FilterCount(Card.IsAbleToRemove,nil)
	if ct1==0 or ct2==0 then return end
	local g=Duel.GetDecktopGroup(1-tp,ct1)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c98374838.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(98374838,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c98374838.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
