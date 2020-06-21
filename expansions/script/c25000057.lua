--重醒龙 帝王剑斩
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000057)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,3,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL+REASON_FUSION)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)	
	local e2=rsef.QO(c,nil,{m,0},{1,m},"des","tg",LOCATION_MZONE,nil,nil,rstg.target2(cm.fun,cm.cfilter,nil,LOCATION_ONFIELD,LOCATION_ONFIELD),cm.desop)
	local e3=rsef.SV_CANNOT_BE_TARGET(c,"effect",aux.tgoval)
	local e4=rsef.SV_INDESTRUCTABLE(c,"battle,effect")
	local e5,e6=rsef.SV_UPDATE(c,"atk,def",cm.val)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsRace,1,c,c:GetRace())
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.cfilter(c,e,tp)
	return c:GetColumnGroup():FilterCount(Card.IsControler,nil,1-tp)>0
end
function cm.fun(g,e,tp)
	local tc=g:GetFirst()
	local dg=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc then return end
	local dg=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	Duel.Destroy(dg,REASON_EFFECT)
end
function cm.val(e,c)
	return e:GetHandler():GetMaterialCount()*500
end