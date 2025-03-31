--叱影军幕僚-风天刈
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(130001241)
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.I(c,{m,0},nil,"des,se,th,ga",nil,LOCATION_PZONE,cm.descon,nil,rsop.target({cm.desfilter,"des",LOCATION_SZONE,0,true},{cm.thfilter,"th",rsloc.dg }),cm.desop)
	local e2=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,1},nil,nil,"de,dsp",nil,nil,rsop.target(cm.tffilter,nil,LOCATION_DECK),cm.tfop)
	local e3=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,2},nil,"tg","de,dsp",nil,nil,rsop.target(cm.tgfilter,"td",LOCATION_DECK),cm.tgop)
end
function cm.descon(e,tp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	return g:FilterCount(cm.cfilter,nil)==2
end
function cm.cfilter(c)
	return c:GetOriginalAttribute() & ATTRIBUTE_WIND ~=0 and c:GetOriginalRace() & RACE_WARRIOR ~=0
end
function cm.desfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function cm.thfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand()
end
function cm.desop(e,tp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if dg:GetCount()<2 then return end
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,rsloc.dg,0,1,1,nil,{})
end
function cm.tffilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and not c:IsLevel(1) and c:IsSetCard(0x852) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function cm.tfop(e,tp)
	rsop.SelectSolve(HINTMSG_TOFIELD,tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil,cm.tffun,tp)
end
function cm.tffun(g,tp)
	Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	return true
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and c:IsComplexType(TYPE_SPELL+TYPE_EQUIP)
end
function cm.tgop(e,tp)
	rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end