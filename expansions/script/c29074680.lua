--追寻者 -方舟骑士-
c29074680.named_with_Arknight=1
function c29074680.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c29074680.mfilter,1,1)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(29074680)
	aux.AddCodeList(c,29065500,29065502)
	--change name
	aux.EnableChangeCode(c,29065500,LOCATION_MZONE+LOCATION_GRAVE)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c29074680.actcon)
	e1:SetTarget(c29074680.acttg)
	e1:SetOperation(c29074680.actop)
	c:RegisterEffect(e1)
end
function c29074680.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c29074680.filter(c,tp)
	return c:IsCode(29065510) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c29074680.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29074680.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29074680.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c29074680.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end

function c29074680.mfilter(c)
	return c:IsCode(29065500) or c:IsCode(29065502)
end