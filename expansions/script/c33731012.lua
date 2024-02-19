--[[
珠乌 RKX：响彻珍珠岛
Horou RKX: Hollow Song of Birds
Horou RKX: Canto Vacuo degli Uccelli
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,6,6)
	--[[If this card has 2 or more cards as material, and all with different card types from each other (Normal, Effect, Fusion, Ritual, Synchro, Xyz, Pendulum, Link, Spell, Trap),
	it is unaffected by your opponent's card effects, also it cannot be destroyed by battle.]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.econ)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1x:SetValue(1)
	c:RegisterEffect(e1)
	--[[Once per turn (Quick Effect): You can detach 1 material from this card; negate the effects of all cards currently on the field with same card type as the detached card,
	also neither player can activate the effects of cards of that type for the rest of this turn, also, if you detached "Monster Reborn" to activate this effect, skip your opponent's next turn.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(0)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:OPT()
	e2:SetRelevantTimings()
	e2:SetCost(aux.DummyCost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	--[[If this card is destroyed by your opponent: You can banish 7 cards with different card types from your GY, and if you do, inflict 7000 damage to your opponent.]]
	local e3=Effect.CreateEffect(c)
	e3:Desc(1)
	e3:SetCategory(CATEGORY_REMOVE|CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(s.tdcondition)
	e3:SetTarget(s.tdtarget)
	e3:SetOperation(s.tdoperation)
	c:RegisterEffect(e3)
end

local TYPES_TABLE = {TYPE_NORMAL,TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK,TYPE_SPELL,TYPE_TRAP}

function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsXyzLevel(xyzc,10)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetAttribute)==#g
end

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
function s.gcheck(sg,e,tp,mg,c)
	local res=sg:GetClassCount(s.types)==#sg
	return res, not res
end
function s.excfilter(c)
	return c:IsMonster(TYPE_EFFECT) and not c:IsType(TYPE_NORMAL|TYPE_FUSION|TYPE_RITUAL|TYPE_SYNCHRO|TYPE_XYZ|TYPE_PENDULUM)
end
function s.econ(e)
	local g=e:GetHandler():GetOverlayGroup()
	if #g<2 then return false end
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
	return optimization_chk and aux.SelectUnselectGroup(g,e,tp,#g,#g,s.gcheck,0)
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--E2
function s.dtfilter(c,tp)
	return Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,s.types(c))
end
function s.disfilter(c,typ)
	if not aux.NegateAnyFilter(c) then return false end
	return s.types(c)&typ>0
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then
		if not (e:IsCostChecked() and #g>0 and g:IsExists(s.dtfilter,1,nil,tp)) then return false end
		local val=1
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_OVERLAY_REMOVE_COST_CHANGE_KOISHI)}
		for _,se in ipairs(eset) do
			val=se:Evaluate(e,tp,1,REASON_COST,c)
		end
		return val==1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local tc=g:FilterSelect(tp,s.dtfilter,1,1,nil):GetFirst()
	local typ=s.types(tc)
	Duel.SetTargetParam(typ)
	if tc:IsCode(CARD_MONSTER_REBORN) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SendtoGrave(tc,REASON_COST)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	local g=Duel.GetMatchingGroup(s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,typ)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local typ=Duel.GetTargetParam()
	local g=Duel.GetMatchingGroup(s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,typ):Filter(Card.IsCanBeDisabledByEffect,nil,e)
	for tc in aux.Next(g) do
		Duel.Negate(tc,e,0,false,false,TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP)
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	if typ==TYPE_EFFECT then
		e1:SetValue(s.aclimit_eff)
	else
		e1:SetLabel(typ)
		e1:SetValue(s.aclimit)
	end
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if e:GetLabel()==1 and e:IsActivated() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE|PHASE_END|RESET_OPPO_TURN,Duel.IsTurnPlayer(tp) and 1 or 2)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.aclimit(e,re,tp)
	local typ=e:GetLabel()
	return re:IsActiveType(typ)
end
function s.aclimit_eff(e,re,tp)
	return not re:IsActiveType(TYPE_NORMAL|TYPE_FUSION|TYPE_RITUAL|TYPE_SYNCHRO|TYPE_XYZ|TYPE_PENDULUM|TYPE_LINK|TYPE_SPELL|TYPE_TRAP)
end

--E3
function s.tdcondition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.tdtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
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
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,7,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,7000)
end
function s.tdoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.Necro(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,nil)
	if #g<7 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=aux.SelectUnselectGroup(g,e,tp,7,7,s.gcheck,1,tp,HINTMSG_REMOVE,nil,nil,false)
	if #sg>0 and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)==7 then
		Duel.Damage(1-tp,7000,REASON_EFFECT)
	end
end