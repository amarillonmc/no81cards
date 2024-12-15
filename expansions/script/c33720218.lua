--[[
晦空士 ～闪回的黑流～
Sepialife - Back On Black
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
Duel.LoadScript("glitchylib_lprecover.lua")
function s.initial_effect(c)
	--[[During the End Phase, if this card is Special Summoned: Activate this effect; until the end of your opponent's next turn, each time you would take damage,
	you can shuffle 1 "Sepialife" card from your GY into your opponent's Deck, instead.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetFunctions(aux.EndPhaseCond(),nil,aux.DummyCost,s.operation)
	c:RegisterEffect(e1)
	--[[During your Standby Phase: You can banish this card from your GY; send up to 5 "Sepialife" cards with different names from your Deck to the GY, then it becomes the End Phase of the turn.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(3,id)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:OPT()
	e2:SetFunctions(aux.TurnPlayerCond(0),aux.bfgcost,s.tgtg,s.tgop)
	c:RegisterEffect(e2)
end

--E1
function s.tdfilter(c)
	return c:IsSetCard(ARCHE_SEPIALIFE) and c:IsAbleToDeck()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.PlayerHasFlagEffect(1-tp,id) then return end
	local c=e:GetHandler()
	local rct=Duel.GetNextPhaseCount(PHASE_END,1-tp)
	Duel.RegisterHint(tp,id,PHASE_END|RESET_TURN_OPPO,rct,id,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REPLACE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(s.damcon)
	e1:SetValue(s.damval)
	e1:SetReset(RESET_PHASE|PHASE_END|RESET_TURN_OPPO,rct)
	Duel.RegisterEffect(e1,tp)
end
function s.damcon(e)
	return not Duel.PlayerHasFlagEffect(tp,id+100)
end
function s.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	
	if aux.DamageReplacementEffectAlreadyUsed[e]~=nil or (aux.IsReplacedDamage and aux.DamageReplacementEffectWasApplied) then return val end
	aux.IsReplacedDamage=true
	aux.DamageReplacementEffectAlreadyUsed[e]=true
	
	if r==REASON_BATTLE and not rc then
		rc=s.reason_card
	end
	local fid=c:GetFieldID()
	Duel.RegisterFlagEffect(tp,id+100,0,0,0,fid)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	if rc then
		e1:SetLabelObject(rc)
	end
	e1:SetCondition(s.damrepcon)
	e1:SetOperation(s.damrepop)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local reasoncard=(aux.GetValueType(re)=="Effect") and re:GetHandler() or rc
	Duel.IgnoreActionCheck(Duel.RaiseEvent,reasoncard,EVENT_CUSTOM+id,re,r,rp,tp,val)
	return 0
end
function s.damrepcon(e,tp,eg,ep,ev,re,r,rp)
   return Duel.PlayerHasFlagEffectLabel(tp,id+100,e:GetLabel())
end
function s.damrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=s.damrep(tp)
	aux.DamageReplacementEffectWasApplied=res
	local rc=eg:GetFirst()
	
	if not res and r==REASON_BATTLE then
		s.reason_card=rc
		local dam=Duel.Damage(ep,ev,r)
		if dam>0 then
			Duel.RaiseSingleEvent(rc,EVENT_BATTLE_DAMAGE,nil,0,rp,ep,dam)
			Duel.RaiseEvent(rc,EVENT_BATTLE_DAMAGE,nil,0,rp,ep,dam)
		end
	end
	Duel.ResetFlagEffect(tp,id+100)
end
function s.damrep(tp)
	if Duel.IsExistingMatchingCard(aux.Necro(s.tdfilter),tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,tp,id)
		local g=Duel.Select(HINTMSG_TODECK,false,tp,aux.Necro(s.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			return Duel.ShuffleIntoDeck(g,1-tp)>0
		end
	end
	return false
end

--E2
function s.tgfilter(c)
	return c:IsSetCard(ARCHE_SEPIALIFE) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.Group(s.tgfilter,tp,LOCATION_DECK,0,nil)
		return g:CheckSubGroup(aux.dncheck,1,5)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(s.tgfilter,tp,LOCATION_DECK,0,nil)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,5)
	if #tg>0 and Duel.SendtoGrave(tg,REASON_EFFECT)>0 and Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and Duel.GetCurrentPhase()~=PHASE_END then
		local turnp=Duel.GetTurnPlayer()
		Duel.BreakEffect()
		Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE|PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE|PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
end