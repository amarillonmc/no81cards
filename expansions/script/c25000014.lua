local m=25000014
local cm=_G["c"..m]
cm.name="万有引力之虹"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local l=g:GetSum(Card.GetLevel)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0,l)
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) and c:IsType(TYPE_MONSTER) and c:IsPreviousControler(tp)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.filter(c,t)
	return (#t>1 or not c:IsLevel(t[1])) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local t={}
	for tc in aux.Next(g) do if not SNNM.IsInTable(tc:GetLevel(),t) then table.insert(t,tc:GetLevel()) end end
	if chk==0 then return #t>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,t) end
	e:SetLabel(table.unpack(t))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local t,c={e:GetLabel()},e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,t)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc and tc:IsLocation(LOCATION_GRAVE) and c:GetFlagEffect(m)>0 then
			if c:GetFlagEffect(m+10000)==0 then c:RegisterFlagEffect(m+10000,RESET_EVENT+RESETS_STANDARD,0,0,0) end
			local flag=c:GetFlagEffectLabel(m+10000)
			c:SetFlagEffectLabel(m+10000,flag+tc:GetLevel())
			if c:GetFlagEffectLabel(m+10000)>=c:GetFlagEffectLabel(m) then
				Duel.BreakEffect()
				local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
				if dg:GetCount()>0 then Duel.Destroy(dg,REASON_EFFECT) end
			end
		end
	end
end
