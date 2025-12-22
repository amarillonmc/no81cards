--MS·CB-能天使高达［刹那·F·清英］
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

--能天使
s.named_with_Exia=1
function s.Exia(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Exia
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(s.condition)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e3:SetCountLimit(1) 
	e3:SetCondition(s.drcon)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
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

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0
		and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function s.tdfilter(c)
	return s.CelestialBeing(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	local owner = c:GetOwner()
	Duel.RegisterFlagEffect(owner, ArmedIntervention, 0, 0, 1)
	Duel.RegisterFlagEffect(owner, ArmedIntervention, 0, 0, 1)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
		end
		local lv=tc:GetLevel() 
		if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
			local dg=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,lv)
			if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=dg:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end
function s.desfilter(c,lv)
	return c:IsFaceup() and c:IsLevelBelow(lv)
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

function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) 
	   and c:IsPreviousLocation(LOCATION_HAND+LOCATION_GRAVE) 
	   and c:IsType(TYPE_MONSTER) 
	   and c:IsLevelAbove(5)
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect() 
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end