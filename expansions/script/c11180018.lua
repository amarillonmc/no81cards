-- 龙裔幻殇速攻魔法
local s, id = GetID()

function s.initial_effect(c)
	-- Quick-Play Spell type   
	-- ①: Choose 1 of 2 effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+100)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
end

-- Effect selection target
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if #g<1 or Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))==0 then
	e:SetLabel(0)
	else 
	e:SetLabel(1)
	end
end

-- Effect operation
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	
	-- Effect 1: Declare card name and make effects cannot be negated
	if op==0 then
		-- Get list of valid cards to declare
	getmetatable(c).announce_filter={0x3450,OPCODE_ISSETCARD,0x6450,OPCODE_ISSETCARD,OPCODE_OR}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(c).announce_filter))
		
		
		-- Create effect that prevents negation
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DISEFFECT)
		e1:SetValue(s.efilter)
		e1:SetLabel(ac)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		
	-- Effect 2: Special Summon from GY or banish
	else
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end

-- Filter for Effect 1
function s.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler():IsCode(e:GetLabel())
end

-- Filter for Effect 2
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x3450) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
