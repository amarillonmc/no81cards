--面灵气 哭面
Duel.LoadScript('c47310000.lua')
local s,id=GetID()

function s.effgain(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.con)
	e1:SetOperation(s.op)
	return e1
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    local rc=re:GetHandler()
    return rc:GetLocation()&loc==0 and Duel.IsChainDisablable(ev) and e:GetHandler():GetFlagEffect(47310022)<=0
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,0)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(47310022,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
end
function s.eqeff(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
end
function s.todeck(c)
	local e1=Hnk.become_target(c,id)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
    c:RegisterEffect(e1)
end
function s.tdfilter(c)
    return c:IsSetCard(0x3ca0) and c:IsAbleToRemove()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) then
		Hnk.public(e:GetHandler(),id,tp)
	end
end
function s.initial_effect(c)
    Hnk.hnk_equip(c,id,s.effgain(c))
    s.eqeff(c)
    s.todeck(c)
end
