--[[
珠乌 LV6：托特的力量
Horou LV6: Thoth
Horou LV6: Thoth
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[You can Special Summon this card (from your hand) by banishing 7 monsters with different card types from your GY.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--[[(Quick Effect): You can banish 7 cards with different card types from either field and/or GY; Special Summon any number of monsters from your GY with different Attributes from each other (max. 1 for each Attribute), also you cannot Special Summon monsters for the rest of this turn, also skip your next Battle Phase]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1)
	e2:SetCategory(CATEGORY_REMOVE|CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRelevantTimings()
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--[[During your Main Phase 2, if this card battled this turn: You can Special Summon 1 "Horou RKX: Hollow Song of Birds" from your Extra Deck,
	using this card and 7 of your banished cards with different card types as material.]]
	local e3=Effect.CreateEffect(c)
	e3:Desc(3)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.xyzcon)
	e3:SetTarget(s.xyztg)
	e3:SetOperation(s.xyzop)
	c:RegisterEffect(e3)
end
s.lvdn={id-1,id-2}

local TYPES_TABLE = {TYPE_NORMAL,TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK,TYPE_SPELL,TYPE_TRAP}

--E1
function s.types(c)
	local typ=c:GetType()&(TYPE_NORMAL|TYPE_FUSION|TYPE_RITUAL|TYPE_SYNCHRO|TYPE_XYZ|TYPE_PENDULUM|TYPE_LINK|TYPE_SPELL|TYPE_TRAP)
	if typ~=0 then
		return typ
	elseif c:IsType(TYPE_EFFECT) then
		return TYPE_EFFECT
	else
		return 0
	end
end
function s.fselect(g,e,tp)
	local res=g:GetClassCount(s.types)==#g
	return Duel.GetMZoneCount(tp,g)>0 and res, not res
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,nil)
	if #rg<7 then return false end
	local optimization_chk=false
	local ct = rg:IsExists(s.excfilter,1,nil) and 1 or 0
	for i=1,#TYPES_TABLE do
		if rg:IsExists(Card.IsType,1,nil,TYPES_TABLE[i]) then
			ct=ct+1
			if ct==7 then
				optimization_chk=true
				break
			end
		end
	end
	return optimization_chk and aux.SelectUnselectGroup(rg,e,tp,7,7,s.fselect,0)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=aux.SelectUnselectGroup(rg,e,tp,7,7,s.fselect,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end

--E2
function s.rmfilter(c)
	return c:IsFaceupEx() and c:IsAbleToRemoveAsCost()
end
function s.excfilter(c)
	return c:IsMonster(TYPE_EFFECT) and not c:IsType(TYPE_NORMAL|TYPE_FUSION|TYPE_RITUAL|TYPE_SYNCHRO|TYPE_XYZ|TYPE_PENDULUM)
end
function s.gcheck(sg,e,tp,mg,c)
	local res=sg:GetClassCount(s.types)==#sg
	return Duel.GetMZoneCount(tp,sg)>0 and res, not res
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_ONFIELD|LOCATION_GRAVE,LOCATION_ONFIELD|LOCATION_GRAVE,nil)
	if chk==0 then
		if #g<7 then return false end
		local optimization_chk=false
		local ct = g:IsExists(s.excfilter,1,nil) and 1 or 0
		for i=1,#TYPES_TABLE do
			if g:IsExists(Card.IsType,1,nil,TYPES_TABLE[i]) then
				ct=ct+1
				if ct==7 then
					optimization_chk=true
					break
				end
			end
		end
		return optimization_chk and aux.SelectUnselectGroup(g,e,tp,7,7,s.gcheck,0)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=aux.SelectUnselectGroup(g,e,tp,7,7,s.gcheck,1,tp,HINTMSG_REMOVE,nil,nil,false)
	if #sg>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end
end
function s.spfilter(c,e,tp)
	return c:GetAttribute()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (e:IsCostChecked() or Duel.GetMZoneCount(tp)>0) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.atcheck(g,e,tp,mg,c)
	if #g==1 then return true, false end
	local att=1
	while att<ATTRIBUTE_ALL do
		local ct=g:FilterCount(Card.IsAttribute,nil,att)
		if ct>1 then
			return false, true
		end
		att=att*2
	end
	return true, false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	if ft>0 then
		local g=Duel.GetMatchingGroup(aux.Necro(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if #g>0 then
			if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
				ft=1
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local ct=math.min(ft,#g)
			local sg=aux.SelectUnselectGroup(g,e,tp,ct,ct,s.atcheck,1,tp,HINTMSG_SPSUMMON,nil,nil,false)
			if #sg>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE|PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SKIP_BP)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	if Duel.IsTurnPlayer(tp) and Duel.IsBattlePhase() then
		e2:SetLabel(Duel.GetTurnCount())
		e2:SetCondition(function(e) return Duel.GetTurnCount()~=e:GetLabel() end)
		e2:SetReset(RESET_PHASE|PHASE_BATTLE|RESET_SELF_TURN,2)
	else
		e2:SetReset(RESET_PHASE|PHASE_BATTLE|RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e2,tp)
end

--E3
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase(nil,2) and e:GetHandler():GetBattledGroupCount()>0
end
function s.matfilter(c,xyzc,e)
	if not (c:IsFaceup() and not c:IsImmuneToEffect(e) and not c:IsForbidden()) then return false end
	local eset={c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL)}
	for _,e in ipairs(eset) do
		local val=e:Evaluate(xyzc)
		if val then
			return false
		end
	end
	return true
end
function s.xyzfilter(c,e,tp,sc)
	local xyzg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_REMOVED,0,sc,c,e)
	if #xyzg<7 then return false end
	local optimization_chk=false
	local ct = xyzg:IsExists(s.excfilter,1,nil) and 1 or 0
	for i=1,#TYPES_TABLE do
		if xyzg:IsExists(Card.IsType,1,nil,TYPES_TABLE[i]) then
			ct=ct+1
			if ct==7 then
				optimization_chk=true
				break
			end
		end
	end
	return optimization_chk and c:IsType(TYPE_XYZ) and c:IsCode(id+1) and sc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and aux.SelectUnselectGroup(xyzg,e,tp,7,7,s.xyzcheck(sc,c),0)
end
function s.xyzcheck(sc,xyzc)
	return	function(g,e,tp,mg,c)
				local sg=g:Clone()
				sg:AddCard(sc)
				return Duel.GetLocationCountFromEx(tp,tp,sg,xyzc)>0 and g:GetClassCount(s.types)==#g, g:GetClassCount(s.types)~=#g
			end
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sc=e:GetHandler()
		return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sc)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or c:IsImmuneToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
	local xyzc=sg:GetFirst()
	if not xyzc then return end
	local xyzg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_REMOVED,0,nil,xyzc,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=aux.SelectUnselectGroup(xyzg,e,tp,7,7,s.xyzcheck(c,xyzc),1,tp,HINTMSG_XMATERIAL,nil,nil,false)
	if not mg or #mg~=7 then return end
	Duel.HintSelection(mg)
	mg:AddCard(c)
	xyzc:SetMaterial(mg)
	Duel.Attach(mg,xyzc)
	Duel.SpecialSummon(xyzc,0,tp,tp,false,false,POS_FACEUP)
end