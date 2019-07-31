--
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170005
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_PZONE,cm.spcon,cm.spop)
	local e3,e4=rssp.ChangeOperationFun(c,m,false,cm.con,cm.op,{1,m})
end
function cm.copyfunfilter(c)
	local e1,e2=rssp.ChangeOperationFun(c,m,false,cm.con,cm.op,{1,m})
	return e1,e2
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetReleaseGroup(tp)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,c)
	g1:Merge(g2)
	return g1:IsExists(cm.spcfilter,1,nil,tp)
end
function cm.spcfilter(c,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c,tp)>0 and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.spop(e,tp)
	local g1=Duel.GetReleaseGroup(tp)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())
	g1:Merge(g2)
	g1=g1:Filter(cm.spcfilter,nil,tp)
	rsof.SelectHint(tp,"res")
	local g=g1:Select(tp,1,1,nil)
	if #g>0 then
		Duel.Release(g,REASON_COST)
	end
end
function cm.cfilter(c,tp)
	return c:IsLocation(LOCATION_PZONE) or Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.tffilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa333) and not c:IsForbidden() and not c:IsCode(m) 
end
function cm.cfilter2(c,tc,tp,tg)
	local b1=tc:IsLocation(LOCATION_PZONE) and c:IsLocation(LOCATION_PZONE) 
	local b2=Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b3=tc:IsLocation(LOCATION_PZONE) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	local b4=c:IsLocation(LOCATION_PZONE) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	return (b1 or b2 or b3 or b4) and tg:GetClassCount(Card.GetCode)>=2
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	local tg=Duel.GetMatchingGroup(cm.tffilter,tp,LOCATION_DECK,0,nil)
	rsof.SelectHint(tp,"des")
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,0,1,1,c,tp)
	if #g<=0 then return end
	local tc=g:GetFirst()
	local dg=Duel.GetMatchingGroup(cm.cfilter2,tp,LOCATION_ONFIELD,0,rsgf.Mix2(c,tc),tc,tp,tg)
	if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		rsof.SelectHint(tp,"des")
		local g2=dg:Select(tp,1,1,nil)
		g:Merge(g2)
	end
	Duel.HintSelection(g)
	local dct=Duel.Destroy(g,REASON_EFFECT)
	if dct<=0 then return end
	local ct=0
	for i=0,1 do
		if Duel.CheckLocation(tp,LOCATION_PZONE,i) then
			ct=ct+1
		end
	end
	if tg:GetClassCount(Card.GetCode)<dct or ct<dct then return end
	local tg2=Group.CreateGroup()
	for i=1,dct do
		rsof.SelectHint(tp,HINTMSG_TOFIELD)
		local tg3=tg:Select(tp,1,1,nil)
		tg2:Merge(tg3)
		tg:Remove(Card.IsCode,nil,tg3:GetFirst():GetCode())
	end
	for tc in aux.Next(tg2) do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end