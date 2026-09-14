--惑精之福禄考火星
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1101)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1153)
	e2:SetCategory(CATEGORY_SSET+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.sphcon)
	e2:SetTarget(s.sphtg)
	e2:SetOperation(s.sphop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function s.thfilter(c,e,tp)
	return c:IsSetCard(0xca7d) and c:GetLevel()~=4 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE,0,2,nil,TYPE_MONSTER) 
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,nil,TYPE_MONSTER)
	if #sg>0 and Duel.Destroy(sg,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #sg2>0 then
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		end
	end
end
function s.sphcon(e,tp,eg,ep,ev,re,r,rp)
	return re~=e:GetLabelObject()
end
function s.setfilter(c)
    return c:IsSetCard(0xAA7D) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.sphtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function s.sphop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=sg:GetFirst()
	if tc and Duel.SSet(tp,tc)>0 then
		if not (tc:IsType(TYPE_QUICKPLAY) or tc:IsType(TYPE_TRAP)) then return end
		if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,tc)
			if #dg>0 then
				if dg:GetFirst():IsLocation(LOCATION_ONFIELD) then Duel.HintSelection(dg) end
				if Duel.Destroy(dg,REASON_EFFECT)>0 then
					if tc:IsType(TYPE_QUICKPLAY) then
						local e1=Effect.CreateEffect(c)
						e1:SetDescription(aux.Stringid(id,2))
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
					end
					if tc:IsType(TYPE_TRAP) then
						local e1=Effect.CreateEffect(c)
						e1:SetDescription(aux.Stringid(id,2))
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
					end
				end
			end
		end
	end
end