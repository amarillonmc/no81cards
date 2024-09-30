--天灯裁决者 明赫格斯
function c60001195.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,60001195+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60001195.hspcon)
	e1:SetOperation(c60001195.hspop)
	c:RegisterEffect(e1)	 
	--to hand 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,10001195) 
	e2:SetTarget(c60001195.thtg) 
	e2:SetOperation(c60001195.thop) 
	c:RegisterEffect(e2) 
	--set 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_RELEASE) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,20001195) 
	e3:SetTarget(c60001195.settg) 
	e3:SetOperation(c60001195.setop) 
	c:RegisterEffect(e3) 
	if not c60001195.global_check then
		c60001195.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c60001195.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c60001195.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
	if tc:IsSetCard(0x3622) then 
	Duel.RegisterFlagEffect(tc:GetSummonPlayer(),60001195,RESET_PHASE+PHASE_END,0,1) 
	end 
	tc=eg:GetNext()
	end
end
function c60001195.rlfil(c) 
	return c:IsReleasable() and c:IsSetCard(0x3622) 
end 
function c60001195.rlgck(g,tp) 
	return Duel.GetMZoneCount(tp,g)>0   
end 
function c60001195.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c60001195.rlfil,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c60001195.rlgck,3,3,tp) and Duel.GetFlagEffect(tp,60001195)>=3 
end
function c60001195.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c60001195.rlfil,tp,LOCATION_ONFIELD,0,nil)
	local sg=g:SelectSubGroup(tp,c60001195.rlgck,false,3,3,tp)
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
	local dg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil) 
	Duel.SendtoGrave(dg,REASON_EFFECT) 
end 
function c60001195.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3622)  
end 
function c60001195.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60001195.thfil,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c60001195.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c60001195.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil)  
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5795882,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLevel,1))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60001195.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60001195.splimit(e,c)
	return not c:IsSetCard(0x3622) 
end 
function c60001195.setfil(c) 
	return c:IsSSetable() and c:IsType(TYPE_TRAP) and c:IsSetCard(0x3622) 
end 
function c60001195.settg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c60001195.setfil,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end 
function c60001195.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c60001195.setfil,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		if Duel.SSet(tp,tc)~=0 and Duel.GetFlagEffect(tp,60001195)>=3 and Duel.IsExistingMatchingCard(c60001195.setfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(60001195,1)) then 
		Duel.BreakEffect() 
		local sc=Duel.SelectMatchingCard(tp,c60001195.setfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
		Duel.SSet(tp,sc) 
		end 
	end 
end 



