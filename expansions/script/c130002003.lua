--青玉之龙战士
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(130002003)
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,true,aux.FALSE)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	e2:SetCondition(cm.ntcon)
	e2:SetOperation(cm.ntop)
	c:RegisterEffect(e2)
	local e3=rsef.FC(c,EVENT_CHAINING)
	rsef.RegisterSolve(e3,cm.tdcon,nil,nil,cm.tdop)
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) and re:GetHandler():IsRelateToEffect(re) and Duel.IsPlayerCanSendtoDeck(1-tp,re:GetHandler())
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	rshint.Card(m)
	Duel.SendtoDeck(re:GetHandler(),nil,2,REASON_RULE)
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	return c:IsLevelAbove(5) and #g1>0 and #g2>0
end
function cm.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	c:SetMaterial(Group.CreateGroup())
	local sg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,c)
	rshint.Select(tp,"tg")
	local tg=sg:SelectSubGroup(tp,cm.gcheck,false,2,#sg)
	Duel.SendtoGrave(tg,REASON_COST+REASON_SUMMON)
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #og<=0 then return end
	local fid=c:GetFieldID()
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(m,rsreset.est,0,1,fid)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MAX_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(cm.limitcon)
	e1:SetValue(cm.mvalue)
	e1:SetLabel(fid)
	Duel.RegisterEffect(e1,tp)
	local e2=rsef.RegisterClone({c,tp},e1,"code",EFFECT_MAX_SZONE,"value",cm.svalue)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetValue(cm.aclimit)
	e5:SetCondition(cm.limitcon2)
	e5:SetLabel(fid)
	Duel.RegisterEffect(e5,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_SSET)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetTarget(cm.setlimit)
	e6:SetLabel(fid)
	e6:SetCondition(cm.limitcon2)
	Duel.RegisterEffect(e6,tp)
end
function cm.limitcon2(e)
	local ct=Duel.GetMatchingGroupCount(cm.limitcfilter,0,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil,e:GetLabel())
	if ct>0 then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.aclimit(e,re,tp)
	local ct=Duel.GetMatchingGroupCount(cm.limitcfilter,0,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil,e:GetLabel())
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	if re:IsActiveType(TYPE_FIELD) then
		return not Duel.GetFieldCard(tp,LOCATION_FZONE,0) and not Duel.GetFieldCard(1-tp,LOCATION_FZONE,0) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>(ct-1)
	elseif re:IsActiveType(TYPE_PENDULUM) then
		return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>(ct-1)
	end
	return false
end
function cm.setlimit(e,c,tp)
	local ct=Duel.GetMatchingGroupCount(cm.limitcfilter,0,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil,e:GetLabel())
	return c:IsType(TYPE_FIELD) and not Duel.GetFieldCard(tp,LOCATION_FZONE,0) and not Duel.GetFieldCard(1-tp,LOCATION_FZONE,0) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>(ct-1)
end
function cm.limitcon(e)
	local ct=Duel.GetMatchingGroupCount(cm.limitcfilter,0,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil,e:GetLabel())
	if ct>0 then
		return Duel.GetFieldGroupCount(0,LOCATION_ONFIELD,LOCATION_ONFIELD)<=ct
	else
		e:Reset()
		return false
	end
end
function cm.limitcfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.mvalue(e,fp,rp,r)
	local bct=Duel.GetMatchingGroupCount(cm.limitcfilter,0,LOCATION_GRAVE,LOCATION_GRAVE,nil,e:GetLabel())
	local oct=Duel.GetFieldGroupCount(fp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if oct>=bct then return 0 
	else
		return bct-oct
	end
end
function cm.svalue(e,fp,rp,r)
	local bct=Duel.GetMatchingGroupCount(cm.limitcfilter,0,LOCATION_GRAVE,LOCATION_GRAVE,nil,e:GetLabel())
	for i=5,7 do
		if Duel.GetFieldCard(fp,LOCATION_SZONE,i) then bct=bct-1 end
		if Duel.GetFieldCard(1-fp,LOCATION_SZONE,i) then bct=bct-1 end
	end
	local oct=Duel.GetFieldGroupCount(fp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if oct>=bct then return 0 
	else
		return bct-oct
	end
end
function cm.gcheck(g)
	return g:FilterCount(Card.IsControler,nil,0)==g:FilterCount(Card.IsControler,nil,1)
end