--直面光明
--Facing the Light || Affrontare la Luce
--Scripted by: XGlitchy30

xpcall(function() require("expansions/script/glitchylib_vsnemo") end,function() require("script/glitchylib_vsnemo") end)

local s,id,o=GetID()
function s.initial_effect(c)
	--[[Banish, from your hand, field, and/or Extra Deck, LIGHT monsters with a total Level of 50 or more,
	and if you do, your opponent sends to the GY, 1 monster they control, 1 card in their Spell & Trap Card Zones, and 1 card in their hand,
	and if less than 3 cards are sent to the GY by this effect, inflict damage to your opponent equal to the difference x 800.
	If this card is activated on or after the 5th turn of this Duel, you can also banish cards from your GY.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORY_REMOVE|CATEGORY_TOGRAVE|CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:HOPT(true)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--FILTERS E1
function s.rmfilter(c)
	return (not c:IsOnField() or c:IsFaceup()) and c:IsMonster() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:HasLevel() and c:IsAbleToRemove()
end
function s.gcheck(g)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,50)
end
function s.tgfilter(c,tp)
	return (not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5) and Duel.IsPlayerCanSendtoGrave(1-tp,c)
end
function s.tgcheck(g)
	return g:GetClassCount(Card.GetLocation)==#g
end
--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND|LOCATION_MZONE|LOCATION_EXTRA
	if Duel.GetTurnCount()>=5 then
		loc=loc|LOCATION_GRAVE
	end
	if chk==0 then
		local g=Duel.Group(s.rmfilter,tp,loc,0,nil)
		return #g>0 and g:CheckWithSumGreater(Card.GetLevel,50)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,loc)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND|LOCATION_MZONE|LOCATION_EXTRA
	if Duel.GetTurnCount()>=5 then
		loc=loc|LOCATION_GRAVE
	end
	local g=Duel.Group(aux.Necro(s.rmfilter),tp,loc,0,nil)
	if #g>0 and g:CheckWithSumGreater(Card.GetLevel,50) then
		Duel.HintMessage(tp,HINTMSG_REMOVE)
		local rg=g:SelectWithSumGreater(tp,Card.GetLevel,50)
		if #rg>0 and Duel.Banish(rg)>0 then
			local ct=3
			local sg=Duel.Group(s.tgfilter,tp,0,LOCATION_HAND|LOCATION_MZONE|LOCATION_SZONE,nil,tp)
			if #sg>0 then
				local min=3
				local loclist={LOCATION_HAND,LOCATION_MZONE,LOCATION_SZONE}
				for i=1,3 do
					if not sg:IsExists(Card.IsLocation,1,nil,loclist[i]) then
						min=min-1
						if min==1 then
							break
						end
					end
				end
				Duel.HintMessage(1-tp,HINTMSG_TOGRAVE)
				aux.GCheckAdditional=s.tgcheck
				local tg=sg:SelectSubGroup(1-tp,aux.TRUE,false,min,min)
				aux.GCheckAdditional=nil
				if #tg>0 and Duel.SendtoGrave(tg,REASON_RULE)>0 then
					local oct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
					ct=3-oct
				end
			end
			if ct>0 then
				Duel.Damage(1-tp,ct*800,REASON_EFFECT)
			end
		end
	end
end