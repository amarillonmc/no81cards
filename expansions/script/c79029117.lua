--龙门·重装干员-年
function c79029117.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,c79029117.fusfilter1,c79029117.fusfilter2,c79029117.fusfilter3,c79029117.fusfilter4,c79029117.fusfilter5,c79029117.fusfilter6)
	 aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)   
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c79029117.splimit)
	c:RegisterEffect(e1)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70369116,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCost(c79029117.cpcost0)
	e2:SetTarget(c79029117.cptg0)
	e2:SetOperation(c79029117.cpop0)
	c:RegisterEffect(e2)
	--copy effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43387895,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c79029117.copycost)
	e3:SetTarget(c79029117.copytg)
	e3:SetOperation(c79029117.copyop)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c79029117.adval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e5)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c79029117.efilter)
	c:RegisterEffect(e6)
	--cannot release
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UNRELEASABLE_SUM)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e8)
end
function c79029117.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c79029117.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c79029117.fusfilter1(c)
	return c:IsSetCard(0xa900) and c:IsFusionType(TYPE_FUSION)
end
function c79029117.fusfilter2(c)
	return c:IsSetCard(0xa900) and c:IsFusionType(TYPE_SYNCHRO)
end
function c79029117.fusfilter3(c)
	return c:IsSetCard(0xa900) and c:IsFusionType(TYPE_XYZ)
end
function c79029117.fusfilter4(c)
	return c:IsSetCard(0xa900) and c:IsFusionType(TYPE_PENDULUM)
end
function c79029117.fusfilter5(c)
	return c:IsSetCard(0xa900) and c:IsFusionType(TYPE_RITUAL)
end
function c79029117.fusfilter6(c)
	return c:IsSetCard(0xa900) and c:IsFusionType(TYPE_LINK)
end
function c79029117.filter(c)
	return c:IsFaceup() and c:GetCode()~=79029117 and not c:IsHasEffect(79029117)
end
function c79029117.adval(e,c)
	local g=Duel.GetMatchingGroup(c79029117.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then 
		return 100
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		return val+100
	end
end
function c79029117.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(79029117)==0 end
	e:GetHandler():RegisterFlagEffect(79029117,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c79029117.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c79029117.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c79029117.copyfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c79029117.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79029117.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,c)
end
function c79029117.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and (tc:IsFaceup() or tc:IsLocation(LOCATION_GRAVE)) then
		local code=tc:GetOriginalCodeRule()
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetCode(EFFECT_CHANGE_CODE)
		e0:SetValue(code)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e0)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	end
end
function c79029117.cpfilter(c)
	return (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY) or c:IsType(TYPE_TRAP)) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function c79029117.cpcost0(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c79029117.cptg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c79029117.cpfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029117.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)

end
function c79029117.cpop0(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end










