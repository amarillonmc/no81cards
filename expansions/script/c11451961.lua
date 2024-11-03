--秘计螺旋 球闪
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+11451961)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(0xff)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCondition(cm.recon)
	e1:SetOperation(cm.reop)
	Duel.RegisterEffect(e1,tp)
	local eid=e1:GetFieldID()
	e1:SetLabel(eid)
	local ce=nil
	if c:IsFaceup() and not c:IsLocation(LOCATION_HAND) then
		--Duel.HintSelection(Group.FromCards(c))
		ce=c:RegisterFlagEffect(11451961,RESET_EVENT+RESET_TODECK+RESET_TOHAND+RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,eid,aux.Stringid(11451961,1))
	end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	for _,te in pairs(eset) do
		local te2=te:Clone()
		te2:SetDescription(te:GetDescription()+16)
		Duel.RegisterEffect(te2,tp)
		te:Reset()
	end
	eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	DEFECT_ORAL_COUNT=DEFECT_ORAL_COUNT or 3
	if #eset==DEFECT_ORAL_COUNT then
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
	end
	--[[local id=5
	local res=false
	while not res do
		res=true
		for _,te in pairs(eset) do
			if te:GetDescription()==aux.Stringid(m,id) then res=false id=id+1 end
		end
	end--]]
	local de=Effect.CreateEffect(c)
	de:SetDescription(aux.Stringid(11451961,5))
	de:SetLabel(eid)
	de:SetType(EFFECT_TYPE_FIELD)
	de:SetCode(0x20000000+11451961)
	de:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	de:SetTargetRange(1,0)
	Duel.RegisterEffect(de,tp)
	if ce then de:SetLabelObject(ce) end
	local e3=e1:Clone()
	e3:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e3,tp)
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.filter(c,tp,seq)
	return aux.GetColumn(c,tp)+1==seq
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	local res=false
	for _,te in pairs(eset) do
		if te:GetLabel()==e:GetLabel() then res=true break end
	end
	if not res then e:Reset() return end
	local d=Duel.TossDice(tp,1)
	if d>5 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0,1,nil,tp,d)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)>0 and c:IsLocation(LOCATION_SZONE) then
		local cg=c:GetColumnGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=cg:Select(tp,1,1,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end