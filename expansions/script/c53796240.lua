local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroMixProcedure(c,aux.NonTuner(nil),nil,nil,aux.Tuner(nil),2,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.chcon)
	e1:SetOperation(s.chop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.cecon)
	e2:SetTarget(s.cetg)
	e2:SetOperation(s.ceop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(21142671)
	c:RegisterEffect(e3)
end
function s.chfilter(c,tp)
	return c:IsControler(1-tp) and c:IsControlerCanBeChanged(true)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return false end
	local tg=g:Filter(s.chfilter,e:GetHandler(),rp)
	return #tg>0
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=Duel.GetTargetsRelateToChain()
	if Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_CONTROL)<#g then return end
	Duel.GetControl(g,tp,PHASE_END,1)
end
function s.cecon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g==0 then return false end
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function s.cefilter(c,ct,e)
	return Duel.CheckChainTarget(ct,c) and c:IsCanBeEffectTarget(e)
end
function s.group_equals(g1,g2)
	if #g1~=#g2 then return false end
	for tc in aux.Next(g1) do if not g2:IsContains(tc) then return false end end
	return true
end
function s.fselect(g,tg)
	return not s.group_equals(g,tg)
end
function s.cetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.cefilter(chkc,ev,e:GetHandler()) end
	local g=e:GetLabelObject()
	local sg=Duel.GetMatchingGroup(s.cefilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ev,e)
	if chk==0 then return sg:CheckSubGroup(s.fselect,#g,#g,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=sg:SelectSubGroup(tp,s.fselect,false,#g,#g,g)
	Duel.SetTargetCard(tg)
end
function s.ceop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 then Duel.ChangeTargetCard(ev,g) end
end
