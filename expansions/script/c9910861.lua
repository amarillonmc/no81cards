--千恋凝月
function c9910861.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c9910861.condition)
	e1:SetCost(c9910861.cost)
	e1:SetTarget(c9910861.target)
	e1:SetOperation(c9910861.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_BATTLE_START)
	e3:SetCondition(c9910861.sumcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9910861.sumtg)
	e3:SetOperation(c9910861.sumop)
	c:RegisterEffect(e3)
end
function c9910861.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetCurrentChain()==0
end
function c9910861.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(REASON_COST,tp,Card.IsSetCard,1,nil,0xa951) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(REASON_COST,tp,Card.IsSetCard,1,1,nil,0xa951)
	Duel.Release(g,REASON_COST)
end
function c9910861.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(1-tp,4)
	local lab=Duel.GetFlagEffectLabel(tp,9910861)
	local b1=rg:GetCount()>0 and rg:FilterCount(Card.IsAbleToRemove,nil)==4 and (not lab or bit.band(lab,1)==0)
	local b2=not lab or bit.band(lab,2)==0
	local b3=not lab or bit.band(lab,4)==0
	if chk==0 then return b1 or b2 or b3 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c9910861.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	local ct=1
	if Duel.GetFlagEffect(tp,9910860)~=0 then ct=2 end
	local rg=Duel.GetDecktopGroup(1-tp,4)
	local lab=Duel.GetFlagEffectLabel(tp,9910861)
	local b1=rg:GetCount()>0 and rg:FilterCount(Card.IsAbleToRemove,nil)==4 and (not lab or bit.band(lab,1)==0)
	local b2=not lab or bit.band(lab,2)==0
	local b3=not lab or bit.band(lab,4)==0
	if not (b1 or b2 or b3) then return end
	local sel=0
	local off=0
	repeat
		local ops={}
		local opval={}
		off=1
		if b1 then
			ops[off]=aux.Stringid(9910861,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(9910861,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(9910861,2)
			opval[off-1]=3
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			sel=sel+1
			b1=false
		elseif opval[op]==2 then
			sel=sel+2
			b2=false
		else
			sel=sel+4
			b3=false
		end
		ct=ct-1
	until ct==0 or off<3 or not Duel.SelectYesNo(tp,aux.Stringid(9910861,3))
	if bit.band(sel,1)~=0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		if not lab then
			lab=1
			Duel.RegisterFlagEffect(tp,9910861,RESET_PHASE+PHASE_END,0,1,1)
		else
			lab=lab+1
			Duel.SetFlagEffectLabel(tp,9910861,lab)
		end
	end
	if bit.band(sel,2)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c9910861.discon)
		e1:SetOperation(c9910861.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(9910861,4))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTargetRange(1,1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		if not lab then
			lab=2
			Duel.RegisterFlagEffect(tp,9910861,RESET_PHASE+PHASE_END,0,1,2)
		else
			lab=lab+2
			Duel.SetFlagEffectLabel(tp,9910861,lab)
		end
	end
	if bit.band(sel,4)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetTargetRange(0xff,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,9910850))
		e1:SetValue(-1)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,9910860,0,0,1)
		if not lab then
			lab=4
			Duel.RegisterFlagEffect(tp,9910861,RESET_PHASE+PHASE_END,0,1,4)
		else
			lab=lab+4
			Duel.SetFlagEffectLabel(tp,9910861,lab)
		end
	end
end
function c9910861.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9910865)==0 and ep~=tp
end
function c9910861.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910861)
	Duel.RegisterFlagEffect(tp,9910865,RESET_PHASE+PHASE_END,0,1)
	Duel.NegateEffect(ev,true)
	e:Reset()
end
function c9910861.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c9910861.sumfilter(c)
	return c:IsSetCard(0xa951) and c:IsSummonable(true,nil)
end
function c9910861.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910861.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9910861.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910861.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
