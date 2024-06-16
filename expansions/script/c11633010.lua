--暗海的弓手
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
function Dark_Sea_counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
Duel.AddCustomActivityCounter(11633000,ACTIVITY_SPSUMMON,Dark_Sea_counterfilter)
function Dark_Sea_Effect(c,id)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCost(Dark_Sea_spcost)
	e1:SetCondition(Dark_Sea_spcon)
	e1:SetTarget(Dark_Sea_sptg) 
	e1:SetOperation(Dark_Sea_spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCondition(Dark_Sea_pucon)
	e2:SetOperation(Dark_Sea_puop)
	c:RegisterEffect(e2)
end
function Dark_Sea_pucon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic()
end
function Dark_Sea_puop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function Dark_Sea_spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11633000,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(Dark_Sea_splimit)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function Dark_Sea_splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function Dark_Sea_spfilter(c,e,tp,mg)
	if bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or  not c:IsSetCard(0xa220) then return false end
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	if c.mat_filter then
		mg2=mg2:Filter(c.mat_filter,nil,tp)
	end
	return mg2:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function Dark_Sea_matfilter(c)
	return c:IsLevelAbove(1) and c:IsAbleToGrave() and c:IsSetCard(0xa220)
end
function Dark_Sea_spcon(e,tp,eg,ep,ev,re,r,rp)

	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and (e:GetHandler():IsReason(REASON_EFFECT) and (e:GetHandler():GetReasonPlayer()==1-tp or e:GetHandler():IsSetCard(0xa220)))
end
function Dark_Sea_sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Dark_Sea_matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		if Duel.GetFlagEffect(tp,11633001)<2 then 
			mg=Duel.GetMatchingGroup(Dark_Sea_matfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,nil)
		end
		if Duel.GetFlagEffect(tp,11633002)<1 then
			return Duel.IsExistingMatchingCard(Dark_Sea_spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
		else
			return Duel.IsExistingMatchingCard(Dark_Sea_spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function Dark_Sea_spop(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetMatchingGroup(Dark_Sea_matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if Duel.GetFlagEffect(tp,11633001)<2 then 
		mg=Duel.GetMatchingGroup(Dark_Sea_matfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Group.CreateGroup()
	if Duel.GetFlagEffect(tp,11633002)<1 then
		sg=Duel.SelectMatchingCard(tp,Dark_Sea_spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	else
		sg=Duel.SelectMatchingCard(tp,Dark_Sea_spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	end
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		mg:RemoveCard(tc)
		
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil,tp)
		end
		
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		aux.GCheckAdditional=function(sg) return sg:GetSum(Card.GetRitualLevel,tc)<=lv end
		local mat=mg:SelectSubGroup(tp,aux.RitualCheckEqual,true,1,99,tc,lv)
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)

		if mat:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.RegisterFlagEffect(tp,11633001,RESET_PHASE+PHASE_END,0,1) end
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		if tc:IsLocation(LOCATION_DECK) then Duel.RegisterFlagEffect(tp,11633002,RESET_PHASE+PHASE_END,0,1) end
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--
local s,id,o=GetID()
function s.initial_effect(c)
	Dark_Sea_Effect(c,id)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+1)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+2)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(s.descon)
	c:RegisterEffect(e3)
end
function s.cfilter(c)
	return  c:IsAttribute(ATTRIBUTE_WATER)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return  ct>0 and ct==Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_MZONE,0,nil)	   
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.desfilter(c)
	return c:IsSetCard(0xa220) and c:IsAbleToDeck()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()>0
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end