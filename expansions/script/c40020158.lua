--假面骑士 空我/泰坦形态
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
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)


	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetValue(300)
	c:RegisterEffect(e2)


	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
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

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) end
	local c=e:GetHandler()
	
	local b1=c:IsDiscardable(REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,c)
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(s.field_kuuga_filter,tp,LOCATION_MZONE,0,1,nil,tp)
		
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_SZONE,1,nil) and (b1 or b2) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,2,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)

end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	if tc and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_HAND) then return end
			
			local b1=c:IsDiscardable(REASON_EFFECT) 
				and Duel.IsExistingMatchingCard(s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,c)
			local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
				and Duel.IsExistingMatchingCard(s.field_kuuga_filter,tp,LOCATION_MZONE,0,1,nil,tp)
				
			local op=0
			if b1 and b2 then
				op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
			elseif b1 then op=0
			elseif b2 then op=1
			else return end
			
			if op==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
				local g=Duel.SelectMatchingCard(tp,s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,1,c)
				if #g>0 then
					g:AddCard(c)
					Duel.BreakEffect()
					Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
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

function s.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and Duel.GetAttacker()==c
		and Duel.GetAttackTarget()~=nil
end