--狂暴轮回者-『蜘蛛』
function c67201207.initial_effect(c)
	--link summon
	local e0=aux.AddLinkProcedure(c,c67201207.matfilter,1,1)
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_ONFIELD,0)
	e0:SetValue(c67201207.matval)
	c:RegisterEffect(e0)   
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	--e1:SetCountLimit(1,1855886)
	e1:SetTarget(c67201207.tdtg)
	e1:SetOperation(c67201207.tdop)
	c:RegisterEffect(e1) 
end
function c67201207.matfilter(c)
	return c:IsLinkSetCard(0x567b) and not c:IsLinkType(TYPE_LINK) or (c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP))
end
function c67201207.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true, true
end
--
function c67201207.tdfilter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP) and c:IsFaceupEx()
end
function c67201207.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c67201207.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c)
	if chk==0 then return c:IsAbleToDeck() and g:GetCount()>0 end
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c67201207.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67201207.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c)
		if g:GetCount()>0 then
			g:AddCard(c)
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end