--假面骑士 空我/天马形态
local s,id=GetID()

s.named_with_Kuuga=1
function s.Kuuga(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Kuuga
end

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp_turn=Duel.GetTurnPlayer()==tp 
	
	local is_my_main = tp_turn and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
	
	local is_battle = (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	
	return is_my_main or is_battle
end

function s.hand_kuuga_filter(c)
	return s.Kuuga(c) and c:IsDiscardable(REASON_EFFECT)
end

function s.field_kuuga_filter(c,tp)
	return s.Kuuga(c) and c:IsFaceup() and c:IsAbleToHand() 
		and Duel.GetMZoneCount(tp,c)>0 
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local b1=c:IsDiscardable(REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,c)
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(s.field_kuuga_filter,tp,LOCATION_MZONE,0,1,nil,tp)
	
	if chk==0 then return #g>0 and (b1 or b2) end
	
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)

	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,2,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)

end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return end
	
	local min_atk=g:GetMinGroup(Card.GetAttack)
	if #min_atk>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=min_atk:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.Destroy(sg,REASON_EFFECT)>0 then
			if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_HAND) then return end
			
			local b1=c:IsDiscardable(REASON_EFFECT) 
				and Duel.IsExistingMatchingCard(s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,c)
			local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
				and Duel.IsExistingMatchingCard(s.field_kuuga_filter,tp,LOCATION_MZONE,0,1,nil,tp)
			
			local op=0
			if b1 and b2 then
				op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
			elseif b1 then
				op=0
			elseif b2 then
				op=1
			else
				return
			end
			
			if op==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
				local g_other=Duel.SelectMatchingCard(tp,s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,1,c)
				if #g_other>0 then
					g_other:AddCard(c)
					Duel.BreakEffect()
					Duel.SendtoGrave(g_other,REASON_EFFECT+REASON_DISCARD)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local bg=Duel.SelectMatchingCard(tp,s.field_kuuga_filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
				if #bg>0 then
					Duel.BreakEffect()
					if Duel.SendtoHand(bg,nil,REASON_EFFECT)>0 then
						Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
					end
				end
			end
		end
	end
end

function s.thfilter(c)
	return s.Kuuga(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end