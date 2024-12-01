--猎兽魔女：芙列雅
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
	--sno0
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e2:SetCost(s.drcost)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.hackclad=2
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),27204311,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function s.spfilter(c,e,tp)
	return c.hackclad==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thfilter(c)
	return _G["c"..c:GetCode()]  and _G["c"..c:GetCode()].hackclad and not c:IsCode(id) and c:IsAbleToHand()
end
function s.mvfilter(c)
	return c:IsFaceup() and _G["c"..c:GetCode()]  and _G["c"..c:GetCode()].hackclad and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)>0
end
function s.mvfilter2(c,tp)
	return c:IsFaceup() and _G["c"..c:GetCode()]  and _G["c"..c:GetCode()].hackclad and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)>1
end
function s.dfilter(c,p,seq,loc)
	local sseq=c:GetSequence()
	if c:IsControler(1-p) then
		return loc==LOCATION_MZONE and c:IsLocation(LOCATION_MZONE)
			and (sseq==5 and seq==3 or sseq==6 and seq==1)
	end
	if c:IsLocation(LOCATION_SZONE) then
		return sseq<5 and (sseq==seq or loc==LOCATION_SZONE and math.abs(sseq-seq)==1)
	end
	if sseq<5 then
		return sseq==seq or loc==LOCATION_MZONE and math.abs(sseq-seq)==1
	else
		return loc==LOCATION_MZONE and (sseq==5 and seq==1 or sseq==6 and seq==3)
	end
end
function s.drfilter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,id)>=7
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.IsExistingMatchingCard(s.mvfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local oe=e:GetLabelObject()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)>0 and c:IsLocation(LOCATION_MZONE) then
		Duel.AdjustAll()
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and Duel.IsExistingMatchingCard(s.mvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,0)},
			{b2,aux.Stringid(id,1)})
		if op==1 then
			e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g2:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
		elseif op==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
			local g3=Duel.SelectMatchingCard(tp,s.mvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			local tc=g3:GetFirst()
			if not tc then return end
			if tc:IsControler(tp) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
				local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
				local nseq=math.log(s,2)
				Duel.MoveSequence(g3:GetFirst(),nseq)
			else
				local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
				local nseq=math.log(bit.rshift(s,16),2)
				Duel.MoveSequence(g3:GetFirst(),nseq)
			end
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MAX_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.mvalue)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.mvalue(e,fp,rp,r)
	return 1-Duel.GetFieldGroupCount(fp,LOCATION_SZONE,0)
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.dfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c:GetControler(),c:GetSequence(),c:GetLocation())
	g:RemoveCard(c)
	g=g:Filter(aux.NegateAnyFilter,nil) 
	if chk==0 then return g:GetCount()>1 and g:FilterCount(Card.IsReleasable,nil)==g:GetCount() end
	Duel.Release(g,REASON_COST)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_HAND)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) and g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabelObject(sg:GetFirst())
			e1:SetOperation(s.drtop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,p)
		end
	end
end
function s.drtop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.IsExistingMatchingCard(s.drfilter2,1-tp,LOCATION_DECK,0,1,nil,e,1-tp,code) then return end
	if not Duel.SelectYesNo(1-tp,aux.Stringid(id,3)) then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(1-tp,s.drfilter2,1-tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,g)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(1-tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,_,exc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,exc) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end