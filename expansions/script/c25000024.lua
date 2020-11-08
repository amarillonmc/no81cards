--超古代遗迹 露露耶
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000024)
if rsoc then return end
rsoc=cm 
rscf.DefineSet(rsoc,0xaf3)
function rsoc.SpSummonFun(c,code,stype,cate,flag,tg,op)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,stype==1 and cm.sprcon1 or cm.sprcon2,stype==1 and aux.TRUE or cm.sprop,nil,{1,code})
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{code,0},{1,code+100},cate,{flag,"de","dsp"},nil,nil,tg,cm.ssop(op))
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_SUMMON_SUCCESS)
	return e1,e2,e3
end
function cm.spcfilter(c)
	return c:IsFaceup() and rsoc.IsSet(c)
end
function cm.sprcon1(e,c,tp)
	return not Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.sprcon2(e,c,tp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.ssop(op)
	return function(e,tp,...)
		local e1=rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"sp",nil,cm.limitsptg,{1,0},nil,rsreset.pend)
		op(e,tp,...)
	end
end
function cm.limitsptg(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function rsoc.TributeFun(c,code,cate,flag,tg,op)
	local e1=rsef.STO(c,EVENT_RELEASE,{code,0},{1,code+200},cate,{flag,"de","dsp"},cm.rescon,nil,tg,op)
	return e1
end
function cm.rescon(e,tp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
-----------------------
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"se,th",nil,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e2=rsef.SV_INDESTRUCTABLE(c,"effect",aux.indoval,rscon.excard2(rsoc.IsSet,LOCATION_MZONE))
	local e3=rsef.FV_LIMIT_PLAYER(c,"cp",nil,nil,{1,1})
	local e4=rsef.FV_LIMIT_PLAYER(c,"sp",nil,cm.sptg,{1,1})
	local e5=rsef.FV_LIMIT_PLAYER(c,"act",cm.aclimit,nil,{1,1})
	local e6=rsef.FTF(c,EVENT_PHASE+PHASE_END,{m,0},1,"des",nil,LOCATION_FZONE,cm.descon,nil,rsop.target(aux.TRUE,"des"),cm.desop)
end
function cm.thfilter(c)
	return c:IsCode(25000031,25000032) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.sptg(e,c)
	return c:IsLocation(LOCATION_GRAVE)
end
function cm.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local c=re:GetHandler()
	return c:IsLocation(LOCATION_SZONE) and c:IsFacedown()
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(25000031,25000032)
end
function cm.descon(e,tp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.desop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then
		Duel.Destroy(c,REASON_EFFECT)
	end
end