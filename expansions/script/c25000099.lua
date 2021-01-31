--超巨型植物兽 莫奈拉女王
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000099)
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,nil,rsval.spconbe)
	local e2=rsef.SV_ADD(c,"race",RACE_FIEND)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	local e3=rsef.FC(c,EVENT_LEAVE_FIELD_P,nil,nil,"cd",rsloc.hg,cm.regcon,cm.regop) 
	local e4=rsef.FTO(c,EVENT_LEAVE_FIELD,{m,0},{1,m},"sp,eq","de",rsloc.hg,nil,nil,rsop.target2(cm.fun,{rscf.spfilter2(),"sp"},{ cm.eqfilter,"eq",LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED }),cm.spop)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e4:SetLabelObject(g)
	e3:SetLabelObject(e4)
	local e5=rsef.QO(c,nil,{m,1},{1,m+100},"tg,dam",nil,LOCATION_MZONE,nil,rscost.reglabel(100),cm.tgtg,cm.tgop)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local eqg=c:GetEquipGroup()
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		return eqg:IsExists(cm.tdfilter,1,nil,tp,c:GetFieldID())
	end
	e:SetLabel(0)
	local ct,og,tc=rsgf.SelectToDeck(eqg,tp,cm.tdfilter,1,1,nil,{})
	local tct=cm.getcount(tc)
	e:SetValue(tct)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,tct,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tct*500)
end
function cm.tgop(e,tp)
	local tct=e:GetValue()
	local ct=rsop.SelectToGrave(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tct,tct,nil,{})
	if ct>0 then
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
function cm.getcount(c)
	if not c:IsType(TYPE_MONSTER) then return 0 end
	local ct=0
	if c:IsType(TYPE_XYZ) then ct=c:GetRank()
	elseif c:IsType(TYPE_LINK) then ct=c:GetLink()
	else
		ct=c:GetLevel()
	end
	return ct
end
function cm.tdfilter(c,tp,fid)
	return c:GetFlagEffectLabel(m)==fid and c:IsAbleToDeckOrExtraAsCost()and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,cm.getcount(c),c)
end
function cm.cfilter(c,tp)
	return c:IsControler(1-tp) and c:GetSummonLocation() & LOCATION_EXTRA ~=0 and c:IsLocation(LOCATION_MZONE)
end
function cm.regcon(e,tp,eg)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.regop(e,tp,eg)
	local eg2=eg:Filter(cm.cfilter,nil,tp)
	e:GetLabelObject():GetLabelObject():Clear()
	e:GetLabelObject():GetLabelObject():Merge(eg2)
end
function cm.eqfilter(c,e,tp)
	return e:GetLabelObject():IsContains(c) and cm.eqfilter2(c,e,tp)
end
function cm.eqfilter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.fun(g,e,tp)
	local og=e:GetLabelObject():Clone()
	Duel.SetTargetCard(og)
end
function cm.spop(e,tp)
	local tg=rsgf.GetTargetGroup()
	local c=rscf.GetSelf(e)
	if not c or rssf.SpecialSummon(c)<=0 or #tg<=0 then return end
	rsgf.SelectSolve(tg,HINTMSG_EQUIP,tp,cm.eqfilter2,1,1,nil,cm.eqfun,e,tp)
end
function cm.eqfun(g,e,tp)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if rsop.Equip(e,tc,c) then
		tc:ResetFlagEffect(m)
		tc:RegisterFlagEffect(m,rsreset.est,0,1,c:GetFieldID(),0)
	end
	return true
end
