--虚拟水神都市 狄拉克之渊
if not pcall(function() require("expansions/script/c65020201") end) then require("script/c65020201") end
local m,cm=rscf.DefineCard(65020202,"VrAqua")
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.FTO(c,EVENT_SUMMON_SUCCESS,{m,0},{1,m},nil,"de",LOCATION_FZONE,cm.setcon,nil,rsop.target(cm.setfilter,nil,rsloc.dg),cm.setop)
	local e3=rsef.FTO(c,EVENT_CHAIN_SOLVING,{m,1},{1,m},"se,th,sum","de",LOCATION_FZONE,cm.thcon,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rsva.IsSetST(rc) and (not rc:IsRelateToEffect(re) or rc~=c)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and (rsva.filter_rl2(c) or rsva.filter_al(c))
end
function cm.setcon(e,tp,eg)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.setfilter(c)
	return rsva.IsSetST(c) and c:IsSSetable()
end
function cm.setop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local ct,og,tc=rsop.SelectSSet(tp,aux.NecroValleyFilter(cm.setfilter),tp,rsloc.dg,0,1,1,nil,{})
	if tc and Duel.GetTurnPlayer()~=tp then
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		if tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function cm.thfilter(c)
	return c:IsLevel(10) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	if not aux.ExceptThisCard(e) then return end
	if rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})>0 then
		return rsva.Summon(tp,true,true,rsva.filter_ar)
	end
end