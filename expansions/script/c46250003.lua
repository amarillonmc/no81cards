--幽骑兵-风暴迷雾
function c46250003.initial_effect(c)
	c:SetSPSummonOnce(46250003)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c46250003.linklimit)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c46250003.spcon)
	e3:SetTarget(c46250003.sptg)
	e3:SetOperation(c46250003.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c46250003.tsptg)
	e4:SetOperation(c46250003.tspop)
	c:RegisterEffect(e4)
	local e2=e4:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetCountLimit(1,46250003)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetTarget(c46250003.thtg)
	e5:SetOperation(c46250003.thop)
	c:RegisterEffect(e5)
end
function c46250003.linklimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_WYRM)
end
function c46250003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>=2 and e:GetHandler():GetFlagEffect(46250003)==0
end
function c46250003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(46250003,RESET_CHAIN,0,1)
end
function c46250003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c46250003.trfilter(c)
	return c:IsSetCard(0xfc0) and c:IsFaceup()
end
function c46250003.cfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c46250003.tsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
	local n=Duel.GetMatchingGroupCount(c46250003.trfilter,tp,LOCATION_SZONE,0,nil)
	local b2=n>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,46250001,0x1fc0,0x4011,1000,0,3,RACE_WYRM,ATTRIBUTE_DARK)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.IsExistingMatchingCard(c46250003.cfilter,tp,0,LOCATION_MZONE,1,nil) then
			op=Duel.SelectOption(tp,aux.Stringid(46250003,0),aux.Stringid(46250003,1),aux.Stringid(46250003,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(46250003,0),aux.Stringid(46250003,1))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(46250003,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(46250003,1))+1
	end
	e:SetLabel(op)
	if op~=1 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	end
	if op~=0 then
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,n,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,n,0,0)
	end
end
function c46250003.tspop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
		if g then
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		end
	end
	if op~=0 then
		local n=math.min(Duel.GetMatchingGroupCount(c46250003.trfilter,tp,LOCATION_SZONE,0,nil),Duel.GetLocationCount(tp,LOCATION_MZONE))
		if n<1 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then n=1 end
		local t={}
		for i=1,n do
			t[i]=i
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_NUMBER)
		n=Duel.AnnounceNumber(tp,table.unpack(t))
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>=n
			and Duel.IsPlayerCanSpecialSummonMonster(tp,46250001,0x1fc0,0x4011,1000,0,3,RACE_WYRM,ATTRIBUTE_DARK) then
			if op==2 then Duel.BreakEffect() end
			for i=1,n do
				Duel.SpecialSummonStep(Duel.CreateToken(tp,46250001),0,tp,tp,false,false,POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c46250003.thfilter(c)
	return c:IsSetCard(0xfc0) and c:IsAbleToHand()
end
function c46250003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c46250003.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c46250003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c46250003.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
