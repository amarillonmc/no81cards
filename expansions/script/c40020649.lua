--鸟兽气兵 琉璃鸟
local s, id = GetID()
s.named_with_ForceFighter=1
function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end
function s.initial_effect(c)

	aux.EnablePendulumAttribute(c)
 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.indtg)
	e1:SetValue(s.indct)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_DECKDES) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.sccon)
	e2:SetTarget(s.sctg)
	e2:SetOperation(s.scop)
	c:RegisterEffect(e2)
end


function s.indtg(e,c)
	return  s.ForceFighter(c)
end

function s.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end

function s.sccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	local ph=Duel.GetCurrentPhase()
	local b1 = (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.GetTurnPlayer()==tp)
	local b2 = ((ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==1-tp)
	if not (b1 or b2) then return false end
	

	if c:IsLocation(LOCATION_HAND) then
		return true
	elseif c:IsLocation(LOCATION_EXTRA) then

		return c:IsFaceup() and (
			Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,nil,40020585) or
			Duel.IsExistingMatchingCard(aux.FilterBoolFunction(Card.IsCode,40020585),tp,LOCATION_EXTRA,0,1,nil)
		)
	end
	return false
end

function s.mfilter(c)
	return s.ForceFighter(c) and c:IsFaceup() and c:GetLevel()>0
end

function s.synchk(c,tc,tp,sc_card)
	return sc_card:GetLevel() == c:GetLevel() + tc:GetLevel()
		and s.ForceFighter(sc_card)
		and sc_card:IsSynchroSummonable(nil, Group.FromCards(c,tc))
end

function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.mfilter(chkc) end
	if chk==0 then

		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
			or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end

		local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil)

		for tc in aux.Next(mg) do

			if Duel.IsExistingMatchingCard(s.synchk,tp,LOCATION_EXTRA,0,1,nil,c,tc,tp) then
				return true
			end
		end
		return false
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g=Duel.SelectTarget(tp,s.mfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	
	if c:IsLocation(LOCATION_EXTRA) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end

function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
			local mg=Group.FromCards(c,tc)

			local sc_g=Duel.GetMatchingGroup(s.synchk,tp,LOCATION_EXTRA,0,nil,c,tc,tp)
			
			if sc_g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sc=sc_g:Select(tp,1,1,nil):GetFirst()

				if e:GetLabel()==1 then
					for mat in aux.Next(mg) do
						local e_redirect=Effect.CreateEffect(c)
						e_redirect:SetType(EFFECT_TYPE_SINGLE)
						e_redirect:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
						e_redirect:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
						e_redirect:SetValue(LOCATION_DECK)
						e_redirect:SetReset(RESET_EVENT+RESETS_STANDARD)
						mat:RegisterEffect(e_redirect,true)
					end
				end
				
				Duel.SynchroSummon(tp,sc,nil,mg)
			end
		end
	end
end
