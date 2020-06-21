--棱镜龙 黄金极限
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000060)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,4,cm.gf)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"th","de,dsp",rscon.sumtype("link"),nil,rsop.target2(cm.fun,Card.IsAbleToHand,"th",0,LOCATION_ONFIELD,1,cm.maxct),cm.tdop)
	e1:SetLabel(0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=rsef.SV_UPDATE(c,"atk",cm.val,cm.atkcon)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetCondition(cm.actcon)
	c:RegisterEffect(e4)
end
function cm.gf(g)
	return g:GetClassCount(Card.GetAttribute)==#g
end
function cm.maxct(e,tp)
	return e:GetLabel()
end
function cm.tdop(e,tp)
	rsop.SelectToHand(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,e:GetLabel(),nil,{})
end
function cm.fun(g,e,tp)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:GetClassCount(Card.GetAttribute)
	e:GetLabelObject():SetLabel(ct)
end
function cm.atkcon(e,tp)
	return e:GetHandler():GetTurnID()==Duel.GetTurnCount() and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.val(e,c)
	local g=Duel.GetMatchingGroup(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	return g:GetClassCount(Card.GetAttribute)*1000
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() and cm.atkcon(e,tp)
end