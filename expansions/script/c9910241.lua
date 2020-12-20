--天空名宿 各务葵
function c9910241.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9910241.matfilter,2)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910241,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,9910241)
	e3:SetCondition(c9910241.rmcon)
	e3:SetTarget(c9910241.rmtg)
	e3:SetOperation(c9910241.rmop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(9910241,ACTIVITY_CHAIN,c9910241.chainfilter1)
	Duel.AddCustomActivityCounter(9910242,ACTIVITY_CHAIN,c9910241.chainfilter2)
	Duel.AddCustomActivityCounter(9910243,ACTIVITY_CHAIN,c9910241.chainfilter3)
end
function c9910241.chainfilter1(re,tp,cid,mc)
	return not (re:GetHandler():IsRace(RACE_PSYCHO) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE)
end
function c9910241.chainfilter2(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_PSYCHO) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_GRAVE)
end
function c9910241.chainfilter3(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_PSYCHO) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND)
end
function c9910241.matfilter(c)
	return c:IsLinkRace(RACE_PSYCHO) and c:IsLinkType(TYPE_LINK)
end
function c9910241.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910241.rmfilter(c,tp)
	local b1=c:IsLocation(LOCATION_ONFIELD) and (Duel.GetCustomActivityCount(9910241,tp,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(9910241,1-tp,ACTIVITY_CHAIN)~=0)
	local b2=c:IsLocation(LOCATION_GRAVE) and (Duel.GetCustomActivityCount(9910242,tp,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(9910242,1-tp,ACTIVITY_CHAIN)~=0)
	local b3=c:IsLocation(LOCATION_HAND) and (Duel.GetCustomActivityCount(9910243,tp,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(9910243,1-tp,ACTIVITY_CHAIN)~=0)
	return c:IsAbleToRemove() and (b1 or b2 or b3)
end
function c9910241.rmfilter2(c,tp,id,ct)
	local act=ACTIVITY_CHAIN 
	return c:IsAbleToRemove()
		and (Duel.GetCustomActivityCount(id,tp,act)>ct or Duel.GetCustomActivityCount(id,1-tp,act)>0)
end
function c9910241.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910241.rmfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9910241.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c9910241.rmfilter2,tp,0,LOCATION_ONFIELD,nil,tp,9910241,1)
	local g2=Duel.GetMatchingGroup(c9910241.rmfilter2,tp,0,LOCATION_GRAVE,nil,tp,9910242,0)
	local g3=Duel.GetMatchingGroup(c9910241.rmfilter2,tp,0,LOCATION_HAND,nil,tp,9910243,0)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(9910241,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(9910241,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(9910241,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
