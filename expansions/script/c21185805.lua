--恶魔的恩典
function c21185805.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,21185805)
	e2:SetTarget(c21185805.sptarget)
	e2:SetOperation(c21185805.spoperation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1,21185806)
	e3:SetCondition(c21185805.condition)
	e3:SetTarget(c21185805.target)
	e3:SetOperation(c21185805.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c21185805.recon)
	e4:SetOperation(c21185805.reop)
	c:RegisterEffect(e4)	
end
function c21185805.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,0)
end
function c21185805.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c21185805.spcon)
	e1:SetOperation(c21185805.spop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21185805.spfilter(c,e,tp,g) 
	return c:IsRace(RACE_DRAGON) and c:IsFacedown() and c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil,g,#g-1,#g-1) -- and c:IsCanBePlacedOnField(tp)
end
function c21185805.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
	return Duel.GetTurnCount()==e:GetLabel() and aux.gffcheck(g,Card.IsCode,21185805,Card.IsCode,21185800) and Duel.IsExistingMatchingCard(c21185805.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:IsExists(Card.IsAbleToHand,1,nil)
end
function c21185805.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,21185805)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=Duel.SelectMatchingCard(tp,c21185805.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false) then
			tc:CompleteProcedure()
			_copy=Card.RegisterEffect
			function Card.RegisterEffect(card,effect,...)
				local _copyeffect=effect:Clone()
				if _copyeffect:GetRange()&LOCATION_MZONE>0 then
					_copyeffect:SetRange(LOCATION_SZONE)
				end
				if _copyeffect:IsHasType(EFFECT_TYPE_IGNITION) then
					_copyeffect:SetType(EFFECT_TYPE_QUICK_O)
					_copyeffect:SetCode(EVENT_FREE_CHAIN)
				end
				local con=effect:GetCondition()
				if con then 
					_copyeffect:SetCondition(function(...)
												   return con(...) and  tc:IsType(TYPE_TRAP) and tc:IsType(TYPE_CONTINUOUS)
											   end)
				else
					_copyeffect:SetCondition(function(...)
												   return tc:IsType(TYPE_TRAP) and tc:IsType(TYPE_CONTINUOUS)
											   end)
				end
				_copyeffect:SetReset(RESET_EVENT+RESETS_STANDARD)
				_copy(tc,_copyeffect,...)
				_copy(card,effect,...)
			end
			local code=tc:GetOriginalCode()
			Duel.CreateToken(tp,code)
			Card.RegisterEffect=_copy
			tc:RegisterFlagEffect(21185805,0,0,0)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			tc:SetStatus(STATUS_EFFECT_ENABLED,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_TO_DECK)
			e1:SetCondition(c21185805.resetcon)
			e1:SetOperation(c21185805.resetop)
			tc:RegisterEffect(e1)
			local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_PZONE,0,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c21185805.resetcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEDOWN)
end

function c21185805.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(21185805)
	e:Reset()
end
function c21185805.codecheck(c)
	return c:IsFacedown() or c:GetFlagEffect(21185805)<1 
end
function c21185805.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21185805.codecheck,tp,LOCATION_MZONE,0,nil)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and #g==0
end
function c21185805.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c21185805.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT) and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			Duel.BreakEffect()
			if Duel.SpecialSummonStep(c,0,tp,1-tp,false,false,POS_FACEUP) then
				c:RegisterFlagEffect(21185805+1,RESET_EVENT+RESETS_STANDARD,0,1)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c21185805.recon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	return ep==tp and re:GetHandler():IsType(TYPE_MONSTER) and loc==LOCATION_MZONE or loc==LOCATION_HAND and e:GetHandler():GetFlagEffect(21185805+1)>0
end
function c21185805.a(c,x)
	return aux.IsCodeListed(c,x) and c:IsAbleToDeck() and c:IsFaceup()
end
function c21185805.b(c,x)
	return aux.IsMaterialListCode(c,x) and c:IsAbleToDeck() and c:IsFaceup()
end
function c21185805.c(c,x)
	return c:IsSetCard(c,x) and c:IsAbleToDeck() and c:IsFaceup()
end
function c21185805.reop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local code=rc:GetCode()
	local setcard=Duel.ReadCard(rc,CARDDATA_SETCODE)
	local g1=Duel.GetMatchingGroup(c21185805.a,tp,LOCATION_ONFIELD,0,nil,code)
	local g2=Duel.GetMatchingGroup(c21185805.b,tp,LOCATION_ONFIELD,0,nil,code)
	local g3=Duel.GetMatchingGroup(c21185805.c,tp,LOCATION_ONFIELD,0,nil,setcard)
	local sg=Group.CreateGroup()
	sg:Merge(g1)
	sg:Merge(g2)
	sg:Merge(g3)
	if #sg>0 then
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end