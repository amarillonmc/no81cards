--幽冥战士 凯赫罗斯
local s,id,o=GetID()
function s.initial_effect(c)
	--Xyz Summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,s.xyzfilter,6,2,nil,nil,99)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.discon)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--Attach from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(s.atchtg)
	e2:SetOperation(s.atchop)
	c:RegisterEffect(e2)
end
function s.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(ATTRIBUTE_DARK)
		and Duel.IsChainNegatable(ev)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if tc:IsSetCard(0xd70) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SendtoGrave(tc,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		if e:GetLabel()==1 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function s.atchfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_MONSTER)
end
function s.atchtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(s.atchfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function s.atchop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.atchfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
