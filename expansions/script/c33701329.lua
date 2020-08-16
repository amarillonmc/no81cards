--水晶魔法小妖精 露克西
function c33701329.initial_effect(c)
	--SSet
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCost(c33701329.sscost)
	e1:SetTarget(c33701329.sstg)
	e1:SetOperation(c33701329.ssop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_DECK)
	e1:SetOperation(c33701329.actop)
	c:RegisterEffect(e1)
	if not c33701329.global_check then
		c33701329.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c33701329.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c33701329.checkop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33701329.actop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetDecktopGroup(tp,1):IsContains(e:GetHandler()) then return end 
	if not e:GetHandler():IsFaceup() then return end
	if ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
	Duel.SetChainLimit(c33701329.chainlm)
	end
end
function c33701329.chainlm(e,rp,tp)
	return tp==rp
end
function c33701329.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(re:GetHandler():GetControler(),33701329,RESET_PHASE+PHASE_END,0,1)
end
function c33701329.checkop1(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) then return end
	Duel.RegisterFlagEffect(re:GetHandler():GetControler(),00701329,RESET_PHASE+PHASE_END,0,1)
end
function c33701329.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(03701329)==0 and e:GetHandler():IsAbleToRemove() end
	e:GetHandler():RegisterFlagEffect(03701329,RESET_EVENT+RESET_CHAIN,0,1)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end 
function c33701329.ssfil(c)
	return c:IsSSetable() and ((c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)) or c:GetType()==TYPE_TRAP )
end
function c33701329.ssfil2(c,code)
	return c:IsSSetable() and ((c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)) or c:GetType()==TYPE_TRAP ) and c:IsCode(code)
end
function c33701329.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(1-tp,33701329)>=5 and  Duel.IsExistingMatchingCard(c33701329.ssfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c33701329.ssop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.SelectMatchingCard(tp,c33701329.ssfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.SSet(tp,tc)
	local code=tc:GetCode()
	if Duel.IsExistingMatchingCard(c33701329.ssfil2,tp,LOCATION_DECK,0,1,nil,code) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(33701329,0)) then
	local g1=Duel.SelectMatchingCard(tp,c33701329.ssfil2,tp,LOCATION_DECK,0,1,1,nil,code)
	Duel.SSet(tp,g1)
	if Duel.IsExistingMatchingCard(c33701329.ssfil2,tp,LOCATION_DECK,0,1,nil,code) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(33701329,0)) then
	local g2=Duel.SelectMatchingCard(tp,c33701329.ssfil2,tp,LOCATION_DECK,0,1,1,nil,code)
	Duel.SSet(tp,g2)
	end
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetOperation(c33701329.puop)
	c:RegisterEffect(e1)
end
function c33701329.puop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,00701329)~=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(33701329,1)) then
	Duel.SendtoDeck(e:GetHandler(),tp,0,REASON_EFFECT)
	e:GetHandler():ReverseInDeck()
	end
end




