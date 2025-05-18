--魂锁 导爆锁链
local s,id,o=GetID()
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.setcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	elements={{"tama_elements",{{TAMA_ELEMENT_EARTH,1},{TAMA_ELEMENT_FIRE,1},{TAMA_ELEMENT_CHAOS,1}}}}
	s[c]=elements
	
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=e:GetHandler():GetColumnGroup()
	e:SetLabel(aux.GetColumn(c)+1)
	if Duel.GetCurrentChain()>=4 then
		local dg=Group.CreateGroup()
		for i=1,Duel.GetCurrentChain() do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			local tc=te:GetHandler()
			if tc:IsRelateToEffect(te) then
				dg:AddCard(tc)
			end
		end
		g:Merge(dg)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*300)
end
function s.opfilter(c,col)
	return aux.GetColumn(c)==col
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local col=e:GetLabel()
	if col>0 then
		col=col-1
		local dg=Duel.GetMatchingGroup(s.opfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e),col)
		g:Merge(dg)
	end
	if Duel.GetCurrentChain()>=4 then
		local dg=Group.CreateGroup()
		for i=1,Duel.GetCurrentChain() do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			local tc=te:GetHandler()
			if tc:IsRelateToEffect(te) then
				dg:AddCard(tc)
			end
		end
		g:Merge(dg)
	end
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,ct*300,REASON_EFFECT)
		end
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetCurrentChain()>3
end
function s.setfilter(c,tp)
	return c:IsSetCard(0x355) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetActivateEffect():IsActivatable(tp)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),tp) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
