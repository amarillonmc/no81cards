--蓝金快车 莱特宁号
local m=64800183
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2)
	c:EnableReviveLimit()
	--destroy&damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.sp1filter(c,race,att)
	return c:IsFaceup() and (bit.band(race,c:GetOriginalRace())~=0 or bit.band(att,c:GetOriginalAttribute())~=0)
end
function cm.gcheck(g,c,tp)
	local sg=g:Clone()
	local ac=sg:GetFirst()
	local bg=Group.CreateGroup()
	while ac do
		if not Duel.IsExistingMatchingCard(cm.sp1filter,tp,LOCATION_MZONE,0,1,nil,ac:GetOriginalRace(),ac:GetOriginalAttribute()) then bg:AddCard(ac) end
		ac=sg:GetNext()
	end
	return bg:GetCount()~=0
end
function cm.check(c,e,tp)
	return c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.check,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:CheckSubGroup(cm.gcheck,1,1,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(cm.check,tp,LOCATION_DECK,0,nil,e,tp)
	if g:CheckSubGroup(cm.gcheck,1,1,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=g:SelectSubGroup(tp,cm.gcheck,false,1,1,tp)
		if not sg then return end
		local tc=sg:GetFirst()
		if tc then
			if not Duel.Equip(tp,tc,c) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetLabelObject(c)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(1000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetRange(LOCATION_SZONE)
			e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e0)
		end
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end


