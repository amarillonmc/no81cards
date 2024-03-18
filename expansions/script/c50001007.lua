--星空闪耀 时之虫
function c50001007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,50001007+EFFECT_COUNT_CODE_OATH)  
	e1:SetCost(c50001007.accost) 
	e1:SetTarget(c50001007.actg) 
	e1:SetOperation(c50001007.acop) 
	c:RegisterEffect(e1)  
end
c50001007.SetCard_WK_StarS=true  
function c50001007.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return not c:IsPublic() and c:IsSetCard(0x99a) end,tp,LOCATION_HAND,0,1,e:GetHandler()) end 
	local tc=Duel.SelectMatchingCard(tp,function(c) return not c:IsPublic() and c:IsSetCard(0x99a) end,tp,LOCATION_HAND,0,1,1,e:GetHandler()):GetFirst() 
	e:SetLabelObject(tc) 
	Duel.ConfirmCards(1-tp,tc) 
	Duel.ShuffleHand(tp) 
end  
function c50001007.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.SetCard_WK_StarS  
end 
function c50001007.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50001007.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c50001007.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local sc=e:GetLabelObject()
	if sc and sc:IsControler(tp) and sc:IsLocation(LOCATION_HAND) and Duel.SendtoHand(sc,1-tp,REASON_EFFECT)~=0 then 
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		sc:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(c50001007.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then   
		local tc=Duel.SelectMatchingCard(tp,c50001007.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst() 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
		--damage  
		local e1=Effect.CreateEffect(c) 
		e1:SetDescription(aux.Stringid(50001007,1))
		e1:SetCategory(CATEGORY_DAMAGE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
		e1:SetCode(EVENT_PHASE+PHASE_END) 
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)  
		e1:SetLabelObject(sc) 
		e1:SetCondition(c50001007.damcon)
		e1:SetTarget(c50001007.damtg)
		e1:SetOperation(c50001007.damop)
		tc:RegisterEffect(e1) 
		end 
	end 
end 
function c50001007.damcon(e,tp,eg,ep,ev,re,r,rp) 
	local tc=e:GetLabelObject()
	return tc and tc:IsPublic() and tc:IsLocation(LOCATION_HAND) and tc:IsControler(1-tp) 
end  
function c50001007.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end 
function c50001007.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT) 
end








