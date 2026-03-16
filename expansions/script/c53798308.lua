local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,7,2)
	--material & to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.mtcon)
	e1:SetTarget(s.mttg)
	e1:SetOperation(s.mtop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.negcon)
	e2:SetCost(s.negcost)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,PLAYER_ALL,LOCATION_OVERLAY)
end
function s.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay() 
		and (c:GetAttribute() & (ATTRIBUTE_LIGHT|ATTRIBUTE_DARK|ATTRIBUTE_EARTH|ATTRIBUTE_WATER|ATTRIBUTE_FIRE|ATTRIBUTE_WIND)) ~= 0 
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function s.attrcheck(g)
	local att=0
	for tc in aux.Next(g) do
		local c_att=tc:GetAttribute() & (ATTRIBUTE_LIGHT|ATTRIBUTE_DARK|ATTRIBUTE_EARTH|ATTRIBUTE_WATER|ATTRIBUTE_FIRE|ATTRIBUTE_WIND)
		if (att & c_att) ~= 0 then return false end
		att = att | c_att
	end
	return true
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
	local g2=Duel.GetMatchingGroup(s.matfilter,1-tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
	local sg=Group.CreateGroup()
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg1=g1:SelectSubGroup(tp,s.attrcheck,false,1,6)
		if sg1 then Duel.ConfirmCards(1-tp,sg1) sg:Merge(sg1) end
	end
	if #g2>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_XMATERIAL)
		local sg2=g2:SelectSubGroup(1-tp,s.attrcheck,false,1,6)
		if sg2 then sg:Merge(sg2) end
	end
	if #sg>0 then
		Duel.Overlay(c,sg)
		Duel.AdjustAll()
		local og=c:GetOverlayGroup()
		Debug.Message(#og)
		local tg=Group.CreateGroup()
		for tc in aux.Next(og) do
			if og:IsExists(Card.IsAttribute,1,tc,tc:GetAttribute()) then
				tg:AddCard(tc)
			end
		end
		if #tg>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function s.cfilter(c,tp)
	local att=c:GetAttribute()
	local flag=Duel.GetFlagEffectLabel(tp,id) or 0
	return (att & flag) == 0
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if chk==0 then return og:IsExists(s.cfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local g=og:FilterSelect(tp,s.cfilter,1,1,nil,tp)
	local rem_att=g:GetFirst():GetAttribute()
	Duel.SendtoGrave(g,REASON_COST)
	local flag=Duel.GetFlagEffectLabel(tp,id) or 0
	flag = flag | rem_att
	if Duel.GetFlagEffect(tp,id)==0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1,flag)
	else
		Duel.SetFlagEffectLabel(tp,id,flag)
	end
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end