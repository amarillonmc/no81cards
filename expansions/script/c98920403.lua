--时械域
function c98920403.initial_effect(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920403,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920403)
	e1:SetTarget(c98920403.target)
	e1:SetOperation(c98920403.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
--discard
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930403)
	e3:SetTarget(c98920403.hdtg)
	e3:SetOperation(c98920403.hdop)
	c:RegisterEffect(e3)
end
function c98920403.filter(c)
	return (c:IsSetCard(0x4a) or c:IsCode(9409625,36894320,72883039)) and c:IsAbleToDeck()
end
function c98920403.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c98920403.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c98920403.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,aux.NecroValleyFilter(c98920403.filter),p,LOCATION_HAND+LOCATION_GRAVE,0,1,63,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)   
	local ct=g:GetCount()
	Duel.ShuffleDeck(p)
	if ct>3 then ct=3 end
	Duel.Draw(p,ct,REASON_EFFECT)
end
function c98920403.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c98920403.hdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT) then
	   local g1=Duel.GetMatchingGroup(c98920403.setfilter1,tp,LOCATION_DECK,0,nil)
	   local g2=Duel.GetMatchingGroup(c98920403.setfilter2,tp,LOCATION_DECK,0,nil)
	   local g3=Duel.GetMatchingGroup(c98920403.setfilter3,tp,LOCATION_DECK,0,nil)
	   local b1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	   local b2=Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)
	   local off=1
	   local ops={}
	   local opval={}
	   if b1==0 and g1:GetCount()>0 then
			ops[off]=aux.Stringid(98920403,0)
			opval[off-1]=1
			off=off+1
		end
		if b2==0 and g2:GetCount()>0 then
			ops[off]=aux.Stringid(98920403,1)
			opval[off-1]=2
			off=off+1
		end
		if b2==0 and b1==0 and g3:GetCount()>0 then
			ops[off]=aux.Stringid(98920403,2)
			opval[off-1]=3
			off=off+1
		end
		ops[off]=aux.Stringid(98920403,3)
		opval[off-1]=4
		off=off+1
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.MoveToField(sg1:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		elseif opval[op]==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.MoveToField(sg2:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		elseif opval[op]==3 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg3=g3:Select(tp,1,1,nil)
			Duel.MoveToField(sg3:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c98920403.setfilter1(c)
	return c:IsCode(9409625) and not c:IsForbidden()
end
function c98920403.setfilter2(c)
	return c:IsCode(36894320) and not c:IsForbidden()
end
function c98920403.setfilter3(c)
	return c:IsCode(72883039) and not c:IsForbidden()
end