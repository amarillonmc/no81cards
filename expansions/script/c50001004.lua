--星空闪耀 s.i.n
function c50001004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,50001004+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c50001004.actg) 
	e1:SetOperation(c50001004.acop) 
	c:RegisterEffect(e1)  
end
c50001004.SetCard_WK_StarS=true 
function c50001004.tgstfil(c,e,tp) 
	if not (c:GetSequence()<4 and c:IsAbleToGrave()) then return false end  
	if c:IsType(TYPE_MONSTER) then 
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	else 
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsSSetable(true)
	end 
end 
function c50001004.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsSetCard(0x99a) end,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c50001004.tgstfil,tp,0,LOCATION_SZONE,1,nil,e,tp) end 
	local tc1=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsSetCard(0x99a) end,tp,LOCATION_MZONE,0,1,1,nil) 
	local tc2=Duel.SelectTarget(tp,c50001004.tgstfil,tp,0,LOCATION_SZONE,1,1,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc2,1,0,0) 
end 
function c50001004.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 then 
		local tc2=g:Filter(Card.IsControler,nil,1-tp):GetFirst() 
		if tc2 and Duel.SendtoGrave(tc2,REASON_EFFECT)~=0 then 
			if tc2:IsType(TYPE_MONSTER) then 
				Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc2)
			else 
				Duel.SSet(tp,tc2)
			end 
		end 
		local tc1=g:Filter(Card.IsControler,nil,tp):GetFirst()  
		if tc1 then 
			Duel.BreakEffect() 
			--pos 
			local e1=Effect.CreateEffect(c) 
			e1:SetDescription(aux.Stringid(50001004,1))
			e1:SetCategory(CATEGORY_POSITION)
			e1:SetType(EFFECT_TYPE_QUICK_O) 
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)  
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetTarget(c50001004.postg)
			e1:SetOperation(c50001004.posop)
			tc1:RegisterEffect(e1)
		end  
	end 
end 
function c50001004.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCanTurnSet() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,LOCATION_MZONE)
end 
function c50001004.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCanTurnSet() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then 
		local tc=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsCanTurnSet() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst() 
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end








