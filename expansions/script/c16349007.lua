--忠义无双 究极骑士君主兽
function c16349007.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,99,c16349007.lcheck)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16349007,1))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c16349007.target)
	e1:SetOperation(c16349007.operation)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16349007,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,16349007)
	e2:SetTarget(c16349007.tgtg)
	e2:SetOperation(c16349007.tgop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16349007,3))
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_DECK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16349007+1)
	e3:SetCondition(c16349007.tecon)
	e3:SetTarget(c16349007.tetg)
	e3:SetOperation(c16349007.teop)
	c:RegisterEffect(e3)
end
function c16349007.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_WARRIOR)
end
function c16349007.pfilter(c,tp)
	return c:IsCode(16349055) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c16349007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16349007.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c16349007.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16349007.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function c16349007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c16349007.thfilter(c,attr)
	return c:IsAttribute(attr) and c:IsAbleToHand()
end
function c16349007.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		local attr=tc:GetAttribute()
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		local ct=g:GetCount()
		if ct<1 then return end
		if g:FilterCount(c16349007.thfilter,nil,attr)>0 and Duel.SelectYesNo(tp,aux.Stringid(16349007,4)) then
			Duel.DisableShuffleCheck()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c16349007.thfilter,1,2,nil,attr)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				ct=g:GetCount()-sg:GetCount()
		end
		if ct>0 then
			Duel.SortDecktop(tp,tp,ct)
			for i=1,ct do
				local mg=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
			end
		end
	end
end
function c16349007.tecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA)
end
function c16349007.tefilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsAbleToDeck()
end
function c16349007.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16349007.tefilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c16349007.rmfilter(c,type)
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsType(type)
end
function c16349007.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c16349007.tefilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>=0 then
		local oc=g:GetFirst()
		local type=oc:GetType()&(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
		local rg=Duel.GetMatchingGroup(c16349007.rmfilter,tp,0,LOCATION_MZONE,nil,type)
		if Duel.SendtoDeck(oc,nil,2,0x40)>0 and oc:IsLocation(LOCATION_EXTRA) and #rg>0 
			and Duel.SelectYesNo(tp,aux.Stringid(16349007,5)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=rg:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.Remove(sg,POS_FACEUP,0x40)
		end
	end
end