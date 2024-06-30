--[[
晦空士 ～生于空净～
Sepialife - Born On Blank
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--[[If you Pendulum Summon a "Sepialife" monster(s) (and no other monsters) (except during the Damage Step): You can take up to 2 "Sepialife" cards with different names from your Deck,
	and either add them to your hand, or add them to your opponent's hand (but keep them revealed), and if you do, it becomes the End Phase.]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(0,id)
	e1:SetCategory(CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetLabelObject(aux.AddThisCardInPZoneAlreadyCheck(c))
	e1:SetFunctions(s.thcon,nil,s.thtg,s.thop)
	c:RegisterEffect(e1)
	--[[During your End Phase, if you do not control any non-"Sepialife" monster, you can send the above materials from your hand and/or your opponent's revealed hand to the GY,
	then Xyz Summon this card using cards in your GY as material.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE|PHASE_END)
	e2:SetRange(LOCATION_EXTRA)
	e2:OPT()
	e2:SetFunctions(s.xyzcon,nil,nil,s.xyzop)
	c:RegisterEffect(e2)
	--(Quick Effect): You can detach 1 material from this card; skip this turn's Battle Phase.
	local e3=Effect.CreateEffect(c)
	e3:Desc(2,id)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_MAIN_END)
	e3:SetFunctions(nil,aux.DetachSelfCost(),s.skiptg,s.skipop)
	c:RegisterEffect(e3)
	--During the End Phase, if this card is face-up in your Extra Deck: You can place it in your Pendulum Zone.
	local e4=Effect.CreateEffect(c)
	e4:Desc(4,id)
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
function s.thfilter(c)
	return c:IsSetCard(ARCHE_SEPIALIFE) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExists(false,s.thfilter,tp,LOCATION_DECK,0,1,nil) and not Duel.IsEndPhase()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.gcheck(g)
	return aux.dncheck(g) and (g:FilterCount(s.thcheck,nil,0)==#g or g:FilterCount(s.thcheck,nil,1)==#g)
end
function s.thcheck(c,p)
	return Duel.IsPlayerCanSendtoHand(p,c)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(s.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.HintMessage(tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,s.gcheck,false,1,2)
	if #tg>0 then
		local b1,b2=tg:FilterCount(s.thcheck,nil,tp)==#tg,tg:FilterCount(s.thcheck,nil,1-tp)==#tg
		if not b1 and not b2 then return end
		local opt=aux.Option(tp,id,1,b1,b2)
		local p=opt==0 and tp or 1-tp
		if Duel.SearchAndCheck(tg,1-p,p) then
			local c=e:GetHandler()
			if opt==1 then
				for tc in aux.Next(tg:Filter(Card.IsLocation,nil,LOCATION_HAND)) do
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(66)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
					e1:SetCode(EFFECT_PUBLIC)
					e1:SetReset(RESET_EVENT|RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
			local turnp=Duel.GetTurnPlayer()
			Duel.BreakEffect()
			Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE|PHASE_END,1)
			Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE|PHASE_END,1)
			Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE|PHASE_END,1)
			Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE|PHASE_END,1,1)
			Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE|PHASE_END,1)
			local e1=Effect.CreateEffect(c)
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
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFacedown() and Duel.GetTurnPlayer()==tp and not Duel.IsExists(false,s.excfilter,tp,LOCATION_MZONE,0,1,nil)) then return false end
	local g=Duel.Group(s.tgfilter,tp,LOCATION_HAND,LOCATION_HAND,nil,tp,c)
	if #g<2 then return false end
	local mats=Duel.Group(aux.Necro(s.xyzmat),tp,LOCATION_GRAVE,0,nil,c)
	local prechk=c:IsXyzSummonable(mats,1,#mats)
	return g:CheckSubGroup(s.xyzcheck,2,2,prechk,mats,tp,c)
end
function s.tgfilter(c,tp,xyzc)
	return c:IsMonster() and c:IsXyzLevel(xyzc,4) and (c:IsControler(tp) or c:IsPublic()) and c:IsAbleToGrave()
end
function s.xyzmat(c,xyzc)
	return c:IsCanBeXyzMaterial(xyzc)
end
function s.xyzmat2(c,xyzc)
	aux.IgnoreCostRestrictions=true
	local res=c:IsOwner(tp) and c:IsAbleToGraveAsCost()
	aux.IgnoreCostRestrictions=false
	return res
end
function s.xyzcheck(g,prechk,mats,tp,xyzc)
	if prechk then return true end
	local mg=mats:Clone()
	local validg=g:Filter(s.xyzmat2,nil,tp)
	mg:Merge(validg)
	return xyzc:IsXyzSummonable(mg)
end
function s.xyzcheck_final(g,xyzc)
	return xyzc:IsXyzSummonable(g)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.Group(s.tgfilter,tp,LOCATION_HAND,LOCATION_HAND,nil,tp,c)
	if #g<2 then return end
	local mats=Duel.Group(aux.Necro(s.xyzmat),tp,LOCATION_GRAVE,0,nil,c)
	local prechk=c:IsXyzSummonable(mats,1,#mats)
	if not g:CheckSubGroup(s.xyzcheck,2,2,prechk,mats,tp,c) or not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then return end
	Duel.Hint(HINT_CARD,tp,id)
	Duel.HintMessage(tp,HINTMSG_TOGRAVE)
	local mg=g:SelectSubGroup(tp,s.xyzcheck,false,2,2,prechk,mats,tp,c)
	if #mg>0 and Duel.SendtoGrave(mg,REASON_EFFECT)>0 and mg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		Duel.AdjustAll()
		mats=Duel.Group(aux.Necro(s.xyzmat),tp,LOCATION_GRAVE,0,nil,c)
		if #mats>0 then
			Duel.XyzSummon(tp,c,mats,1,#mats)
		end
	end
end

--E3
function s.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsAbleToEnterBP() end
end
function s.skipop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:Desc(3,id)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,Duel.GetTurnPlayer())
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