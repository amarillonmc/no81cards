--[[
动物朋友的光辉
Sparkle of Anifriends
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--This card's name becomes "Anifriends Serval" while in the GY.
	aux.EnableChangeCode(c,CARD_ANIFRIENDS_SERVAL,LOCATION_GRAVE)
	--(Quick Effect): You can shuffle this card you control into the Deck; Special Summon 1 "Anifriends" monster from your Deck.
	local e2=Effect.CreateEffect(c)
	e2:Desc(0,id)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetRelevantTimings()
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--During the End Phase (Quick Effect): You can discard this card; declare 1 "Anifriends" Monster Card name. If a card with the declared name is in your GY, add all such cards from your GY to your hand, and if you do, you lose LP equal to the total ATK of the added monsters (if any).
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_TOHAND|CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCondition(aux.EndPhaseCond())
	e2:SetCost(aux.DiscardSelfCost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
--E1
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() and Duel.GetMZoneCount(tp,c)>0 end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ftchk=e:IsCostChecked() or Duel.GetMZoneCount(tp)>0
		return ftchk and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--E2
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function s.damfilter(c)
	return c:IsMonster() and c:IsLocation(LOCATION_HAND|LOCATION_DECK|LOCATION_EXTRA)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	s.announce_filter={ARCHE_ANIFRIENDS,OPCODE_ISSETCARD,TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
	local g=Duel.Group(aux.Necro(s.thfilter),tp,LOCATION_GRAVE,0,nil,ac)
	if #g>0 and Duel.SearchAndCheck(g,tp) then
		local sg=Duel.GetOperatedGroup():Filter(s.damfilter,nil)
		if #sg>0 then
			local val=sg:GetSum(Card.GetAttack)
			if val>0 then
				Duel.LoseLP(tp,val)
			end
		end
	end
end