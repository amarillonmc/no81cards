--[[
临终幻象 -暴雪冬风-
Healing Vision - Blizzard -
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--If you control no cards, you can activate this card from your hand.
	c:TrapCanBeActivatedFromHand(s.handactcon,aux.Stringid(id,0))
	--At the start of your opponent's Battle Phase, if the total ATK of all face-up monsters they control is higher than your LP: Excavate cards from the top of your Deck until you excavate a number of monsters whose total ATK is higher than the difference between the players' LP, then, if the number of monsters excaveted this way is higher than the number of cards your opponent controls, you can Special Summon any number of them, and banish the remaining monsters, and if you do, you gain LP equal of the total ATK of those banished monsters. Also, banish all other excavated cards, face-down.
	local e1=Effect.CreateEffect(c)
	e1:Desc(1,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_REMOVE|CATEGORY_RECOVER|CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetFunctions(
		s.condition,
		nil,
		s.target,
		s.operation
	)
	c:RegisterEffect(e1)
end
function s.handactcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end

--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()==PHASE_BATTLE_START and Duel.IsTurnPlayer(1-tp)) then return false end
	local g=Duel.Group(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return false end
	return g:GetSum(Card.GetAttack)>Duel.GetLP(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not (Duel.IsPlayerCanRemove(tp) and Duel.IsPlayerCanDiscardDeck(tp,1)) then return false end
		local g=Duel.Group(Card.IsMonster,tp,LOCATION_DECK,0,nil)
		return g:GetSum(Card.GetAttack)>math.abs(Duel.GetLP(0)-Duel.GetLP(1))
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	local g=Duel.GetMatchingGroup(Card.IsMonster,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetDeckCount(tp)
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	
	local seqs={}
	for tc in aux.Next(g) do
		table.insert(seqs,tc:GetSequence())
	end
	table.sort(seqs, function(a,b) return a > b end)
	
	local atk,lpdiff=0,math.abs(Duel.GetLP(0)-Duel.GetLP(1))
	for _,tempseq in ipairs(seqs) do
		local sc=g:Filter(Card.IsSequence,nil,tempseq):GetFirst()
		atk=atk+sc:GetAttack()
		if atk>lpdiff then
			seq=tempseq
			break
		end
	end
	
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	
	Duel.ConfirmDecktop(tp,dcount-seq)
	local mg=g:Filter(Card.IsSequenceAbove,nil,seq)
	local sg=mg:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	local ft=Duel.GetMZoneCountForMultipleSpSummon(tp)
	local max=math.min(#sg,ft)
	Duel.DisableShuffleCheck()
	if #mg>Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) and ft>0 and xgl.SelectUnselectGroup(sg,e,tp,1,max,s.rescon(mg),0)
		and Duel.SelectYesNo(tp,STRING_ASK_SPSUMMON) then
		local spg=sg:GetFirst()
		if #sg>1 then
			spg=xgl.SelectUnselectGroup(sg,e,tp,1,max,s.rescon(mg),1,tp,HINTMSG_SPSUMMON,s.rescon(mg))
		end
		Duel.BreakEffect()
		if Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)>0 then
			mg:Sub(spg)
			local rg=mg:Filter(Card.IsAbleToRemove,nil)
			if #rg>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT|REASON_REVEAL)>0 then
				local rg1=rg:Filter(s.rmfilter,nil)
				if #rg1>0 then
					local lp=rg1:GetSum(Card.GetAttack)
					Duel.Recover(tp,math.max(atk,0),REASON_EFFECT)
				end
			end
		end
	end
	local fg=Duel.GetDeck(tp):Filter(Card.IsSequenceAbove,nil,seq):Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
	if #fg>0 then
		Duel.Remove(fg,POS_FACEDOWN,REASON_EFFECT|REASON_REVEAL)
	end
end
function s.spfilter(c,e,tp,seq)
	return c:IsSequenceAbove(seq) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rescon(mg)
	return	function(g,e,tp,_,c)
				local valid = #mg==#g or mg:IsExists(Card.IsAbleToRemove,1,g)
				local razor = #mg>#g and {s.razorfilter,tp,mg,g} or nil
				return valid,false,razor
			end
end
function s.razorfilter(c,tp,mg,g)
	return mg:IsExists(Card.IsAbleToRemove,1,g:Clone()+c)
end
function s.rmfilter(c)
	return c:IsMonster() and c:IsLocation(LOCATION_REMOVED)
end