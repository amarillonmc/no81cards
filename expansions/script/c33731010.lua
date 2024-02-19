--[[
珠乌 LV4：七色的虹彩
Horou LV4: Rainbow
Horou LV4: Arcobaleno
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[You can Special Summon this card (from your hand) by banishing 5 monsters with different card types from your GY.]]
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
	--[[When a monster effect is activated (Quick Effect): You can banish 1 monster with the same card type from your GY,
	and if you do, negate that effect, and if you do that, you can shuffle this card into your Deck, then Special Summon 1 "Horou LV6: Thoth" from your hand or Deck.]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE|CATEGORY_REMOVE|CATEGORY_TODECK|CATEGORY_SPECIAL_SUMMON|CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end
s.lvup={id+1}
s.lvdn={id-1}

local TYPES_TABLE = {TYPE_NORMAL,TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK}

--E1
function s.types(c)
	local typ=c:GetType()&(TYPE_NORMAL|TYPE_FUSION|TYPE_RITUAL|TYPE_SYNCHRO|TYPE_XYZ|TYPE_PENDULUM|TYPE_LINK)
	if typ~=0 then
		return typ
	elseif c:IsType(TYPE_EFFECT) then
		return TYPE_EFFECT
	else
		return 0
	end
end
function s.excfilter(c)
	return c:IsMonster(TYPE_EFFECT) and not c:IsType(TYPE_NORMAL|TYPE_FUSION|TYPE_RITUAL|TYPE_SYNCHRO|TYPE_XYZ|TYPE_PENDULUM)
end
function s.sprfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.fselect(g,e,tp)
	return Duel.GetMZoneCount(tp,g)>0 and g:GetClassCount(s.types)==#g, g:GetClassCount(s.types)~=#g
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_GRAVE,0,nil)
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
	return optimization_chk and aux.SelectUnselectGroup(rg,e,tp,5,5,s.fselect,0)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=aux.SelectUnselectGroup(rg,e,tp,5,5,s.fselect,1,tp,HINTMSG_REMOVE,nil,nil,true)
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
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsDisabled() and Duel.IsChainDisablable(ev)
end
function s.rmfilter(c,typ)
	return c:IsMonster() and c:IsType(typ) and (typ~=TYPE_EFFECT or not c:IsType(TYPE_NORMAL|TYPE_FUSION|TYPE_RITUAL|TYPE_SYNCHRO|TYPE_XYZ|TYPE_PENDULUM|TYPE_LINK)) and c:IsAbleToRemove()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if c:GetFlagEffect(id)~=0 then return false end
		local typ=re:GetActiveType()&(TYPE_NORMAL|TYPE_FUSION|TYPE_RITUAL|TYPE_SYNCHRO|TYPE_XYZ|TYPE_PENDULUM|TYPE_LINK)
		if typ==0 and re:IsActiveType(TYPE_EFFECT) then
			typ=TYPE_EFFECT
		end
		return not re:GetHandler():IsStatus(STATUS_DISABLED) and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,1,nil,typ)
	end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function s.spfilter(c,e,tp)
	return c:IsCode(id+1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local typ=re:GetActiveType()&(TYPE_NORMAL|TYPE_FUSION|TYPE_RITUAL|TYPE_SYNCHRO|TYPE_XYZ|TYPE_PENDULUM|TYPE_LINK)
	if typ==0 and re:IsActiveType(TYPE_EFFECT) then
		typ=TYPE_EFFECT
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.Necro(s.rmfilter),tp,LOCATION_GRAVE,0,1,1,nil,typ)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and Duel.NegateEffect(ev) then
		local c=e:GetHandler()
		if c:IsRelateToChain() and c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) and Duel.ShuffleIntoDeck(c)>0 and Duel.GetMZoneCount(tp)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil,e,tp)
			if #sg>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end