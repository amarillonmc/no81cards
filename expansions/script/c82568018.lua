--AKR-北极星麦哲伦
function c82568018.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	  --plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c82568018.pcon)
	e2:SetTarget(c82568018.splimit)
	c:RegisterEffect(e2)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,82568018)
	e1:SetCost(c82568018.dwcost)
	e1:SetTarget(c82568018.dwtarget)
	e1:SetOperation(c82568018.dwop)
	c:RegisterEffect(e1)
	--token Summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82568018,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,82568118)
	e6:SetTarget(c82568018.sptg)
	e6:SetCost(c82568018.spcost)
	e6:SetOperation(c82568018.spop)
	c:RegisterEffect(e6)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82568018,1))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,82569118)
	e4:SetTarget(c82568018.target)
	e4:SetOperation(c82568018.operation)
	c:RegisterEffect(e4)
end
function c82568018.splimit(e,c,tp,sumtp,sumpos,re)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end
function c82568018.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0 
end
function c82568018.dwcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetTurnPlayer()==tp
	end
	local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,g2)
end
function c82568018.dwtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c82568018.dwop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g3=g2:Select(tp,1,1,nil)
	Duel.SendtoDeck(g3,nil,1,REASON_EFFECT)
end
function c82568018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82568019,0,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c82568018.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,82568019,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,82568019)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c82568018.ltfilter1(c)
	return c:IsFaceup() and c:IsCode(82568019)
end
function c82568018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ltg=Duel.GetMatchingGroup(c82568018.ltfilter1,tp,LOCATION_MZONE,0,nil)
	local ltgc=ltg:GetCount()
	if chk==0 then return ltgc>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ltgc*700)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,nil,1-tp,ltgc*700)
end
function c82568018.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local ltg=Duel.GetMatchingGroup(c82568018.ltfilter1,tp,LOCATION_MZONE,0,nil)
	local lt=ltg:GetFirst()
	while lt do
	local  e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetTargetRange(0,LOCATION_SZONE)
			e4:SetTarget(c82568018.distg)
			e4:SetReset(RESET_PHASE+PHASE_END)
			e4:SetLabel(lt:GetSequence())
			Duel.RegisterEffect(e4,tp)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_CHAIN_SOLVING)
			e5:SetOperation(c82568018.disop)
			e5:SetReset(RESET_PHASE+PHASE_END)
			e5:SetLabel(lt:GetSequence())
			Duel.RegisterEffect(e5,tp)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD)
			e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e6:SetTarget(c82568018.distg)
			e6:SetReset(RESET_PHASE+PHASE_END)
			e6:SetLabel(lt:GetSequence())
			Duel.RegisterEffect(e6,tp)
	 lt=ltg:GetNext()
	 end	 
end
function c82568018.distg(e,c)
	local seq=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.GetColumn(c,tp)==seq
end
function c82568018.disop(e,tp,eg,ep,ev,re,r,rp)
	local tseq=e:GetLabel()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_SZONE~=0 and seq<=4 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) then
		Duel.NegateEffect(ev)
	end
end