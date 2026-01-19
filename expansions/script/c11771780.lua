--承继精灵王之灵域
-- c12345693.lua
local s,id,o=GetID()
function s.initial_effect(c)
	-- Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	-- Effect 1: Various Phase Effects based on Attribute Count
	-- 1+: Draw (Draw Phase)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_DRAW)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.drawcon)
	e1:SetTarget(s.drawtg)
	e1:SetOperation(s.drawop)
	c:RegisterEffect(e1)
	
	-- 2+: Recycle/SpSummon (Standby Phase)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.reccon)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
	
	-- 3+: Xyz Summon (Main Phase 1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetCondition(s.xyzcon)
	e3:SetTarget(s.xyztg)
	e3:SetOperation(s.xyzop)
	c:RegisterEffect(e3)
	
	-- 4+: Battle Phase Stats & Forced Attack
	local e4a=Effect.CreateEffect(c)
	e4a:SetType(EFFECT_TYPE_FIELD)
	e4a:SetCode(EFFECT_UPDATE_ATTACK)
	e4a:SetRange(LOCATION_SZONE)
	e4a:SetTargetRange(LOCATION_MZONE,0)
	e4a:SetCondition(s.bpcon)
	e4a:SetTarget(s.bptg)
	e4a:SetValue(900)
	c:RegisterEffect(e4a)
	local e4b=e4a:Clone()
	e4b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4b)
	-- Must Attack
	local e4c=Effect.CreateEffect(c)
	e4c:SetType(EFFECT_TYPE_FIELD)
	e4c:SetCode(EFFECT_MUST_ATTACK)
	e4c:SetRange(LOCATION_SZONE)
	e4c:SetTargetRange(0,LOCATION_MZONE)
	e4c:SetCondition(s.bpcon)
	c:RegisterEffect(e4c)
	-- Limit Targets
	local e4d=Effect.CreateEffect(c)
	e4d:SetType(EFFECT_TYPE_FIELD)
	e4d:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4d:SetRange(LOCATION_SZONE)
	e4d:SetTargetRange(0,LOCATION_MZONE)
	e4d:SetCondition(s.bpcon)
	e4d:SetValue(s.atklimit)
	c:RegisterEffect(e4d)
	
	-- 5+: MP2 Activation Limit
	-- Counter
	local e5a=Effect.CreateEffect(c)
	e5a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5a:SetCode(EVENT_CHAINING)
	e5a:SetRange(LOCATION_SZONE)
	e5a:SetCondition(s.countcon)
	e5a:SetOperation(s.countop)
	c:RegisterEffect(e5a)
	-- Restriction
	local e5b=Effect.CreateEffect(c)
	e5b:SetType(EFFECT_TYPE_FIELD)
	e5b:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5b:SetRange(LOCATION_SZONE)
	e5b:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5b:SetTargetRange(0,1)
	e5b:SetCondition(s.limcon)
	e5b:SetValue(s.limval)
	c:RegisterEffect(e5b)
	
	-- 6: End Phase Banish
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,3))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) -- "Must banish" implies mandatory
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(s.rmcon)
	e6:SetTarget(s.rmtg)
	e6:SetOperation(s.rmop)
	c:RegisterEffect(e6)
	
	-- Effect 2: Place from GY/Rem
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,4))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCountLimit(1,id)
	e7:SetCondition(s.tfcon)
	e7:SetTarget(s.tftg)
	e7:SetOperation(s.tfop)
	c:RegisterEffect(e7)
end

-- Helpers
function s.attfilter(c)
	return c:IsFaceup() and (c:IsLevel(9) or c:IsRank(9))
end
function s.attcount(tp)
	return Duel.GetMatchingGroup(s.attfilter,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetAttribute)
end

-- 1: Draw
function s.drawcon(e,tp,eg,ep,ev,re,r,rp)
	return s.attcount(tp)>=1
end
function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToChain() then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end

-- 2: Recycle
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return s.attcount(tp)>=2
end
function s.recfilter(c,e,tp)
	return c:IsLevel(9) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.recfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToChain() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.recfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,5)},
			{b2,aux.Stringid(id,6)})
		if op==1 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

-- 3: Xyz
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and s.attcount(tp)>=3
end
function s.xyzfilter(c)
	return c:IsRank(9) and c:IsXyzSummonable(nil)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToChain() then return end
	local g=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=g:Select(tp,1,1,nil):GetFirst()
		if xyz then
			Duel.XyzSummon(tp,xyz,nil)
		end
	end
end

-- 4: Battle Phase
function s.bpcon(e)
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and s.attcount(e:GetHandlerPlayer())>=4
end
function s.bptg(e,c)
	return c:IsLevel(9) or c:IsRank(9)
end
function s.atklimit(e,c)
	return not c:IsRank(9)
end

-- 5: MP2 Limit
function s.countcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=re:GetActivateLocation()
	return rp==1-tp and Duel.GetCurrentPhase()==PHASE_MAIN2 and s.attcount(tp)>=5 
		and (loc==LOCATION_HAND or loc==LOCATION_GRAVE or loc==LOCATION_REMOVED)
end
function s.countop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.limcon(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and s.attcount(e:GetHandlerPlayer())>=5 
		and e:GetHandler():GetFlagEffect(id)>=1
end
function s.limval(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_HAND or loc==LOCATION_GRAVE or loc==LOCATION_REMOVED
end

-- 6: Banish
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return s.attcount(tp)==6
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end -- Mandatory
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,LOCATION_ONFIELD)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

-- Effect 2: Place
function s.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and (c:IsLevel(9) or c:IsRank(9)) 
		and (bit.band(c:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ or bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM)
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
