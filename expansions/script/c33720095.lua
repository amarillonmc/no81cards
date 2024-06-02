--[[
烈冥王击
Blast of Raging Styx
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[Activate only if this is the only card in your Spell & Trap Zone, and the only monster you control is a Machine or Psychic Xyz Monster. Target that monster; detach all materials from it, and if you do, apply the following effects in sequence:
	● Negate the effects of all cards your opponent controls, also all monsters they currently control lose 1000 ATK/DEF for each material detached by this card's effect. 
	● Send all monsters your opponent controls with 0 ATK or DEF to the GY, and if you do, if all of your opponent's monsters were sent to the GY by this effect, inflict damage to your opponent equal to the number of materials detached by this card's effect x 1000.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DISABLE|CATEGORIES_ATKDEF|CATEGORY_TOGRAVE|CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.filter(c,tp,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE|RACE_PSYCHO) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and (not e or c:IsCanBeEffectTarget(e))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.Group(Card.IsInBackrow,tp,LOCATION_SZONE,0,nil)
	return #g1==1 and g1:GetFirst()==c
end
function s.tgfilter(c)
	return c:IsFaceup() and (c:IsAttack(0) or c:IsDefense(0)) and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g2=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if chkc then return #g2==1 and chkc==g2:GetFirst() and s.filter(chkc,tp) end
	local disg=Duel.Group(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
	local atkg=Duel.Group(Card.IsCanChangeStats,tp,0,LOCATION_MZONE,nil)
	local tgyg=Duel.Group(s.tgfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then
		return #g2==1 and s.filter(g2:GetFirst(),tp,e)
			and ((#disg>0 and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or (#atkg>0 and not Duel.IsDamageCalculated())))
			or (#tgyg>0 and Duel.GetCurrentPhase()~=PHASE_DAMAGE))
	end
	Duel.SetTargetCard(g2:GetFirst())
	if #disg>0 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,disg,#disg,1-tp,LOCATION_ONFIELD)
	else
		Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD)
	end
	
	if #atkg>0 then
		Duel.SetCustomOperationInfo(0,CATEGORIES_ATKDEF,atkg,#atkg,1-tp,LOCATION_MZONE,-1000)
	else
		Duel.SetPossibleCustomOperationInfo(0,CATEGORIES_ATKDEF,atkg,#atkg,1-tp,LOCATION_MZONE,-1000)
	end
	
	if #tgyg>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tgyg,#tgyg,1-tp,LOCATION_MZONE)
		if #tgyg==Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) then
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#g*1000)
		else
			Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
		end
	else
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
		Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToChain() or not tc:IsType(TYPE_XYZ) then return end
	local max=tc:GetOverlayCount()
	while max>0 do
		if tc:CheckRemoveOverlayCard(tp,max,REASON_EFFECT) then
			break
		end
		max=max-1
	end
	if max==0 then return end
	tc:RemoveOverlayCard(tp,max,max,REASON_EFFECT)
	local mustbreak=false
	local disg=Duel.Group(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil):Filter(Card.IsCanBeDisabledByEffect,nil,e)
	if #disg>0 then
		if Duel.Negate(disg,e,false,false,false,TYPE_NEGATE_ALL)>0 then
			local atkg=Duel.Group(Card.IsCanChangeStats,tp,0,LOCATION_MZONE,nil)
			local val=max*-1000
			for ac in aux.Next(atkg) do
				ac:UpdateATKDEF(val,val,0,{c,true})
				Duel.AdjustInstantly(ac)
			end
			mustbreak=false
		end
	end
	
	local tgyg=Duel.Group(s.tgfilter,tp,0,LOCATION_MZONE,nil)
	if #tgyg>0 then
		if mustbreak then Duel.BreakEffect() end
		local prevg=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		if Duel.SendtoGrave(tgyg,REASON_EFFECT)>0 and Duel.GetGroupOperatedByThisEffect(e):FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==prevg and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0 then
			Duel.Damage(1-tp,max*1000,REASON_EFFECT)
		end
	end
end