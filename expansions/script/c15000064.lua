local m=15000064
local cm=_G["c"..m]
cm.name="与色带神的签订"
function cm.initial_effect(c)
	--Destroy  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetRange(LOCATION_SZONE)  
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)  
	e1:SetCountLimit(1)  
	e1:SetCondition(c15000064.descon)  
	e1:SetOperation(c15000064.desop)  
	c:RegisterEffect(e1)
	--Activate  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_ACTIVATE)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e2)
	--when Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_DESTROYED)  
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCountLimit(1,15000064)
	e3:SetCondition(c15000064.spcon)
	e3:SetOperation(c15000064.spop)  
	c:RegisterEffect(e3)
end
function c15000064.desfilter(c)  
	return c:IsDestructable() and not c:IsType(TYPE_FIELD)
end
function c15000064.descon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()==tp  
end  
function c15000064.desop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	Duel.HintSelection(Group.FromCards(c))  
	local g=Duel.SelectMatchingCard(tp,c15000064.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()~=0 then
		local tc=g:GetFirst()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c15000064.des2filter(c)
	return c:IsSetCard(0xf33) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM)
end
function c15000064.cfilter(c,tp)  
	return c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp  
end
function c15000064.c3filter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c15000064.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c15000064.cfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c15000064.des2filter,tp,LOCATION_DECK,0,1,nil)
end
function c15000064.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15000064,0))  
	local ag=Duel.SelectMatchingCard(tp,c15000064.des2filter,tp,LOCATION_DECK,0,1,1,nil,c)  
	local tc=ag:GetFirst()  
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) then
		local g=Duel.GetMatchingGroup(c15000064.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
		if g:GetCount()==2 then
			local cc=g:GetFirst()
			local lsc=cc:GetLeftScale()
			local dc=g:GetNext()
			local l2sc=dc:GetLeftScale()
			if (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1) and Duel.SelectYesNo(tp,aux.Stringid(15000064,1)) and Duel.GetLocationCount(tp,LOCATION_MZONE)~=0 then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoExtraP(tc,tp,REASON_EFFECT)
			end
		else
			Duel.SendtoExtraP(tc,tp,REASON_EFFECT)
		end
	else
		Duel.SendtoExtraP(tc,tp,REASON_EFFECT)
	end
end