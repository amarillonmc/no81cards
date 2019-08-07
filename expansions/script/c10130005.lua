--幻层驱动 填充层
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130005
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsqd.FlipFun(c,m,"sp,th",rsop.target2(cm.fun,cm.setfilter,nil,LOCATION_DECK),cm.op)
	local e2=rsef.QO(c,nil,{m,1},{1,m+100},"pos",nil,LOCATION_HAND,nil,c.cost,rsop.target(cm.posfilter,"pos",LOCATION_MZONE),cm.posop)
	cm.QuantumDriver_EffectList={e1,e2}
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.setfilter(c,e,tp)
	if not c:IsSetCard(0xa336) or c:IsCode(m) then return false end
	if c:IsAbleToHand() then return true end
	return rsqd.SetFilter(c,e,tp)
end
function cm.op(e,tp)
	rsof.SelectHint(tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if not tc then return end
	local b1=tc:IsAbleToHand()
	local b2=rsqd.SetFilter(tc,e,tp)
	if b1 and (not b2 or Duel.SelectOption(tp,1190,aux.Stringid(m,2))==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		rsqd.SetFun(tc,e,tp)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function cm.posfilter(c)
	return c:IsFacedown() and c:IsSetCard(0xa336)
end
function cm.posop(e,tp)
	rsof.SelectHint(tp,"pos")
	local g=Duel.SelectMatchingCard(tp,cm.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
end