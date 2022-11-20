--明与宵之龙
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150088)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,cm.ffilter1,cm.ffilter2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_FUSION+REASON_MATERIAL+REASON_COST)
	local e1=rscf.SetSummonCondition(c,false,aux.fuslimit)
	local e2=rsef.SV_ADD(c,"att",ATTRIBUTE_DARK)
	e2:SetRange(LOCATION_MZONE)
	local e3=rsef.QO(c,nil,{m,0},1,"des,dis,atk,def",nil,LOCATION_MZONE,nil,nil,cm.rmtg,cm.rmop)
end
function cm.ffilter1(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and c:IsLevelAbove(5)
end
function cm.ffilter2(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsLevelAbove(5)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then return c:IsAttackAbove(800) and c:IsDefenseAbove(800) and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=rscf.GetFaceUpSelf(e)
	if not c or c:GetDefense()<800 or c:GetAttack()<800 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	local e1,e2=rsef.SV_UPDATE(c,"atk,def",-800,nil,rsreset.est_d,EFFECT_FLAG_COPY_INHERIT)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if not c:IsHasEffect(EFFECT_REVERSE_UPDATE) and #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(cm.discon)
		e1:SetOperation(cm.disop)
		e1:SetLabelObject(og)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.distg(e,c)
	local og=e:GetLabelObject()
	return og:IsExists(Card.IsOriginalCodeRule,1,nil,c:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetLabelObject()
	return og:IsExists(Card.IsOriginalCodeRule,1,nil,re:GetHandler():GetOriginalCodeRule()) and rp~=tp
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
