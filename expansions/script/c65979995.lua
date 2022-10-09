--地中族邪界兽·阿尔沃海龙
function c65979995.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65979995,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,65979995)
	e1:SetTarget(c65979995.thtg)
	e1:SetOperation(c65979995.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65979995,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c65979995.cost)
	e2:SetCondition(c65979995.spcon)
	e2:SetTarget(c65979995.sptg)
	e2:SetOperation(c65979995.spop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65979995,2))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c65979995.poscon)
	e3:SetTarget(c65979995.postg)
	e3:SetOperation(c65979995.posop)
	c:RegisterEffect(e3)
	--local e4=Effect.CreateEffect(c)
	--e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	--e4:SetRange(LOCATION_MZONE)
	--e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	--e4:SetTarget(c65979995.eftg)
	--e4:SetLabelObject(e3)
	--c:RegisterEffect(e4)
end
function c65979995.thfilter(c)
	return c:IsSetCard(0x10ed) and not c:IsCode(65979995) and c:IsAbleToHand()
end
function c65979995.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65979995.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65979995.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65979995.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65979995.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(65979995)==0 end
	c:RegisterFlagEffect(65979995,RESET_CHAIN,0,1)
end
function c65979995.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then return false end
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c65979995.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65979995.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c65979995.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x10ed) and e:GetHandler()~=c
end
function c65979995.poscon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
end
function c65979995.filter(c)
	return c:IsSetCard(0xed) and c:IsFaceup() and c:IsCanTurnSet()
end
function c65979995.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65979995.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c65979995.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c65979995.filter,tp,LOCATION_MZONE,0,1,99,nil)
	if g:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(65979995,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			tc=g:GetNext()
		end
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(c65979995.poscon2)
		e1:SetOperation(c65979995.posop2)
		Duel.RegisterEffect(e1,tp)
	end
end
--function c65979995.poscon(e,tp,eg,ep,ev,re,r,rp)
--  return rp==1-tp 
--end
--function c65979995.postg(e,tp,eg,ep,ev,re,r,rp,chk)
--  local c=e:GetHandler()
--  if chk==0 then return c:IsCanTurnSet() end
--  Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
--end
--function c65979995.posop(e,tp,eg,ep,ev,re,r,rp)
--  local c=e:GetHandler()
--  if c:IsRelateToEffect(e) and c:IsFaceup() then
--	Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
--  end
--  local e1=Effect.CreateEffect(e:GetHandler())
--  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
--  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
--  e1:SetCode(EVENT_CHAINING)
--  e1:SetCountLimit(1)
--  e1:SetLabel(fid)
--  e1:SetLabelObject(g)
--  e1:SetCondition(c65979995.poscon)
--  e1:SetOperation(c65979995.posop2)
--  Duel.RegisterEffect(e1,tp)
--end
--function c65979995.filter(c)
--  return c:IsSetCard(0x10ed) and c:IsFacedown()
--end
--function c65979995.posop2(e,tp,eg,ep,ev,re,r,rp)
--  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
--  local g=Duel.SelectMatchingCard(tp,c65979995.filter,tp,LOCATION_MZONE,0,1,1,nil)
--  local tc=g:GetFirst()
--  if tc then
--	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCodeRule())
--	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
--	Duel.AdjustInstantly()
--  end
--  e:Reset()
--end
function c65979995.posfilter(c,fid)
	return c:GetFlagEffectLabel(65979995)==fid and c:IsPosition(POS_FACEDOWN)
end
function c65979995.poscon2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g then 
	else 
		e:Reset() 
		g:DeleteGroup() 
		return false 
	end
	if g:GetCount()~=0 then 
	else 
		e:Reset() 
		g:DeleteGroup() 
		return false 
	end
	if not g:IsExists(c65979995.posfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return rp==1-tp end
end
function c65979995.posop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c65979995.posfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Hint(HINT_CARD,0,65979995)
	Duel.ChangePosition(tg,POS_FACEUP_DEFENSE)
	e:Reset()
end

