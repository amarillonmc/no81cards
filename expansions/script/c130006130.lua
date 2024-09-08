--雷光神姬 莱珊巴哈
function c130006130.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c130006130.thcon)  
	e1:SetTarget(c130006130.thtg)
	e1:SetOperation(c130006130.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c130006130.sdop)
	c:RegisterEffect(e3)
	--go back
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_MOVE)
	e5:SetCondition(c130006130.drcon)
	e5:SetTarget(c130006130.drtg)
	e5:SetOperation(c130006130.drop)
	c:RegisterEffect(e5)
	--retrieval
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,130106130)
	e4:SetTarget(c130006130.regtg)
	e4:SetOperation(c130006130.regop)
	c:RegisterEffect(e4)
	if not c130006130.global_check then
		c130006130.global_check=true
		c130006130[0]={}
		c130006130[1]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c130006130.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(c130006130.regop2)
		Duel.RegisterEffect(ge2,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge4:SetOperation(c130006130.clearop)
		Duel.RegisterEffect(ge4,0)
	end
end
function c130006130.spfilter(c,sp)  
	return c:GetSummonPlayer()==sp 
end  
function c130006130.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c130006130.spfilter,1,nil,1-tp)  
end  
function c130006130.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c130006130.thfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c130006130.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then  
		local ct=Duel.GetMatchingGroupCount(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.ConfirmDecktop(p,3)
		local g=Duel.GetDecktopGroup(p,3)
		if g:GetCount()>0 and g:IsExists(c130006130.thfilter,1,nil) and Duel.SelectYesNo(p,aux.Stringid(130006130,1)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(p,c130006130.thfilter,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,sg)
		Duel.ShuffleHand(p)
		end
	end
	Duel.ShuffleDeck(p)
end
function c130006130.cfilter2(c)
	return c:IsRace(RACE_PSYCHO) and c:IsFaceup()
end
function c130006130.sdop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local sdg=Duel.GetMatchingGroup(c130006130.cfilter2,tp,LOCATION_MZONE,0,c)
	if #sdg<=0 and Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 and c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT) then
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(130006130,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(130006130,0))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetOperation(c130006130.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c130006130.retop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local sdg=Duel.GetMatchingGroup(c130006130.cfilter2,tp,LOCATION_MZONE,0,nil)
	if #sdg<=0 then return end
	local c=e:GetLabelObject()
	local flag=c:GetFlagEffectLabel(130006130)
	if not flag or e:GetLabel()~=c:GetFieldID() then
		e:Reset()
	else
		c:ResetFlagEffect(130006130)
		Duel.ReturnToField(c)
		e:Reset()
	end
end
function c130006130.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function c130006130.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c130006130.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c130006130.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c130006130.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_PSYCHO) then
		local rc=re:GetHandler():GetCode()
		if c130006130[rp][rc] then c130006130[rp][rc]=c130006130[rp][rc]+1 else c130006130[rp][rc]=1 end
	end
end
function c130006130.regop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler():GetCode()
	if c130006130[rp][rc] then c130006130[rp][rc]=c130006130[rp][rc]-1 else c130006130[rp][rc]=nil end
end
function c130006130.clearop(e,tp,eg,ep,ev,re,r,rp)
	c130006130[0]={}
	c130006130[1]={}
end
function c130006130.spfilter1(c,rp)
	local rc=c:GetCode()
	return c:IsAbleToHand() and not c:IsCode(130006130) and c130006130[rp][rc]
end
function c130006130.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c130006130.spfilter1,tp,LOCATION_DECK,0,1,nil,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c130006130.spfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
		if tg:GetCount()<=0 then return end
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
