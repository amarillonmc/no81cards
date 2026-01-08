--星坏兽 空创奇美拉
local s,id=GetID()
s.named_with_HighEvo=1

function s.HighEvo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_HighEvo
end

function s.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end


function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and 
		re:IsActiveType(TYPE_TRAP)  
	
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
		c:CompleteProcedure()
		local rc=re:GetHandler()
		if s.HighEvo(rc) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetValue(1)
			e1:SetReset(RESET_PHASE+Duel.GetCurrentPhase())
			Duel.RegisterEffect(e1,tp)
			Duel.Hint(HINT_CARD,0,id)
		end
	end
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or ev<=1 then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	
	local te_prev,p_prev=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if p_prev~=tp then return false end
	
	local loc_prev=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_LOCATION)
	return (loc_prev&LOCATION_ONFIELD)~=0
end

function s.actfilter(c,tp)
	return s.HighEvo(c) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
		and c:IsType(TYPE_FIELD) == false 
		and not c:IsForbidden()
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then

		local g=Duel.GetMatchingGroup(s.actfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc then

				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)

				local te=tc:GetActivateEffect()
				if not te then return end

				local te_op=te:GetOperation()

				tc:CreateEffectRelation(te)

				local te_tg=te:GetTarget()
				if te_tg then

					if te_tg(te,tp,eg,ep,ev,re,r,rp,0) then
						te_tg(te,tp,eg,ep,ev,re,r,rp,1)
					end
				end
				
				if te_op then
					te_op(te,tp,eg,ep,ev,re,r,rp)
				end
				
				tc:ReleaseEffectRelation(te)
				
			end
		end
	end
end
