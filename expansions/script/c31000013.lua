--Fallacio Argumentum
function c31000013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(c31000013.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(c31000013.effectfilter)
	c:RegisterEffect(e3)
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c31000013.distg)
	e4:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e4)
	--Search/Level
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c31000013.target)
	e5:SetOperation(c31000013.operation)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(31000013,ACTIVITY_SUMMON,c31000013.counterfilter)
	Duel.AddCustomActivityCounter(31000013,ACTIVITY_SPSUMMON,c31000013.counterfilter)
end

function c31000013.counterfilter(c)
	return c:IsSetCard(0x308) or c:IsCode(31000002)
end

function c31000013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(31000013,tp,ACTIVITY_SUMMON)==0
	 	and Duel.GetCustomActivityCount(31000013,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c31000013.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end

function c31000013.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x308) and not c:IsCode(31000002)
end

function c31000013.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler():IsSetCard(0x308)
end

function c31000013.spfilter(c)
	return c:IsSetCard(0x308) and c:IsType(TYPE_MONSTER)
end

function c31000013.tkfilter(c,lv)
	return c:IsCode(31000002) and c:IsLevel(lv) and c:IsPosition(POS_FACEUP)
end

function c31000013.lvfilter(c)
	return c:IsType(TYPE_MONSTER) and not (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end

function c31000013.distg(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c31000013.tkfilter,tp,nil,LOCATION_MZONE,1,nil,c:GetLevel())
		and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) and not c:IsDisabled()
end

function c31000013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c31000013.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local b1=g1:GetCount()>0 and c31000013.cost(e,tp,eg,ep,ev,re,r,rp,0)
	local g2=Duel.GetMatchingGroup(c31000013.spfilter,tp,LOCATION_HAND,0,nil)
	local b2=g2:GetCount()>0 and Duel.IsExistingMatchingCard(c31000013.lvfilter,tp,nil,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
end

function c31000013.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c31000013.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local b1=g1:GetCount()>0 and c31000013.cost(e,tp,eg,ep,ev,re,r,rp,0)
	local g2=Duel.GetMatchingGroup(c31000013.spfilter,tp,LOCATION_HAND,0,nil)
	local b2=g2:GetCount()>0 and Duel.IsExistingMatchingCard(c31000013.lvfilter,tp,nil,LOCATION_MZONE,1,nil)
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(31000013,0),aux.Stringid(31000013,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(31000013,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(31000013,1))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g1:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc and Duel.IsPlayerCanSendtoHand(tp,tc) then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
		end
		c31000013.cost(e,tp,eg,ep,ev,re,r,rp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g2:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			local g=Duel.GetMatchingGroup(c31000013.lvfilter,tp,0,LOCATION_MZONE,nil)
			for c in aux.Next(g) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetRange(LOCATION_FZONE)
				e1:SetValue(tc:GetLevel())
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e1)
			end
		end
	end
end
