--[[
晦空士 ～死于净空～
Sepialife - Cease On Clear
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,ARCHE_SEPIALIFE),2,true)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--[[If you Pendulum Summon a "Sepialife" monster(s) (and no other monsters) (except during the Damage Step): You can take up to 2 "Sepialife" cards with different names from your Deck,
	and Set them to your field, and if you do, it becomes the End Phase.]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetLabelObject(aux.AddThisCardInPZoneAlreadyCheck(c))
	e1:SetFunctions(s.thcon,nil,s.thtg,s.thop)
	c:RegisterEffect(e1)
	--[[During your End Phase, if you do not control any non-"Sepialife" monster: You can send the above materials from your hand and/or your opponent's revealed hand to the GY;
	Special Summon this card from your Extra Deck.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE|PHASE_END)
	e2:SetRange(LOCATION_EXTRA)
	e2:OPT()
	e2:SetFunctions(s.spcon,s.spcost,s.sptg,s.spop)
	c:RegisterEffect(e2)
	--[[During your Standby Phase: You can make your opponent reveal their hand, also they take damage equal to the total number of "Sepialife" cards they control and in their hand x 400
	then it becomes the End Phase.]]
	local e3=Effect.CreateEffect(c)
	e3:Desc(2,id)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:HOPT()
	e3:SetFunctions(aux.TurnPlayerCond(0),nil,s.damtg,s.damop)
	c:RegisterEffect(e3)
	--During the End Phase, if this card is face-up in your Extra Deck: You can place it in your Pendulum Zone.
	local e4=Effect.CreateEffect(c)
	e4:Desc(3,id)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE|PHASE_END)
	e4:SetRange(LOCATION_EXTRA)
	e4:OPT()
	e4:SetFunctions(s.pzcon,nil,s.pztg,s.pzop)
	c:RegisterEffect(e4)
end
--E1
function s.cfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsSummonPlayer(tp)
end
function s.excfilter(c)
	return c:IsFacedown() or not c:IsSetCard(ARCHE_SEPIALIFE)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter,nil,tp)
	return #eg>0 and not eg:IsExists(aux.AlreadyInRangeFilter(e,s.excfilter),1,nil)
end
function s.thfilter(c,e,tp,mzchk)
	if not c:IsSetCard(ARCHE_SEPIALIFE) then return false end
	if c:IsMonster() then
		return mzchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		return c:IsSSetable()
	end
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExists(false,s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,Duel.GetMZoneCount(tp)>0) and not Duel.IsEndPhase()
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.gcheck(g,e,tp,ftm,fts)
	if #g==1 then return true end
	if not aux.dncheck(g) then return false end
	local ctm=g:FilterCount(aux.NOT(Card.IsSSetable),nil,true)
	local cts=g:FilterCount(aux.NOT(Card.IsCanBeSpecialSummoned),nil,e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	local fct=g:FilterCount(Card.IsType,nil,TYPE_FIELD)
	return fct<=1 and ctm<=ftm and (cts<=fts or (fct>0 and cts<=fts-1))
end
function s.thcheck(c,p)
	return Duel.IsPlayerCanSendtoHand(p,c)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ftm,fts=Duel.GetMZoneCount(tp),Duel.GetLocationCount(tp,LOCATION_SZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		ftm=1
	end
	local g=Duel.Group(s.thfilter,tp,LOCATION_DECK,0,nil,e,tp,ftm>0)
	Duel.HintMessage(tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,s.gcheck,false,1,2,e,tp,ftm,fts)
	if #tg>0 then
		local spg,setg=Group.CreateGroup(),Group.CreateGroup()
		for tc in aux.Next(tg) do
			local b1=ftm>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
			local b2=tc:IsSSetable()
			local opt
			if b1 and b2 then
				Duel.Hint(HINT_CARD,tp,tc:GetOriginalCode())
				opt=aux.Option(tp,nil,nil,{b1,STRING_SPECIAL_SUMMON},{b2,STRING_SET})
			else
				opt=b1 and 0 or b2 and 1
			end
			if opt==0 then
				spg:AddCard(tc)
			elseif opt==1 then
				setg:AddCard(tc)
			end
		end
		local ct=0
		if #spg>0 then
			ct=ct+Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,spg)
			if #spg>0 then
				Duel.ShuffleSetCard(spg)
			end
		end
		if #setg>0 then
			ct=ct+Duel.SSet(tp,setg)
		end
		if ct>0 then
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
end

--E2
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==tp and not Duel.IsExists(false,s.excfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.tgfilter(c,tp)
	return c:IsMonster() and (c:IsControler(tp) or c:IsPublic()) and c:IsAbleToGraveAsCost()
end
function s.spchk(g,tp,fus)
	return fus:CheckFusionMaterial(g,nil,tp|0x200,true)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.Group(s.tgfilter,tp,LOCATION_HAND,LOCATION_HAND,nil,tp)
	if chk==0 then
		return g:CheckSubGroup(s.spchk,2,2,tp,c)
	end
	local tg=Duel.SelectFusionMaterial(tp,c,g,nil,tp|0x200,true)
	if #tg>0 then
		Duel.SendtoGrave(tg,REASON_COST)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return e:IsCostChecked() or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
	end
	Duel.SetCardOperationInfo(c,CATEGORY_SPECIAL_SUMMON)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--E3
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetHandCount(1-tp)>0
	end
	Duel.SetTargetPlayer(1-tp)
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_ONFIELD,nil)
	if ct<=0 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*400)
	end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTargetPlayer()
	local cg=Duel.GetHand(p)
	if #cg>0 then
		Duel.ConfirmCards(1-p,cg)
	end
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_HAND|LOCATION_ONFIELD,nil)
	if ct>0 and Duel.Damage(p,ct*400,REASON_EFFECT)>0 then
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
	Duel.ShuffleHand(p)
end

--E4
function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsFaceup()
end
function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) end
end
function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return false end
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end