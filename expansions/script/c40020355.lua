--MS·CB-能天使高达 修复型Ⅳ［格拉汉姆高达］
local s,id=GetID()
s.ui_hint_effect = s.ui_hint_effect or {}
local CORE_ID = 40020353 
local ArmedIntervention = CORE_ID	   
local ArmedIntervention_UI = CORE_ID + 10000
--CB
s.named_with_CelestialBeing=1
function s.CelestialBeing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CelestialBeing
end
--MS
s.named_with_MobileSuit=1
function s.MobileSuit(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_MobileSuit
end
--能天使
s.named_with_Exia=1
function s.Exia(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Exia
end

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+100)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true  
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(s.ui_update_con)
		ge1:SetOperation(s.ui_update_op)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local owner=e:GetHandler():GetOwner()
	return Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(owner,ArmedIntervention)>=2
end
function s.costfilter(c,tp,loc)
	return s.Exia(c) and c:IsControler(tp) and c:IsFaceup() and c:IsReleasable()
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc = LOCATION_MZONE  
	if aux.IsCanBeQuickEffect(c,tp,40020377) then
		loc = LOCATION_ONFIELD  
	end
	
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.costfilter,tp,loc,0,1,nil,tp,loc)
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,s.costfilter,tp,loc,0,1,1,nil,tp,loc)
	Duel.Release(rg,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		c:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function s.thfilter(c)
	return s.CelestialBeing(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	e:SetLabel(0)
	if c:GetFlagEffect(id)>0 then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.gyfilter(c)
	return (c:IsType(TYPE_MONSTER) and c:IsLevelAbove(5))or c:IsCode(40020383) and c:IsAbleToDeck()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g<=0 then return end
	local ct=1
	if e:GetLabel()==1 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
	local owner=c:GetOwner()
	if Duel.IsExistingMatchingCard(s.gyfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,s.gyfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			Duel.RegisterFlagEffect(owner, ArmedIntervention, 0, 0, 1)
			Duel.RegisterFlagEffect(owner, ArmedIntervention, 0, 0, 1)
		end
	end
end
function s.ui_update_con(e,tp,eg,ep,ev,re,r,rp)
	local c0 = Duel.GetFlagEffect(0, ArmedIntervention)
	local c1 = Duel.GetFlagEffect(1, ArmedIntervention)
	local old_val = e:GetLabel()
	local old_c0 = old_val & 0xFFFF
	local old_c1 = (old_val >> 16) & 0xFFFF
	
	return c0 ~= old_c0 or c1 ~= old_c1
end
function s.ui_update_op(e,tp,eg,ep,ev,re,r,rp)
	local c0 = Duel.GetFlagEffect(0, ArmedIntervention)
	local c1 = Duel.GetFlagEffect(1, ArmedIntervention)
	e:SetLabel((c1 << 16) | c0)
	s.update_player_ui(0, c0)
	s.update_player_ui(1, c1)
end
function s.update_player_ui(p, count)
	local old=s.ui_hint_effect[p]
	if old then
		old:Reset()
		s.ui_hint_effect[p]=nil
	end
	if count==0 then return end
	local str_index
	if count>=10 then
		str_index=13 
	else
		str_index=2+count 
	end
	local e=Effect.GlobalEffect()
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e:SetCode(ArmedIntervention_UI)
	e:SetTargetRange(1,0)
	e:SetDescription(aux.Stringid(CORE_ID, str_index))
	Duel.RegisterEffect(e, p)
	s.ui_hint_effect[p]=e
end