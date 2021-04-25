--反转世界的弧光 玉
if not pcall(function() require("expansions/script/c130006013") end) then require("script/c130006013") end
local m,cm=rscf.DefineCard(130006017,"FanZhuanShiJie")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,2)
	local e2 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"tg",{1,"s"},"tg","de",cm.tgcon(0),nil,rsop.target(cm.tgfilter,"tg",LOCATION_DECK),cm.tgop)
	local e3 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"th",{1,"s"},"th,dh","de",cm.tgcon(1),nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e0 = rsef.SV_Card(c,"mat",cm.val,"cd")
	e2:SetLabelObject(e0)   
	e3:SetLabelObject(e0)
	local e4 = rsef.QO(c,nil,"ctrl",1,"ctrl","tg",LOCATION_MZONE,nil,nil,rstg.target2(cm.fun,cm.mvfilter,"ms",LOCATION_MZONE,0,1,1,c),cm.mvop)
	cm.glist = cm.glist or Group.CreateGroup()
	cm.glist : KeepAlive()
	e4:SetLabelObject(cm.glist)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.lvtg)
	e1:SetValue(cm.lvval)
	c:RegisterEffect(e1)
end
function cm.getcg(tp,c,rc)
	cm.glist:Clear()
	local seq1,seq2 = rc:GetSequence(), c:GetSequence()
	if seq1 > 4 or seq2 > 4 then return false end
	if seq1 > seq2 then seq1,seq2 = seq2,seq1 end
	local sg = Duel.GetMatchingGroup(cm.confilter,tp,0,LOCATION_MZONE,nil,4-seq1,4-seq2)
	cm.glist:Merge(sg)
end
function cm.mvop(e,tp)
	local c,tc = rscf.GetSelf(e), rscf.GetTargetCard()
	if not c or not tc or tc:IsControler(1-tp) then return end
	Duel.SwapSequence(c,tc)
	cm.getcg(tp,tc,c)
	local cg = cm.glist
	if #cg>0 then
		Duel.GetControl(cg,tp)
	end
end
function cm.mvfilter(c,e,tp)
	local rc = e:GetHandler()
	cm.getcg(tp,c,rc)
	local cg = cm.glist
	return #cg > 0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL) >= #cg
end
function cm.fun(g,e,tp)
	local c,rc = g:GetFirst(), e:GetHandler()
	cm.getcg(tp,c,rc)
	local cg = cm.glist
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,cg,#cg,0,0)
end
function cm.confilter(c,seq1,seq2)
	local seq0 = c:GetSequence()
	if seq0 == 5 then seq0 = 1 end
	if seq0 == 6 then seq0 = 3 end
	return c:IsControlerCanBeChanged(true) and seq0 <= seq1 and seq0 >= seq2
end
function cm.val(e,c)
	local mat = c:GetMaterial()
	if mat:IsExists(aux.FilterEqualFunction(Card.GetOwner,1-c:GetControler()),1,nil) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.tgcon(ct)
	return function(e)
		return e:GetLabelObject():GetLabel() >= ct
	end
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and rsfz.IsSetM(c)
end
function cm.thfilter(c,e,tp)
	return c:IsAbleToHand() and rsfz.IsSetM(c)
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
end
function cm.tgop(e,tp)
	rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.lvtg(e,c)
	return c:IsLevelAbove(1) and c:GetOwner()~=e:GetHandlerPlayer()
end
function cm.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 5
	else return lv end
end