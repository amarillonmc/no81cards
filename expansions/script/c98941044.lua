--伴随星遗物的灾厄
function c98941044.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c98941044.target)
	e1:SetOperation(c98941044.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
	--pzone spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98941044,3))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c98941044.pspcon)
	e2:SetTarget(c98941044.psptg)
	e2:SetOperation(c98941044.pspop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98941044,4))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCost(c98941044.cost)
	e4:SetCondition(c98941044.pspcon)
	e4:SetTarget(c98941044.ltarget)
	e4:SetOperation(c98941044.lactivate)
	c:RegisterEffect(e4)
--extra material
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e11:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e11:SetRange(LOCATION_EXTRA)
	e11:SetTargetRange(0,LOCATION_MZONE)
	e11:SetValue(c98941044.matval)
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e33:SetTargetRange(LOCATION_EXTRA,0)
	e33:SetRange(0xff)
	e33:SetCondition(c98941044.cons)
	e33:SetTarget(c98941044.eftg1)
	e33:SetLabelObject(e11)
	c:RegisterEffect(e33)
end
function c98941044.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if chk==0 then return ft1>0 and ft2>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98941045,0x10c,TYPES_TOKEN_MONSTER,0,0,1,RACE_PSYCHO,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98941045,0x10c,TYPES_TOKEN_MONSTER,0,0,1,RACE_PSYCHO,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
end
function c98941044.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if ft1<=0 or ft2<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,98941045,0x10c,TYPES_TOKEN_MONSTER,0,0,1,RACE_PSYCHO,ATTRIBUTE_LIGHT,POS_FACEUP,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98941045,0x10c,TYPES_TOKEN_MONSTER,0,0,1,RACE_PSYCHO,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,98941045)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local token=Duel.CreateToken(tp,98941045)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
		local g=Duel.GetMatchingGroup(c98941044.filter,tp,LOCATION_HAND,0,nil,e,tp)
		if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(98941044,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			sc=sg:GetFirst()
			Duel.SpecialSummonRule(tp,sc,0)
		end
	end 
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c98941044.reccon)
	e3:SetTarget(c98941044.tg)
	e3:SetOperation(c98941044.op)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(e4,tp)
end
function c98941044.cons(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98941044)>0
end
function c98941044.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c98941044.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98941044.cfilter,1,nil,1-tp)
end
function c98941044.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSpecialSummonable(0) and c:IsSetCard(0x10c)
end
function c98941044.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c98941044.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98941044.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(98941044,2)) then
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c98941044.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	   if g:GetCount()>0 then
		   local tc=g:GetFirst()
		   Duel.SpecialSummonRule(tp,tc,0)
	   end
	end
end
function c98941044.afilter(c)
	return c:IsSetCard(0xfe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98941044.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x10c) and bit.band(loc,LOCATION_MZONE)~=0
end
function c98941044.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98941044.afilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98941044.pspop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98941044.afilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsType(TYPE_CONTINUOUS) and Duel.SelectYesNo(tp,aux.Stringid(98941044,1)) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c98941044.lfilter(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x10c)
end
function c98941044.ltarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98941044.lfilter,tp,LOCATION_EXTRA,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(98941044,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c98941044.lactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98941044.lfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,nil)
	end
end
function c98941044.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)   
end
function c98941044.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c98941044.eftg1(e,c)
	return c:IsSetCard(0x10c) and c:IsType(TYPE_LINK)
end