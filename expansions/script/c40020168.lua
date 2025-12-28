--假面骑士 空我/惊异全能
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
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
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


function s.desfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(2000)
end


function s.hand_kuuga_filter(c)
	return s.Kuuga(c) and c:IsDiscardable(REASON_EFFECT)
end


function s.field_kuuga_lv7_filter(c,tp)
	return s.Kuuga(c) and c:IsFaceup() and c:IsLevelAbove(7) and c:IsAbleToHand() 
		and Duel.GetMZoneCount(tp,c)>0 
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	
	local b1=c:IsDiscardable(REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,c)
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(s.field_kuuga_lv7_filter,tp,LOCATION_MZONE,0,1,nil,tp)
		
	if chk==0 then return #g>0 and (b1 or b2) end
	
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,2,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)

end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
	
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		
		if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_HAND) then return end
		
		local b1=c:IsDiscardable(REASON_EFFECT) 
			and Duel.IsExistingMatchingCard(s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,c)
		local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
			and Duel.IsExistingMatchingCard(s.field_kuuga_lv7_filter,tp,LOCATION_MZONE,0,1,nil,tp)
			
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
		elseif b1 then op=0
		elseif b2 then op=1
		else return end
		
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local dg=Duel.SelectMatchingCard(tp,s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,1,c)
			if #dg>0 then
				dg:AddCard(c)
				Duel.BreakEffect()
				Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local bg=Duel.SelectMatchingCard(tp,s.field_kuuga_lv7_filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
			if #bg>0 then
				Duel.BreakEffect()
				if Duel.SendtoHand(bg,nil,REASON_EFFECT)>0 then
					Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end

function s.thfilter(c)
	return s.Kuuga(c) and c:IsAbleToHand() and c:GetCode()~=id
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end