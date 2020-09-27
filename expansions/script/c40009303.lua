--时隙淑女 阿尔甘
function c40009303.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009303,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c40009303.discon)
	e1:SetCost(c40009303.discost)
	e1:SetTarget(c40009303.distg)
	e1:SetOperation(c40009303.disop)
	c:RegisterEffect(e1)	
	--search 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009303,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,40009303)
	e2:SetCondition(c40009303.thcon)
	e2:SetTarget(c40009303.thtg)
	e2:SetOperation(c40009303.thop)
	c:RegisterEffect(e2)
end
function c40009303.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_TOGRAVE) and Duel.IsChainNegatable(ev)
end
function c40009303.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	e:SetLabel(100)
	if chk==0 then return c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function c40009303.cfilter(c)
	return c:IsSetCard(0x4f1d) and c:IsType(TYPE_MONSTER) and not c:IsPublic() 
end
function c40009303.gfilter(g,e,tp,c)
	return g:IsContains(c) and Duel.IsExistingMatchingCard(c40009303.scfilter,tp,LOCATION_EXTRA,0,1,nil,tp,g)
end
function c40009303.scfilter(c,tp,mg)
	return c:IsSynchroSummonable(nil,mg,#mg-1,#mg-1) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c40009303.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c40009303.cfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return e:GetLabel()==100 and g:IsContains(c) and g:CheckSubGroup(c40009303.gfilter,1,4,e,tp,c) and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_SYNCHRO_MATERIAL,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:SelectSubGroup(tp,c40009303.gfilter,false,1,4,e,tp,c)
	Duel.ConfirmCards(1-tp,cg)
	Duel.SetTargetCard(cg)
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)	
end
function c40009303.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #g~=g:FilterCount(Card.IsRelateToEffect,nil,e) then return end
	if Duel.SpecialSummon(c,SUMMON_VALUE_SYNCHRO_MATERIAL,tp,tp,false,false,POS_FACEUP)<=0 then return end
	local sg=Duel.GetMatchingGroup(c40009303.scfilter,tp,LOCATION_EXTRA,0,nil,tp,g)
	if #sg>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.SynchroSummon(tp,sc,nil,g,#g-1,#g-1)
	end
end
function c40009303.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
--function c40009303.thfilter(c)
	--return c:IsSetCard(0x4f1d) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
--end
function c40009303.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c40009303.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

