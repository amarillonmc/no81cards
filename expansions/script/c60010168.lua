--镜海遐
local cm,m,o=GetID()
function cm.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	--e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.poscon)
	e1:SetCost(cm.poscost)
	e1:SetTarget(cm.postg)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp)
	return c:GetSummonLocation()&LOCATION_EXTRA~=0 and c:GetSummonPlayer()~=tp and  c:IsControlerCanBeChanged()
end
function cm.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.cfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 and Duel.GetMZoneCount(tp)>=1 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.sfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.posop(e,tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetMZoneCount(tp)<1 then return end
	if Duel.GetControl(g:Select(tp,1,1,nil),tp)~=0 then
		local b1=false
		local b2=false
		local code=Duel.GetOperatedGroup():GetFirst():GetCode()
		if Duel.IsExistingMatchingCard(cm.sfilter,tp,0,LOCATION_EXTRA,1,nil,e,1-tp,code) then b1=true end
		if Duel.IsPlayerCanDraw(1-tp,1) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then b2=true end
		local op=aux.SelectFromOptions(1-tp,
		{b1,aux.Stringid(m,1)},
		{b2,aux.Stringid(m,2)})
		if op==1 then
			local g=Duel.SelectMatchingCard(1-tp,cm.sfilter,1-tp,LOCATION_EXTRA,0,1,1,nil,e,1-tp,code)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
			end
		elseif op==2 then
			local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then -- and Duel.Destroy(g,REASON_EFFECT)~=0 then
				--Duel.Draw(1-tp,1,REASON_EFFECT)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end

end















