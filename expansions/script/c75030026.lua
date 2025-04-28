--晓之侠盗 萨拉
function c75030026.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PYRO),4,2)
	c:EnableReviveLimit()   
	--xxx 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,75030026) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end) 
	e1:SetTarget(c75030026.xxxtg)
	e1:SetOperation(c75030026.xxxop) 
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,15030026+EFFECT_COUNT_CODE_DUEL) 
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFlagEffect(tp,75030026)>=6 end)
	e2:SetTarget(c75030026.xxtg) 
	e2:SetOperation(c75030026.xxop) 
	c:RegisterEffect(e2) 
	if not c75030026.global_check then
		c75030026.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c75030026.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end 
c75030026.toss_coin=true
function c75030026.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker() 
	if tc:IsSetCard(0x5751) then 
		Duel.RegisterFlagEffect(tc:GetControler(),75030026,0,0,1) 
	end
end
function c75030026.xxxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=(Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_STANDBY) and Duel.IsAbleToEnterBP()  
	local b2=(Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsRace(RACE_PYRO) end,tp,LOCATION_MZONE,0,1,nil) 
	local b3=(Duel.GetCurrentPhase()==PHASE_MAIN2 or Duel.GetCurrentPhase()==PHASE_END) and Duel.IsPlayerCanDraw(tp,2) 
	if chk==0 then return (b1 or b2 or b3) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,2,nil) end   
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_ONFIELD)
	if b3 then 
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end 
end 
function c75030026.xxxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local b1=(Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_STANDBY) and Duel.IsAbleToEnterBP()  
	local b2=(Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsRace(RACE_PYRO) end,tp,LOCATION_MZONE,0,1,nil) 
	local b3=(Duel.GetCurrentPhase()==PHASE_MAIN2 or Duel.GetCurrentPhase()==PHASE_END) and Duel.IsPlayerCanDraw(tp,2) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,nil) 
	if g:GetCount()>=2 then 
		local sg=g:Select(tp,2,2,nil) 
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then 
			local p=Duel.GetTurnPlayer() 
			if b1 then 
				Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_FIELD) 
				e1:SetCode(EFFECT_CANNOT_EP) 
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
				e1:SetTargetRange(1,0) 
				e1:SetReset(RESET_PHASE+PHASE_BATTLE) 
				Duel.RegisterEffect(e1,tp)	
			elseif b2 then 
				local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsRace(RACE_PYRO) end,tp,LOCATION_MZONE,0,nil) 
				local tc=g:GetFirst() 
				while tc do 
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_UPDATE_ATTACK) 
				e1:SetRange(LOCATION_MZONE) 
				e1:SetValue(700) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
				tc:RegisterEffect(e1) 
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
				e1:SetRange(LOCATION_MZONE) 
				e1:SetValue(1) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
				tc:RegisterEffect(e1) 
				tc=g:GetNext() 
				end 
			elseif b3 then 
				Duel.Draw(tp,2,REASON_EFFECT)
			end 
		end 
	end 
end 
function c75030026.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end   
	Duel.SetChainLimit(aux.FALSE) 
end 
function c75030026.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(75030026,1))
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(75030026) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0) 
	Duel.RegisterEffect(e1,tp) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_BATTLE_START) 
	e1:SetCondition(c75030026.bxxcon) 
	e1:SetOperation(c75030026.bxxop) 
	Duel.RegisterEffect(e1,tp) 
end 
function c75030026.bxxcon(e,tp,eg,ep,ev,re,r,rp)
	local a,b=Duel.GetBattleMonster(tp) 
	return a and b and a:IsSetCard(0x5751)
end
function c75030026.bxxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local a,b=Duel.GetBattleMonster(tp) 
	local x1,x2=Duel.TossCoin(tp,2) 
	if x1+x2==2 then 
		Duel.Remove(b,POS_FACEDOWN,REASON_EFFECT) 
	end 
end 


