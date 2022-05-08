--重生机 雪莉
function c79029566.initial_effect(c)
	c:SetSPSummonOnce(79029566)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c79029566.matfilter1,c79029566.matfilter2,1,99,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,LOCATION_MZONE,Duel.SendtoGrave,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c79029566.xsplimit)
	c:RegisterEffect(e1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029566,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c79029566.negcon)
	e1:SetCost(c79029566.negcost)
	e1:SetTarget(c79029566.negtg)
	e1:SetOperation(c79029566.negop)
	c:RegisterEffect(e1) 
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029566,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetCost(c79029566.incost)
	e2:SetTarget(c79029566.intg)
	e2:SetOperation(c79029566.inop)
	c:RegisterEffect(e2)   
	--cannot be fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c79029566.xsplimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c79029566.matfilter1(c)
	return c:GetSequence()>4
end
function c79029566.matfilter2(c)
	return c:GetAttackAnnouncedCount()>0 
end
function c79029566.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c79029566.cfilter(c,fc)
	return c:IsAbleToGraveAsCost() and (c:IsControler(fc:GetControler()) or c:IsFaceup())
end
function c79029566.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c79029566.cfilter(c,rtype)
	return c:IsType(rtype) and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function c79029566.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local rtype=bit.band(re:GetActiveType(),TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029566.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_SZONE,0,1,nil,rtype) end
	local g=Duel.SelectMatchingCard(tp,c79029566.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_SZONE,0,1,1,nil,rtype)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c79029566.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(0)
	if chk==0 then return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) end 
	local tc=e:GetLabelObject()
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c79029566.negop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) 
		Duel.NegateActivation(ev)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029566.rmlimit)
	e1:SetLabel(bit.band(re:GetActiveType(),TYPE_SPELL+TYPE_TRAP))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029566.rmlimit(e,c,tp,r,re)
	return c:IsType(e:GetLabel()) and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsCode(79029566) and r==REASON_COST 
end
function c79029566.incost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(math.floor(Duel.GetLP(tp)/2))
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2)) 
end
function c79029566.intg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c79029566.inop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029566.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetOwnerPlayer(tp)
	c:RegisterEffect(e1)  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(e:GetLabel())
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function c79029566.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end




