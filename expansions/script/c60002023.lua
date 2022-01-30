--时光酒桌 刹那
function c60002023.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60002023,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60002023+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60002023.accon)
	e1:SetCost(c60002023.accost)
	e1:SetTarget(c60002023.actg)
	e1:SetOperation(c60002023.acop)
	c:RegisterEffect(e1)   
	--xx
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60002023,2))
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCost(c60002023.xxcost)
	e2:SetTarget(c60002023.xxtg)
	e2:SetOperation(c60002023.xxop)
	c:RegisterEffect(e2)  
	if not c60002023.global_check then
		c60002023.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(c60002023.checkcon)
		ge1:SetOperation(c60002023.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c60002023.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	return rc:IsType(TYPE_TRAP) and rc:IsType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c60002023.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=re:GetHandlerPlayer()
	Duel.RegisterFlagEffect(p,60002023,RESET_PHASE+PHASE_END,0,1) 
end
function c60002023.accon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c60002023.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60002023.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,99,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c60002023.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetLabel()
	if chk==0 then return true end 
	if Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil):GetCount()>=3 then 
	Duel.SetChainLimit(c60002023.chlimit)
	end
end
function c60002023.chlimit(e,ep,tp)
	return tp==ep
end
function c60002023.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetLabel()
	if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,x,nil) then 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,x,x,nil)   
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c60002023.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if x>=2 and Duel.IsPlayerCanDraw(tp,1) then 
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	if x>=4 then 
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	end
	end
end
function c60002023.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c60002023.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c60002023.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c60002023.thfil(c)
	return c:IsAbleToHand() and (c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER))
end
function c60002023.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.GetFlagEffect(tp,60002023) 
	if x>=0 then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60002023.xsplimit)
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c60002023.xactlimit)
	e4:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e4,tp)  
	end
	if x>=3 and Duel.IsExistingMatchingCard(c60002023.thfil,tp,LOCATION_GRAVE,0,1,nil) then 
	local sg=Duel.SelectMatchingCard(tp,c60002023.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	end
	if x>=5 then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x629))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetValue(c60002023.dxefil)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	end
end
function c60002023.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler():IsControler(e:GetOwnerPlayer()) and te:GetHandler():IsSetCard(0x629)
end
function c60002023.gctfil(c)
	return c:IsAbleToGraveAsCost() and c:IsFacedown() 
end
function c60002023.gtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60002023.gctfil,tp,LOCATION_ONFIELD,0,3,e:GetHandler()) end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c60002023.gctfil,tp,LOCATION_ONFIELD,0,3,3,e:GetHandler()) 
	Duel.SendtoGrave(g,REASON_COST)
end
function c60002023.rmfil(c)
	return c:IsSetCard(0x629) and c:IsAbleToRemove()
end
function c60002023.gttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60002023.rmfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)  end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then 
	Duel.SetChainLimit(c60002023.chainlm) 
	end
end
function c60002023.chainlm(e,rp,tp)
	return e:GetHandler():IsType(TYPE_COUNTER)
end
function c60002023.gtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	--
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c60002023.immval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
	local g=Duel.SelectMatchingCard(tp,c60002023.rmfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	end
end
function c60002023.immval(e,te)
	return ((te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsSummonLocation(LOCATION_EXTRA)) or te:IsActiveType(TYPE_TRAP)) and te:GetHandlerPlayer()~=tp
end
function c60002023.xsplimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c60002023.xactlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0x629)
end




