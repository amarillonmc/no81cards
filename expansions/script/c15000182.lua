local m=15000182
local cm=_G["c"..m]
cm.name="灵摆暂用"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCountLimit(1,15000182+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	e1:SetValue(cm.zones)
	c:RegisterEffect(e1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	local list={2,3,4,5,6,7,8}
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_NUMBER)
	local x,x4=Duel.AnnounceNumber(tp,table.unpack(list))
	if x~=2 and x~=8 then
		table.remove(list,x-2)
		table.remove(list,x-2)
		table.remove(list,x-2)
	end
	if x==2 then
		table.remove(list,1)
		table.remove(list,1)
	end
	if x==8 then
		table.remove(list)
		table.remove(list)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_NUMBER)
	local y,y4=Duel.AnnounceNumber(tp,table.unpack(list))
	e:SetLabel(x)
	Duel.SetTargetParam(y)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetLabel()
	local y=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	local fid=e:GetHandler():GetFieldID()
	local g=Group.CreateGroup()
	local token1=Duel.CreateToken(tp,15003013)
	if Duel.MoveToField(token1,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		token1:RegisterFlagEffect(15000182,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		g:AddCard(token1)
		--scale
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_PZONE)
		e1:SetValue(x)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token1:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		token1:RegisterEffect(e2)
	end
	local token2=Duel.CreateToken(tp,15003013)
	if Duel.MoveToField(token2,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		token2:RegisterFlagEffect(15000182,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		g:AddCard(token2)
		--scale
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_PZONE)
		e1:SetValue(y)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token2:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		token2:RegisterEffect(e2)
	end
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(cm.descon)
	e1:SetOperation(cm.desop)
	Duel.RegisterEffect(e1,tp)
end
function cm.desfilter(c,fid)
	return c:GetFlagEffectLabel(15000182)==fid
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_PENDULUM) end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
function cm.zones(e,tp,eg,ep,ev,re,r,rp)
	return 0xe
end