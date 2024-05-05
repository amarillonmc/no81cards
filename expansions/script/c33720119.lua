--[[
亡命铁心之缘
Connection of Desperado Heart
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	if not s.progressive_id then
		s.progressive_id=id+100
	else
		s.progressive_id=s.progressive_id+1
	end
	c:EnableCounterPermit(COUNTER_CONNECTION_OF_DESPERADO_HEART,LOCATION_SZONE|LOCATION_MZONE)
	c:Activation(false,false,false,false,s.regop)
	--[[Each time a "Desperado Trickster" monster(s) is Normal Summoned: Place 1 counter on this card.]]
	local SZChk=aux.AddThisCardInSZoneAlreadyCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetLabelObject(SZChk)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--[[Once per turn: You can remove 1 counter from this card; draw 1 card, then you can return 1 "Desperado Trickster" monster from your hand to the bottom of your Deck,
	and if you do, draw 1 card.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1)
	e2:SetCategory(CATEGORY_DRAW|CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:OPT()
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--[[During your Main Phase, except the turn this card was activated: You can Special Summon this card from your Spell & Trap Zone to your field as an Effect Monster
	named "Desperado Heart" (FIRE/Psychic/Level 1/ATK 0/DEF 0) and with the following effect (This card is NOT treated as a Spell), and if you do, place a number of counters on it
	equal to the number of counters it had at activation.
	● If a "Desperado Trickster" monster(s) you control is destroyed by your opponent and sent to your GY: You can remove 1 counter from this card; Special Summon 1 of those monsters from your GY.]]
	aux.RegisterDesperadoSpellMonsterEffect(c,id,COUNTER_CONNECTION_OF_DESPERADO_HEART)
	aux.RegisterMergedDelayedEventGlitchy(c,s.progressive_id,EVENT_TO_GRAVE,s.egfilter,id+100,LOCATION_MZONE,false,LOCATION_MZONE)
	local e3=Effect.CreateEffect(c)
	e3:Desc(4)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CUSTOM+s.progressive_id)
	e3:SetFunctions(aux.ProcSummonedCond,s.spcost,s.target,s.operation)
	c:RegisterEffect(e3)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,0)
end

--E1
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(ARCHE_DESPERADO_TRICKSTER)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(aux.AlreadyInRangeFilter(e,s.cfilter),1,nil)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,tp,COUNTER_CONNECTION_OF_DESPERADO_HEART)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsCanAddCounter(COUNTER_CONNECTION_OF_DESPERADO_HEART,1) then
		c:AddCounter(COUNTER_CONNECTION_OF_DESPERADO_HEART,1)
	end
end

--E2
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,COUNTER_CONNECTION_OF_DESPERADO_HEART,1,REASON_COST) end
	c:RemoveCounter(tp,COUNTER_CONNECTION_OF_DESPERADO_HEART,1,REASON_COST)
end
function s.tdfilter(c)
	return c:IsMonster() and c:IsSetCard(ARCHE_DESPERADO_HEART) and c:IsAbleToDeck()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 and Duel.IsExists(false,s.tdfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		local tc=Duel.Select(HINTMSG_TODECK,false,tp,s.tdfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
		if tc then
			Duel.ShuffleHand(tp)
			Duel.ConfirmCards(1-tp,Group.FromCards(tc))
			Duel.BreakEffect()
			if Duel.ShuffleIntoDeck(tc,nil,nil,SEQ_DECKBOTTOM)>0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end

--E3
function s.egfilter(c,e,tp,eg,ep,ev,re,r,rp,se)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(ARCHE_DESPERADO_TRICKSTER)
		and c:IsReason(REASON_DESTROY) and c:IsReasonPlayer(1-tp) and c:IsControler(tp) and c:IsMonster() and c:IsSetCard(ARCHE_DESPERADO_TRICKSTER)
		and aux.AlreadyInRangeFilter(nil,nil,se)
end
function s.filter(c,e,tp)
	return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetMZoneCount(tp)>0 and eg:IsExists(s.filter,1,nil,e,tp)
	end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local tg=Duel.GetTargetCards():Filter(aux.Necro(s.filter),nil,e,tp)
	if #tg<=0 then return end
	Duel.HintMessage(tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,1,1,nil)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end