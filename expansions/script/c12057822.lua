--访问码语姬
function c12057822.initial_effect(c) 
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c12057822.lcheck)
	c:EnableReviveLimit()
	--cannot disable spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c12057822.effcon)
	c:RegisterEffect(e0) 
	--atk def 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(12057822,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,12057822)
	e1:SetTarget(c12057822.aktg)  
	e1:SetOperation(c12057822.akop)
	c:RegisterEffect(e1)
	--extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--to grave 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12057822,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,22057822)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c12057822.cost)
	e4:SetTarget(c12057822.tgtg)
	e4:SetOperation(c12057822.tgop)
	c:RegisterEffect(e4)
end
function c12057822.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_RITUAL+TYPE_SYNCHRO+TYPE_FUSION+TYPE_XYZ+TYPE_PENDULUM)
end
function c12057822.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c12057822.aktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_MZONE)
	Duel.SetChainLimit(c12057822.chainlm)
end
function c12057822.chainlm(e,ep,tp)
	return tp==ep
end 
function c12057822.akop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst() 
		while tc do 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)   
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(0) 
		e3:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e3) 
		local e4=e3:Clone() 
		e4:SetCode(EFFECT_SET_DEFENSE_FINAL) 
		tc:RegisterEffect(e4) 
	if tc:GetAttack()~=0 or tc:GetDefense()~=0 then 
	Duel.SendtoDeck(tc,nil,2,REASON_RULE)
	end 
		tc=sg:GetNext() 
		end 
	end 
end
function c12057822.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c12057822.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c12057822.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c12057822.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
end 
function c12057822.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler()) 
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil) 
	Duel.Destroy(dg,REASON_EFFECT)
	end 
end 

