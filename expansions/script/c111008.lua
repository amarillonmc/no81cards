--丰收时刻·红帽
local m=111008
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Act To Field
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2) 
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetReason(),0x41)==0x41
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttack(1950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_BEASTWARRIOR)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and not e:GetHandler():IsForbidden() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or not tc:IsRelateToEffect(e) or tc:IsForbidden() then return end
	if tc then
		local te=tc:GetActivateEffect()
		local b2=te:IsActivatable(tp,true,true)
		if not b2 then return end
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				local tc=sg:GetFirst()
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end