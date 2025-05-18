--魂锁 爆裂的锁链
local s,id,o=GetID()
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.damcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	elements={{"tama_elements",{{TAMA_ELEMENT_EARTH,1},{TAMA_ELEMENT_FIRE,1},{TAMA_ELEMENT_ORDER,1}}}}
	s[c]=elements
	
end
function s.costfilter(c)
	return c:IsSetCard(0x355) and c:IsReleasable()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,99,e:GetHandler())
	Duel.Release(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*400)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
