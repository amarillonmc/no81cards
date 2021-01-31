--钢铁的杀手 詹杀手
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000095)
function cm.initial_effect(c)  
	local e2=rsef.SV_INDESTRUCTABLE(c,"effect")
	local e3=rsef.SV_CANNOT_BE_TARGET(c,"effect",aux.tgoval)
	local e4=rsef.QO(c,nil,{m,1},{1,m},nil,nil,LOCATION_MZONE,nil,rscost.cost2(cm.fun,cm.tgfilter,"tg",rsloc.de),nil,cm.cpop)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.otcon)
	e1:SetOperation(cm.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
end
function cm.fun(g,e,tp)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function cm.tgfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsRace(RACE_MACHINE)
end
function cm.cpop(e,tp)
	local c=e:GetHandler()
	local e1=rsef.FV_LIMIT_PLAYER({c,tp},"sp",nil,nil,{1,0},nil,{rsreset.pend,2})
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end 
	local code=e:GetLabel()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(code)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1) 
end
function cm.otfilter(c)
	return c:IsReleasable() and c:IsRace(RACE_MACHINE)
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.otfilter,tp,rsloc.de,0,nil)
	return c:IsLevelAbove(5) and minc<=1 and #mg>0 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.cfilter(c)
	return c:IsComplexType(TYPE_SPELL,true,TYPE_CONTINUOUS,TYPE_FIELD)
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	rsop.SelectToGrave(tp,cm.otfilter,tp,rsloc.de,0,1,1,nil,{REASON_RELEASE+REASON_SUMMON+REASON_MATERIAL })
end
