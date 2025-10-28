--救世之章？莎娜
function c71500103.initial_effect(c) 
	aux.AddSetNameMonsterList(c,0x78f1)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c71500103.sprcon)
	e1:SetOperation(Auxiliary.SpiritReturnReg)
	c:RegisterEffect(e1)
	--ritual level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(function(e,c)
	local ec=e:GetHandler()
	local lv=aux.GetCappedLevel(ec)
	if not ec:IsLocation(LOCATION_MZONE) then return lv end
	local clv=c:GetLevel()
	return (lv<<16)+clv end)
	c:RegisterEffect(e1)   
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71500103,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCondition(c71500103.chcon)
	e1:SetCost(c71500103.chcost)
	e1:SetTarget(c71500103.chtg)
	e1:SetOperation(c71500103.chop)
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCost(c71500103.spcost)
	e2:SetTarget(c71500103.sptg)
	e2:SetOperation(c71500103.spop)
	c:RegisterEffect(e2) 
end
function c71500103.sprcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsReason(REASON_RITUAL) and e:GetHandler():IsReason(REASON_RELEASE) and e:GetHandler():IsLocation(LOCATION_GRAVE)
end 
function c71500103.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c71500103.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c71500103.chtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil) and g:GetCount()>0 end
end
function c71500103.plfil(c) 
	return not c:IsForbidden()  
end 
function c71500103.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c71500103.repop)
	if Duel.GetLocationCount(tp,LOCATION_SZONE) and Duel.IsExistingMatchingCard(c71500103.plfil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) then 
	local tc=Duel.SelectMatchingCard(tp,c71500103.plfil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil):GetFirst() 
		Duel.BreakEffect()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE) 
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1) 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_COUNTER_PERMIT|0x78f1) 
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetRange(LOCATION_SZONE)  
		tc:RegisterEffect(e1) 
		tc:AddCounter(0x78f1,5)   
	end 
end
function c71500103.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)  
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD) 
	if sg:GetCount()>0 and Duel.SendtoHand(sg,tp,REASON_EFFECT)~=0 and dg:GetCount()>0 then  
		Duel.Destroy(dg,REASON_EFFECT) 
	end 
end
function c71500103.ckfil1(c) 
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) 
end 
function c71500103.ckfil2(c) 
	return not c:IsPublic() and c:IsType(TYPE_RITUAL)
end 
function c71500103.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsExistingMatchingCard(c71500103.ckfil1,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c71500103.ckfil2,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return (b1 or b2) and Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end 
	if not b1 then 
		local pg=Duel.SelectMatchingCard(tp,c71500103.ckfil2,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,pg) 
	end  
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_COST) 
end
function c71500103.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71500103.sthfil(c) 
	return c:IsAbleToHand() and (c:IsSetCard(0x837) or (aux.IsSetNameMonsterListed(c,0x78f1) and c:IsType(TYPE_SPELL+TYPE_TRAP))) 
end 
function c71500103.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true) 
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL) 
		c:RegisterEffect(e2,true)
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL) 
		c:RegisterEffect(e2,true)
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL) 
		c:RegisterEffect(e2,true)
		if Duel.IsCanRemoveCounter(tp,1,1,0x78f1,3,REASON_EFFECT) and Duel.IsExistingMatchingCard(c71500103.sthfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(71500103,0)) then 
			Duel.BreakEffect() 
			Duel.RemoveCounter(tp,1,1,0x78f1,3,REASON_EFFECT)
			local sg=Duel.SelectMatchingCard(tp,c71500103.sthfil,tp,LOCATION_DECK,0,1,1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end 
	end 
end






