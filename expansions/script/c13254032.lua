--元始飞球·金
local m=13254032
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
--[[
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost1)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
]]
	elements={{"tama_elements",{{TAMA_ELEMENT_EARTH,2}}}}
	cm[c]=elements
end
local to_deck=1
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.dFilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.dFilter(c)
	return tama.tamas_isExistElement(c,TAMA_ELEMENT_EARTH)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.DiscardHand(tp,cm.dFilter,1,2,REASON_EFFECT+REASON_DISCARD)
	if ct>0 then
		Duel.BreakEffect()
		--Duel.Draw(tp,ct,REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_EARTH,2}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.setfilter(c,e,tp)
	return (c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and (not c:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp)>0)) 
	or ((c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable())
end
function cm.setfilter1(c,e,tp)
	return not c:IsType(TYPE_MONSTER) and ((c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable())
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.setfilter(chkc,e,tp) end
	if chk==0 then return 
		(not Duel.IsExistingMatchingCard(cm.setfilter1,tp,0,LOCATION_GRAVE,1,nil,e,tp) or Duel.IsPlayerAffectedByEffect(tp,59822133))
		and Duel.IsExistingTarget(cm.setfilter,tp,0,LOCATION_GRAVE,to_deck,nil,e,tp) 
	end
	local ft=to_deck
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then 
		ft=1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		Duel.SelectTarget(tp,cm.setfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,cm.setfilter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
	local sg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	local cat=e:GetCategory()
	if sg:GetCount()>0 then
		e:SetCategory(bit.bor(cat,CATEGORY_SPECIAL_SUMMON))
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
	else
		e:SetCategory(bit.band(cat,bit.bnot(CATEGORY_SPECIAL_SUMMON)))
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,to_deck,1-tp,LOCATION_ONFIELD)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:FilterCount(Card.IsRelateToEffect,nil,e)~=to_deck or 
		(g:IsExists(Card.IsType,to_deck,nil,TYPE_MONSTER) and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	local tc=g:GetFirst()
	local ct=0
	while tc do
		if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and (not tc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp)>0)
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
			ct=ct+1
		elseif (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and tc:IsSSetable() then
			Duel.BreakEffect()
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
			ct=ct+1
		end
		tc=g:GetNext()
	end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if ct==to_deck and sg:GetCount()>=to_deck then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=sg:Select(tp,to_deck,to_deck,nil)
		Duel.SendtoDeck(sg1,nil,2,REASON_EFFECT)
	end
end
