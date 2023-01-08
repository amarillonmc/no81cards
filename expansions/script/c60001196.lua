--天烛灵之梦 卢娜思
function c60001196.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,60001196+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60001196.hspcon)
	e1:SetOperation(c60001196.hspop)
	c:RegisterEffect(e1)  
	--summon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10001196)
	e2:SetCondition(c60001196.smcon) 
	e2:SetTarget(c60001196.smtg)
	e2:SetOperation(c60001196.smop)
	c:RegisterEffect(e2) 
	--draw 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_RELEASE) 
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET) 
	e3:SetCountLimit(1,20001195) 
	e3:SetTarget(c60001196.drtg) 
	e3:SetOperation(c60001196.drop) 
	c:RegisterEffect(e3) 
	if not c60001196.global_check then
		c60001196.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c60001196.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c60001196.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
	if tc:IsSetCard(0x6a5) then 
	Duel.RegisterFlagEffect(tc:GetSummonPlayer(),60001196,RESET_PHASE+PHASE_END,0,1) 
	end 
	tc=eg:GetNext()
	end
end
function c60001196.rlfil(c) 
	return c:IsReleasable() and c:IsSetCard(0x6a5) 
end 
function c60001196.rlgck(g,tp) 
	return Duel.GetMZoneCount(tp,g)>0   
end 
function c60001196.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c60001196.rlfil,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c60001196.rlgck,3,3,tp) and Duel.GetFlagEffect(tp,60001196)>=3 
end
function c60001196.xthfil(c) 
	return c:IsSetCard(0x6a5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end 
function c60001196.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c60001196.rlfil,tp,LOCATION_ONFIELD,0,nil)
	local sg=g:SelectSubGroup(tp,c60001196.rlgck,false,3,3,tp)
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
	local xg=Duel.GetMatchingGroup(c60001196.xthfil,tp,LOCATION_DECK,0,nil)  
	if xg:GetCount()>0 then 
	local dg=xg:Select(tp,1,1,nil) 
	Duel.SendtoHand(dg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,dg) 
	end 
end 
function c60001196.smcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp  
end
function c60001196.smtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsSummonable(true,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end 
function c60001196.stgfil(c) 
	return c:IsAbleToGrave() and c:IsSetCard(0x6a5) 
end 
function c60001196.smop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.Summon(tp,c,true,nil)
		if Duel.IsExistingMatchingCard(c60001196.stgfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(60001196,1)) then 
		Duel.BreakEffect() 
		local sg=Duel.SelectMatchingCard(tp,c60001196.stgfil,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.SendtoGrave(sg,REASON_EFFECT) 
		end 
	end 
end 
function c60001196.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(1) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end 
function c60001196.drop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT) 
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if Duel.GetFlagEffect(tp,60001196)>=3 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60001196,2)) then 
	Duel.ConfirmCards(tp,g) 
	end 
end 





