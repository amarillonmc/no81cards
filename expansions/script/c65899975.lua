--次元征缴
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--flag: record opponent's special summon
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.spfilter,1,nil,1-tp) and Duel.GetFlagEffect(tp,id)==0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.spfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil,tp,POS_FACEUP,REASON_EFFECT)
	if chk==0 then
		return #g>0
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil,tp,POS_FACEUP,REASON_EFFECT)
	if #g==0 then return end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==0 then return end
	local rg=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	local ct=#rg
	if ct==0 then return end
	local ret_count=math.floor(ct/2)
	if ret_count>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=rg:Select(tp,ret_count,ret_count,nil)
		Duel.SendtoDeck(sg,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		rg:Sub(sg)
	end
	if #rg>0 then
		Duel.SendtoDeck(rg,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
