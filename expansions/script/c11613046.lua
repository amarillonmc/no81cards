--星间书编纂司 卡尼尔
local s,id,o=GetID()
function s.initial_effect(c)
	--Xyz Procedure
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Atk Up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) return c:IsLevel(1) or c:IsRank(1) end)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o*2)
	e3:SetCost(s.descost)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
function s.thfilter(c)
	return c:IsSetCard(0x3226) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,2,2,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local tg=sg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.SSet(tp,tc)
		sg:RemoveCard(tc)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function s.atkval(e,c)
	return Duel.GetOverlayCount(e:GetHandlerPlayer(),1,1)*300
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(tc)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local tc=e:GetLabelObject()
	if tc and tc:GetType()==TYPE_SPELL and tc:IsSetCard(0x3226) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			local te=tc:CheckActivateEffect(false,true,false)
			if not te then return end
			local tpe=tc:GetType()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			Duel.ClearTargetCard()
			if tg then
				if tc:IsSetCard(0x3226) then
					tg(e,tp,eg,ep,ev,re,r,rp,1)
				else
					tg(te,tp,eg,ep,ev,re,r,rp,1)
				end
			end
			Duel.BreakEffect()
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if not g then g=Group.CreateGroup() end
			for etc in aux.Next(g) do
				etc:CreateEffectRelation(te)
			end
			if op then
				if tc:IsSetCard(0x3226) then
					op(e,tp,eg,ep,ev,re,r,rp)
				else
					op(te,tp,eg,ep,ev,re,r,rp)
				end
			end
			for etc in aux.Next(g) do
				etc:ReleaseEffectRelation(te)
			end
		end
	end
end
