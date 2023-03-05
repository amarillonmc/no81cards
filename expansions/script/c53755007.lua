local m=53755007
local cm=_G["c"..m]
cm.name="兔子小队突围"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=Duel.ConfirmDecktop
		Duel.ConfirmDecktop=function(tp,ct)
			local g=Duel.GetDecktopGroup(tp,ct)
			local codet={}
			for tc in aux.Next(g) do table.insert(codet,tc:GetCode()) end
			g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ONFIELD,0,nil,table.unpack(codet)):Filter(Card.IsFaceup,nil)
			for tc in aux.Next(g) do
				if tc:GetFlagEffect(m)==0 then tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1) else
					local ct=tc:GetFlagEffectLabel(m)
					tc:SetFlagEffectLabel(m,ct+1)
				end
			end
			if g:IsExists(Card.IsSetCard,1,nil,0x5536) then Duel.RaiseEvent(g,EVENT_CUSTOM+m,nil,0,0,0,0) end
			return cm[0](tp,ct)
		end
	end
end
function cm.repfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:GetFlagEffect(m)>0 and c:GetFlagEffectLabel(m)>0
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and re:IsActivated() and rp~=tp and eg:IsExists(cm.repfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local container=e:GetLabelObject()
		container:Clear()
		local g=eg:Filter(cm.repfilter,nil,tp)
		local ct=g:GetCount()
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
			g=g:Select(tp,1,ct,nil)
		end
		for tc in aux.Next(g) do
			local lct=tc:GetFlagEffectLabel(m)
			tc:SetFlagEffectLabel(m,lct-1)
		end
		container:Merge(g)
		return true
	else return false end
end
function cm.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x5536) and c:IsSpecialSummonable(0) and not Duel.IsExistingMatchingCard(function(c,code)return c:IsFaceup() and c:IsCode(code)end,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.filter(c)
	return c:IsFaceup() and c:GetBaseAttack()>0
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-300)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
	if g1:GetSum(Card.GetBaseAttack)<g2:GetSum(Card.GetBaseAttack) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc then Duel.SpecialSummonRule(tp,tc,0) end
	end
end
