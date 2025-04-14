--艺形虫 抽象A-55
local s,id,o=GetID()
--string
s.named_with_ArtlienWorm=1
--string check
function s.ArtlienWorm(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ArtlienWorm
end
--
function s.initial_effect(c)
	--redirect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.retcon)
	e1:SetTarget(s.rettg)
	e1:SetOperation(s.retop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+0)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,8))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsPublic() and aux.NegateMonsterFilter(tc) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA)
end
--[[function s.desfilter(c)
	return (not c:IsCode(id) and c:IsFaceup()) or c:IsFacedown()
end]]
function s.desfilter(c)
	return c:IsFaceup() and s.ArtlienWorm(c)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	--[[local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0,nil)]]
	local ct=Duel.GetMatchingGroupCount(Card.IsCanBeEffectTarget,tp,0,LOCATION_MZONE,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_MZONE,0,1,ct,nil)
	local ect=g1:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,ect,ect,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0,nil)
end
function s.spfilter1(c,e,tp)
	return not c:IsType(TYPE_TOKEN) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function s.spfilter2(c,e,tp)
	return not c:IsType(TYPE_TOKEN) and not c:IsLocation(LOCATION_GRAVE) and not c:IsLocation(LOCATION_EXTRA) and not c:IsLocation(LOCATION_DECK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=cg:Filter(Card.IsRelateToEffect,nil,e)
	--local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g and Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.AdjustAll()
		local og=Duel.GetOperatedGroup()
		if #og<=0 then return end
		local spg1=og:Filter(s.spfilter1,nil,e,tp)
		local ft1=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) and ft1>1 then ft1=1 end
		if #spg1>0 and ft1>0 then 
			if #spg1>ft1 then 
				local spg=spg1
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				spg1=spg:Select(tp,ft1,ft1,nil)
			end
			if Duel.SpecialSummon(spg1,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
				local og2=Duel.GetOperatedGroup()
				og:Sub(og2)
			end
		end
		if #og<=0 then return end
		local spg2=og:Filter(s.spfilter2,nil,e,tp)
		local ft2=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) and ft2>1 then ft2=1 end
		if #spg2>0 and ft2>0 then 
			if #spg2>ft2 then 
				local spg=spg2
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				spg2=spg:Select(tp,ft2,ft2,nil)
			end
			Duel.SpecialSummon(spg2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
