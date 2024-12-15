--[[
秘密结社337的神脑，菲尔
Phil, Brain of MYTH-337
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[When this card is Summoned: You can look at the top 5 cards of your opponent's Deck, and if you do, you can banish 1 of them, then add 1 card from your hand to their Deck in the same place
	the banished card was in, and place the rest on the top of their Deck in the same order.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_REMOVE|CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	e1:SpecialSummonEventClone(c)
	e1:FlipSummonEventClone(c)
	--[[If this card is destroyed by your opponent: You can Special Summon 1 "MYTH-337, M.E.L.L.O.W." from your hand or Deck (this is treated as a Ritual Summon).]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(2,id)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetFunctions(s.spcon,nil,s.sptg,s.spop)
	c:RegisterEffect(e2)
end
--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetDeckCount(1-tp)>=5
	end
	local g=Duel.GetDecktopGroup(1-tp,5)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK,1-tp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,5)
	if #g<5 then return end
	Duel.ConfirmCards(tp,g)
	local rg=g:Filter(Card.IsAbleToRemove,nil)
	if #rg>0 and Duel.IsExists(false,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,STRING_ASK_REMOVE) then
		Duel.HintMessage(tp,HINTMSG_REMOVE)
		local rc=rg:Select(tp,1,1,nil):GetFirst()
		if rc then
			Duel.DisableShuffleCheck()
			local ct=Duel.GetDeckCount(1-tp)
			local seq=rc:GetSequence()
			if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 then
				local tg=Duel.Group(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
				if #tg>0 then
					Duel.HintMessage(tp,HINTMSG_TODECK)
					local tc=tg:Select(tp,1,1,nil):GetFirst()
					if tc then
						Duel.BreakEffect()
						if Duel.SendtoDeck(tc,1-tp,SEQ_DECKTOP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK) and tc:IsControler(1-tp) and ct-seq>1 then
							local mg=Duel.GetDecktopGroup(1-tp,ct-seq)
							for i=1,ct-seq-1 do
								local mc=mg:GetMinGroup(Card.GetSequence,nil):GetFirst()
								Duel.MoveSequence(mc,SEQ_DECKTOP)
							end
						end
					end
				end
			end
		end
	end
end

--E2
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.spfilter(c,e,tp)
	return c:IsMonster(TYPE_RITUAL) and c:IsCode(id+1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end