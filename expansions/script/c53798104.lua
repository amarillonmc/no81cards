--Card Name: (User Defined)
--Scripted by Gem
local s,id=GetID()
function s.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--Effect 1: Negate activation, then opponent recovers from GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	
	--Effect 2: Banish from GY to peek hand and steal/set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.handcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.handtg)
	e2:SetOperation(s.handop)
	c:RegisterEffect(e2)
end

--Effect 1 Logic
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	--Ref: Number 104 (Source 2), checking opponent, monster effect, and negatable
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		--Ref: Ogdoadic Serpent Strike (Source 4, 5) for "Then, opponent can..." logic
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,0,LOCATION_GRAVE,nil)
		if #g>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,sg)
		end
	end
end

--Effect 2 Logic
function s.handcon(e,tp,eg,ep,ev,re,r,rp)
	--During opponent's Battle Phase or End Phase
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==1-tp and 
		((ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_END)
end

function s.handtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	--Ref: Mind Crush (Source 12) for declaration
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end

--Helper filter: Check if a card can be Added to Hand OR Set/Special Summoned
function s.opfilter(c,e,tp)
	--Check Option 1: Add to TP's Hand
	--We pass 'tp' to IsAbleToHand to check if it can be added to the activator's hand
	local b1=c:IsAbleToHand(tp)
	
	--Check Option 2: Set to Field
	local b2=false
	if c:IsType(TYPE_MONSTER) then
		--Monster: Special Summon Face-down
		b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	elseif c:IsType(TYPE_SPELL+TYPE_TRAP) then
		--Spell/Trap: SSet
		--IsSSetable(true) allows setting from outside the hand (e.g. Deck/GY/Opponent Hand if applicable)
		b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsSSetable()
	end
	
	return b1 or b2
end

function s.handop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	--Must confirm hand first to verify presence/absence
	if #hg>0 then
		Duel.ConfirmCards(tp,hg)
	end
	
	--Find all cards with the declared name
	local g=hg:Filter(Card.IsCode,nil,ac)
	
	--FIX: Filter 'g' to only include cards that can ACTUALLY be processed
	local sg=g:Filter(s.opfilter,nil,e,tp)
	
	if #sg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		--Select from the valid group 'sg', not the raw group 'g'
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		
		--Re-evaluate conditions for the SPECIFIC selected card to determine options
		local b1=tc:IsAbleToHand(tp)
		local b2=false
		if tc:IsType(TYPE_MONSTER) then
			b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
				and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
		elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsSSetable()
		end
		
		local op=0
		if b1 and b2 then
			--If both are possible, let player choose
			op=Duel.SelectOption(tp,1190,1153)
		elseif b1 then
			op=0 --Add to Hand only
		elseif b2 then
			op=1 --Set only
		else
			--Should not happen due to 'sg' filter, but safe fallback
			op=-1 
		end
		
		if op==0 then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		elseif op==1 then
			if tc:IsType(TYPE_MONSTER) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SSet(tp,tc,tp,true)
			end
		end
	end
	
	Duel.ShuffleHand(1-tp)
end