--叱影军刀匠-流霞丸
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(130001242)
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.I(c,{m,0},1,"des,atk","tg",LOCATION_PZONE,nil,nil,rstg.target(cm.desfilter,"des",LOCATION_ONFIELD),cm.desop)
	local e2=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,1},nil,"des,eq","de,dsp",nil,nil,rsop.target({aux.TRUE,"des",rsloc.ho,0,1,1,c},{cm.eqfilter,"eq",LOCATION_DECK }),cm.desop2)
	local e3=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,2},nil,"tg,rm","de,dsp",nil,nil,rsop.target({cm.tgfilter,"tg",LOCATION_SZONE },{Card.IsAbleToRemove,"rm",0,LOCATION_MZONE,true,true}),cm.rmop)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x852)
end
function cm.desfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,c)
end
function cm.desop(e,tp)
	local c=aux.ExceptThisCard(e)
	local tc=rscf.GetTargetCard()
	if not c or not tc or Duel.Destroy(tc,REASON_EFFECT)<=0 then return end
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=rscf.QuickBuff({c,tc},"atk+",1000)
	end
end
function cm.eqfilter(c,e,tp)
	return c:IsComplexType(TYPE_SPELL+TYPE_EQUIP) and c:CheckEquipTarget(e:GetHandler())
end
function cm.desop2(e,tp)
	local c=aux.ExceptThisCard(e)
	if rsop.SelectDestroy(tp,aux.TRUE,tp,rsloc.ho,0,1,1,c,{})>0 and c then
		rsop.SelectSolve(HINTMSG_EQUIP,tp,cm.eqfilter,tp,LOCATION_DECK,0,1,1,nil,cm.eqfun,e,tp)
	end
end
function cm.eqfun(g,e,tp)
	Duel.Equip(tp,g:GetFirst(),e:GetHandler())
	return true
end
function cm.tgfilter(c)
	return c:IsComplexType(TYPE_SPELL+TYPE_EQUIP) and c:IsAbleToGrave()
end
function cm.rmop(e,tp)
	if rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_SZONE,0,1,1,nil,{})>0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end