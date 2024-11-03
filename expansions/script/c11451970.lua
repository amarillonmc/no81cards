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
	local c=e:GetHandler()
	if chk==0 then
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
		--for _,te in pairs(eset) do
			if #eset==0 then return false end
			local te=eset[1]
			local code=te:GetHandler():GetOriginalCode()
			if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,code) then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (Duel.GetLocationCount(tp,LOCATION_SZONE)>1 or e:GetHandler():IsOnField()) end
		--end
		return false
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	if #eset==0 then return false end
	local de=eset[1]
	local ce=de:GetLabelObject()
	if ce then
		local tc=ce:GetHandler()
		local eset2={tc:IsHasEffect(EFFECT_FLAG_EFFECT+11451961)}
		local res=false
		for _,te in pairs(eset2) do
			if te:GetLabel()==de:GetLabel() then res=true break end
		end
		if res then Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+11451961,e,0,0,0,0) end
		ce:Reset()
	end
	de:Reset()
	local code=de:GetHandler():GetOriginalCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,code)
	if #g>0 and Duel.SSet(tp,g)>0 and g:GetFirst():IsCode(code) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		g:GetFirst():RegisterEffect(e1)
	end
end