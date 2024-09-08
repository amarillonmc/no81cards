--[[
动物朋友 网纹长颈鹿
Anifriends R. Giraffe
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[You can discard this card; add 1 "Anifriends" monster from your Deck to your hand, except "Anifriends R. Giraffe", and if you do, for the rest of this turn,
	you cannot activate the effects of monsters with the added monster's name.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetFunctions(nil,aux.DiscardSelfCost,s.thtg,s.thop)
	c:RegisterEffect(e1)
	--[[Once per turn, during your Main Phase: You can reveal this card in your hand and have your opponent declare 1 card name, except "Anifriends R. Giraffe";
	reveal your hand, and if you do, if the declared card is not in your hand and there are no cards with the same name in your hand, Special Summon this card.
	Otherwise, send this card to the GY.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:OPT()
	e2:SetFunctions(nil,aux.RevealSelfCost(),s.sptg,s.spop)
	c:RegisterEffect(e2)
	--[[This Defense Position card cannot be destroyed by battle or card effects.]]
	c:CannotBeDestroyedByBattle(1,s.pccon)
	c:CannotBeDestroyedByEffects(1,s.pccon)
end
--E1
function s.thfilter(c)
	return c:IsMonster() and c:IsSetCard(ARCHE_ANIFRIENDS) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SearchAndCheck(g) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetLabel(g:GetFirst():GetCode())
		e1:SetValue(s.aclimit)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end

--E2
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local hand=Duel.GetHand(tp)
		return #hand>1 and not hand:IsExists(Card.IsPublic,1,nil) and (c:IsAbleToGrave() or (Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	s.announce_filter={TYPE_EXTRA,OPCODE_ISTYPE,OPCODE_NOT,id,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,c,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local hand=Duel.GetHand(tp)
	if #hand==0 then return end
	Duel.ConfirmCards(1-tp,hand)
	local code=Duel.GetTargetParam()
	local c=e:GetHandler()
	local chainrel=c:IsRelateToChain()
	if not hand:IsExists(Card.IsCode,1,nil,code) and hand:GetClassCount(Card.GetCode)==#hand then
		if chainrel then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif chainrel then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end

--E3
function s.pccon(e)
	return e:GetHandler():IsDefensePos()
end