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
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c31000013.cpcon)
	e2:SetOperation(c31000013.cpop)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c31000013.distg)
	e3:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e3)
	--Search/Level
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c31000013.target)
	e4:SetOperation(c31000013.operation)
	c:RegisterEffect(e4)
end

function c31000013.cpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local p=e:GetHandler():GetControler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x308) and loc==LOCATION_MZONE
end

function c31000013.cpop(e,tp,eg,ep,ev,re,r,rp)
	local lb=re:GetLabel()
	if lb then e:SetLabel(lb) end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g then Duel.SetTargetCard(g) end
	local op=re:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.NegateEffect(ev)
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
	return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) and
		Duel.IsExistingMatchingCard(c31000013.tkfilter,tp,nil,LOCATION_MZONE,1,nil,c:GetLevel())
end

function c31000013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c31000013.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return g1:GetCount()>0 end
end

function c31000013.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c31000013.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g1:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc and Duel.IsPlayerCanSendtoHand(tp,tc) then
			if Duel.SendtoHand(sg,tp,REASON_EFFECT) then
				Duel.ConfirmCards(1-tp,sg)
				local g=Duel.GetMatchingGroup(c31000013.lvfilter,tp,0,LOCATION_MZONE,nil)
				if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(31000013,1)) then
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
	end
end
