--键★等 －移动古河面包店 | K.E.Y Etc. Panificio Ambulante Furukawa
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,1,1)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCost(s.rmcost)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
end
function s.matfilter(c)
	return c:IsLinkSetCard(0x460) and not c:IsLinkCode(id)
end

function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function s.rmcfilter(c)
	return c:IsSetCard(0x460) and c:IsType(TYPE_MONSTER) and (c:GetTextAttack()>0 or c:GetTextDefense()>0) and c:IsAbleToGraveAsCost()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.rmcfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.rmcfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		local rec=math.max(g:GetFirst():GetTextAttack(),g:GetFirst():GetTextDefense())
		Duel.SendtoGrave(g,REASON_COST)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(rec)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
	end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local val=Duel.Recover(p,d,REASON_EFFECT)
	if val>0 then
		Duel.SetLP(1-p,Duel.GetLP(1-p)+val*2)
	end		
end