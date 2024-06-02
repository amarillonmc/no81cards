--[[
朝闻道，落命于夕
Fatal Realization
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[Add 1 card from your Deck to your hand, except "Fatal Realization" (and if you do, if it is a monster, you can Special Summon it, or if it is a Spell/Trap,
	you can activate it immediately after this Chain resolves) and if you do, your opponent applies 1 of these effects:
	● They add 2 cards from their Deck to their hand, and if they do, if they added a monster, they can Special Summon it, ignoring its Summoning conditions.
	● During the 2nd End Phase after this card resolves, your LP becomes 0.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--During your first turn of the Duel, you can activate this card from your hand.
	local e2=Effect.CreateEffect(c)
	e2:Desc(6,id)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end

--E1
function s.thfilter(c)
	return c:IsAbleToHand() and not c:IsCode(id)
end
function s.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExists(false,s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,2,1-tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.Select(HINTMSG_ATOHAND,false,tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SearchAndCheck(g,tp) then
		local te=nil
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc:IsMonster() then
			if Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		elseif tc:IsST() then
			te=tc:GetActivateEffect()
		end
		local b1=Duel.IsExists(false,Card.IsAbleToHand,1-tp,LOCATION_DECK,0,2,nil)
		local opt=aux.Option(1-tp,id,3,b1,true)
		if opt==0 then
			local g2=Duel.Select(HINTMSG_ATOHAND,false,1-tp,Card.IsAbleToHand,1-tp,LOCATION_DECK,0,2,2,nil)
			if #g2>0 and Duel.SearchAndCheck(g2,1-tp) then
				local ft=Duel.GetMZoneCount(1-tp,nil,1-tp)
				if ft>0 then
					local sg=Duel.GetOperatedGroup():Filter(s.spfilter,nil,e,1-tp)
					if #sg>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
						if Duel.IsPlayerAffectedByEffect(1-tp,CARD_BLUEEYES_SPIRIT) then
							ft=1
						end
						Duel.HintMessage(1-tp,HINTMSG_SPSUMMON)
						local sg2=sg:Select(1-tp,1,math.min(2,#sg),nil)
						for sc in aux.Next(sg2) do
							Duel.SpecialSummonStep(sc,0,1-tp,1-tp,true,false,POS_FACEUP)
						end
					end
				end
			end
		elseif opt==1 then
			local e1=Effect.CreateEffect(c)
			e1:Desc(5,id)
			e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE|PHASE_END)
			e1:SetCountLimit(1)
			e1:SetCondition(s.damcon)
			e1:SetOperation(s.damop)
			e1:SetLabel(Duel.GetTurnCount()+1)
			e1:SetReset(RESET_PHASE|PHASE_END,2)
			Duel.RegisterEffect(e1,1-tp)
		end
		Duel.SpecialSummonComplete()
		aux.ApplyEffectImmediatelyAfterChainResolution(s.newchain(te),c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==Duel.GetTurnCount()
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.SetLP(1-tp,0)
end
function s.newchain(te)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if te then
					local tc=te:GetHandler()
					local e1=Effect.CreateEffect(c)
					e1:Desc(6,id)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE)
					e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
					e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_CHAIN)
					tc:RegisterEffect(e1,true)
					local e2=Effect.CreateEffect(c)
					e2:Desc(6,id)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE)
					e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
					e2:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_CHAIN)
					tc:RegisterEffect(e2,true)
					local check=te:IsActivatable(tp)
					if check and Duel.SelectYesNo(tp,aux.Stringid(id,7)) then
						Duel.Activate(te)
					else
						e1:Reset()
						e2:Reset()
					end
				end
			end
end

--E2
function s.handcon(e)
	local p=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==p and Duel.GetTurnCount(p)==1
end