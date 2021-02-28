--古代龙 大地谜蚺
if not pcall(function() require("expansions/script/c40009451") end) then require("script/c40009451") end
local m,cm = rscf.DefineCard(40009459)
function cm.initial_effect(c)
	local e1=rsad.RitualFun(c)
	local e2=rsad.TributeSFun2(c,m,"se,th",nil,rsop.target(cm.thfilter,nil,rsloc.dg),cm.thop)
	local e3=rsad.TributeTFun(c,m,nil,"de",cm.distg,cm.disop)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and aux.IsCodeListed(c,40009452) and not c:IsCode(m) and c:IsType(TYPE_MONSTER)
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,rsloc.dg,0,1,1,nil,{})
end
function cm.disfilter(c,seq)
	return c:GetSequence()==seq 
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_MZONE,0x60*0x10000)
	local g1=Duel.GetMatchingGroup(cm.disfilter,tp,0,LOCATION_MZONE,nil,math.log(flag>>16,2))
	local g2=g1:Filter(Card.IsFaceup,nil)
	if #g2>0 then
		e:SetCategory(CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	else
		e:SetCategory(0)
	end
	e:SetLabel(flag)
end
function cm.disop(e,tp)
	local c=e:GetHandler()
	local flag=e:GetLabel()
	local g1=Duel.GetMatchingGroup(cm.disfilter,tp,0,LOCATION_MZONE,nil,math.log(flag>>16,2))
	local g2=g1:Filter(Card.IsFaceup,nil)
	if #g2>0 then
		local e1,e2=rsef.SV_LIMIT({c,g2:GetFirst()},"dis,dise,datk",nil,nil,rsreset.est_pend)
	elseif #g1==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetValue(flag)
		e1:SetReset(rsreset.pend)
		Duel.RegisterEffect(e1,tp)
	end
end