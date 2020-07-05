--虚拟水神要塞 特洛伊之墙
if not pcall(function() require("expansions/script/c65020201") end) then require("script/c65020201") end
local m,cm=rscf.DefineCard(65020203,"VrAqua")
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1})
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.act)
end
function cm.thfilter1(c)
	return c:IsAbleToHand() and rsva.IsSetM(c)
end 
function cm.thfilter2(c)
	return c:IsAbleToHand() and rsva.IsSet(c) and not c:IsCode(m)
end 
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.thfilter1,tp,rsloc.dg,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE,0,1,nil)
	local b3=true
	if chk==0 then return b1 or b2 or b3 end
	local op=rsop.SelectOption(tp,b1,{m,0},b2,{m,1},b3,{m,2})
	if op==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,rsloc.dg)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(0)
	end
	e:SetLabel(op)
end
function cm.act(e,tp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		if rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter1),tp,rsloc.dg,0,1,1,nil,{})>0 then
			rsva.Summon(tp,true,true,rsva.filter_a)
		end
	elseif op==2 then
		if rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter1),tp,LOCATION_GRAVE,0,1,1,nil,{})>0 then
			rsva.Summon(tp,true,true,rsva.filter_al)
		end
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DISEFFECT)
		e1:SetValue(cm.effectfilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=rsef.RegisterClone({c,tp},e1,"code",EFFECT_CANNOT_INACTIVATE)
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function cm.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local rc=te:GetHandler()
	return rsva.IsSet(rc) and rc:IsControler(e:GetHandlerPlayer())
end