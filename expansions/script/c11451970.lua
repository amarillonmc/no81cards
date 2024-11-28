--秘计螺旋 递归
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c,code)
	return (c:IsCode(code) or aux.IsCodeListed(c,code)) and c:IsSSetable()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=1 end
	local c=e:GetHandler()
	if chk==0 then
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
		if #eset==0 then return false end
		for _,te in pairs(eset) do
			local code=te:GetHandler():GetOriginalCode()
			if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,code) then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft end
		end
		return false
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	if #eset==0 then return false end
	local tab={}
	for _,te in pairs(eset) do
		tab[#tab+1]=te:GetDescription()
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local op=1+Duel.SelectOption(tp,table.unpack(tab))
	local de=eset[op]
	local ce=de:GetLabelObject()
	if ce and aux.GetValueType(ce)=="Effect" then
		local tc=ce:GetHandler()
		local eset2={tc:IsHasEffect(EFFECT_FLAG_EFFECT+11451961)}
		local res=false
		for _,te in pairs(eset2) do
			if te:GetLabel()==de:GetLabel() then res=true break end
		end
		if res then
			Duel.RaiseEvent(tc,EVENT_CUSTOM+11451961,e,0,0,0,0)
			Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(tc:GetOriginalCode(),3))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(tc:GetOriginalCode(),3))
		end
		ce:Reset()
	end
	de:Reset()
	eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	for i,te in pairs(eset) do
		if i>=op then
			local te2=te:Clone()
			te2:SetDescription(te:GetDescription()-16)
			Duel.RegisterEffect(te2,tp)
			local ce=te:GetLabelObject()
			if ce and aux.GetValueType(ce)=="Effect" then
				local tc=ce:GetHandler()
				local ce2=ce:Clone()
				ce2:SetDescription(ce:GetDescription()-16)
				tc:RegisterEffect(ce2,true)
				te2:SetLabelObject(ce2)
				ce:Reset()
			end
			te:Reset()
		end
	end
	local code=de:GetHandler():GetOriginalCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,code)
	if #g>0 and Duel.SSet(tp,g)>0 then --and g:GetFirst():IsCode(code) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		if g:GetFirst():IsType(TYPE_TRAP) then e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN) end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		g:GetFirst():RegisterEffect(e1)
	end
end