--爆苍联合 猎豹
local s, id = GetID()
s.named_with_RoaringAzure=1
function s.RoaringAzure(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_RoaringAzure
end

function s.initial_effect(c)

	aux.AddSynchroProcedure(c,s.sfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.sccon)
	e2:SetTarget(s.sctg)
	e2:SetOperation(s.scop)
	c:RegisterEffect(e2)
end
function s.sfilter(c)
	return s.RoaringAzure(c)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.thfilter(c)
	return s.RoaringAzure(c) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then

		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,2,tp,2)

	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_SZONE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)

	local sg=g:Select(tp,1,1,nil)
	local tc1=sg:GetFirst()

	g:Remove(Card.IsCode,nil,tc1:GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg2=g:Select(tp,1,1,nil)
	sg:Merge(sg2)
	
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,2,2,nil)
		if dg:GetCount()>0 then

			if Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)>0 then

				local og=Duel.GetOperatedGroup()
				if og:IsExists(s.RoaringAzure,1,nil) then

					local desg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_SZONE,nil)
					if desg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
						local destc=desg:Select(tp,1,1,nil)
						Duel.HintSelection(destc)
						Duel.Destroy(destc,REASON_EFFECT)
					end
				end
			end
		end
	end
end

function s.sccon(e,tp,eg,ep,ev,re,r,rp)

	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.GetTurnPlayer()==tp)
		or (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==1-tp
end

function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,c):GetFirst()
	if tc then Duel.SynchroSummon(tp,tc,c) end
end
