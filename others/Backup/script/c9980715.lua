--キャル
function c9980715.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9980715+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9980715.cost)
	e1:SetTarget(c9980715.target)
	e1:SetOperation(c9980715.activate)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980715.sumsuc)
	c:RegisterEffect(e8)	
end
function c9980715.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980715,0))
end 
function c9980715.rfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsReleasable()
end
function c9980715.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980715.rfilter,tp,LOCATION_ONFIELD,0,1,nil) and e:GetHandler():IsDiscardable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c9980715.rfilter,tp,LOCATION_ONFIELD,0,1,2,nil)
	e:SetLabel(g:GetCount())
	Duel.Release(g,REASON_COST)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9980715.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=e:GetLabel()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,dc) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dc)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dc)
end
function c9980715.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980715,0))
end