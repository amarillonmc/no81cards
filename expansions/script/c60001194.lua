--天烛灵之梦 夏尔
function c60001194.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,60001194+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60001194.hspcon)
	e1:SetOperation(c60001194.hspop)
	c:RegisterEffect(e1) 
	--summon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SUMMON) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_HAND) 
	e2:SetCountLimit(1,10001194)
	e2:SetCost(c60001194.smcost) 
	e2:SetTarget(c60001194.smtg) 
	e2:SetOperation(c60001194.smop) 
	c:RegisterEffect(e2) 
	--to grave and to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_CHAINING) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,20001194)
	e3:SetCondition(c60001194.tghcon) 
	e3:SetTarget(c60001194.tghtg)
	e3:SetOperation(c60001194.tghop)
	c:RegisterEffect(e3)
	if not c60001194.global_check then
		c60001194.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c60001194.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c60001194.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
	if tc:IsSetCard(0x6a5) then 
	Duel.RegisterFlagEffect(tc:GetSummonPlayer(),60001194,RESET_PHASE+PHASE_END,0,1) 
	end 
	tc=eg:GetNext()
	end
end
function c60001194.rlfil(c) 
	return c:IsReleasable() and c:IsSetCard(0x6a5) 
end 
function c60001194.rlgck(g,tp) 
	return Duel.GetMZoneCount(tp,g)>0   
end 
function c60001194.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c60001194.rlfil,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c60001194.rlgck,3,3,tp) and Duel.GetFlagEffect(tp,60001194)>=3 
end
function c60001194.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c60001194.rlfil,tp,LOCATION_ONFIELD,0,nil)
	local sg=g:SelectSubGroup(tp,c60001194.rlgck,false,3,3,tp)
	Duel.Release(sg,REASON_COST) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c:GetBaseAttack()*10)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(c:GetBaseDefense()*10)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e2)
	--disable summon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCode(EVENT_SUMMON) 
	e2:SetCountLimit(1) 
	e2:SetCondition(c60001194.disscon) 
	e2:SetTarget(c60001194.disstg)
	e2:SetOperation(c60001194.dissop)
	e2:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e2)
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
end
function c60001194.disscon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetCurrentChain()==0
end 
function c60001194.disstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c60001194.dissop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end 
function c60001194.sctfil(c) 
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x6a5) and c:IsType(TYPE_SPELL+TYPE_TRAP)  
end 
function c60001194.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c60001194.sctfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())  
	local sc=Duel.SelectMatchingCard(tp,c60001194.sctfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	if sc:IsCode(60001198) then 
	e:SetLabel(1) 
	else e:SetLabel(0) end 
	Duel.SendtoGrave(sc,REASON_COST) 
end   
function c60001194.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonable(true,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end 
function c60001194.sthfil(c) 
	return c:IsAbleToHand() and c:IsCode(60001198)  
end 
function c60001194.smop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.Summon(tp,c,true,nil)
		if e:GetLabel()==1 and Duel.IsExistingMatchingCard(c60001194.sthfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(60001194,0)) then 
		local g=Duel.SelectMatchingCard(tp,c60001194.sthfil,tp,LOCATION_GRAVE,0,1,1,nil) 
		Duel.SendtoHand(g,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,g) 
		end 
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60001194.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60001194.splimit(e,c)
	return not c:IsSetCard(0x6a5) 
end
function c60001194.tghcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
end 
function c60001194.tgfil(c,e,tp) 
	return c:IsAbleToGrave() and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x6a5) and Duel.IsExistingMatchingCard(c60001194.thfil,tp,LOCATION_GRAVE,0,1,nil,c)
end 
function c60001194.thfil(c,sc) 
	return c:IsAbleToHand() and c:IsSetCard(0x6a5) and not c:IsCode(sc:GetCode()) 
end 
function c60001194.tghtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60001194.tgfil,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND) 
end
function c60001194.tghop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c60001194.tgfil,tp,LOCATION_ONFIELD,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sc=g:Select(tp,1,1,nil):GetFirst() 
		if Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c60001194.thfil,tp,LOCATION_GRAVE,0,1,nil,sc) then 
		local sg=Duel.SelectMatchingCard(tp,c60001194.thfil,tp,LOCATION_GRAVE,0,1,1,nil,sc)
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		if Duel.GetFlagEffect(tp,60001194)>=3 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT) 
		e1:SetTargetRange(LOCATION_MZONE,0) 
		e1:SetTarget(function(e,c) 
		return c:IsLevel(1) end)
		e1:SetValue(function(e,te) 
		return te:GetOwnerPlayer()~=e:GetOwnerPlayer() end) 
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		end 
		end 
	end 
end 




