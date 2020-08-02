--闪空演武
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000067)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,EVENT_SUMMON_SUCCESS,nil,{1,m,1},"dam,th","tg",cm.con,rscost.lpcost(true),rstg.target2(cm.fun,Card.IsFaceup,nil,LOCATION_MZONE),cm.act)
	local e3=rsef.RegisterClone(c,e1,"code",EVENT_SPSUMMON_SUCCESS)
	local e4=rsef.RegisterClone(c,e1,"code",EVENT_FLIP_SUMMON_SUCCESS)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.hcon)
	c:RegisterEffect(e2)	
end
function cm.hcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_SPELL+TYPE_TRAP) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function cm.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp and Duel.IsPlayerCanSendtoHand(1-tp,c)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(cm.cfilter,nil,tp)
	return #tg>0
end
function cm.fun(g,e,tp,eg)
	local tg=eg:Filter(cm.cfilter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
	for tc in aux.Next(eg) do
		tc:CreateEffectRelation(e)
	end
end
function cm.cfilter2(c,e,tp)
	return cm.cfilter(c,tp) and c:IsRelateToEffect(e)
end
function cm.act(e,tp,eg)
	local tg=eg:Filter(cm.cfilter2,nil,e,tp)
	if #tg<=0 or Duel.SendtoHand(tg,nil,REASON_RULE)<=0 then return end
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	local atk=tc:GetBaseAttack()
	if atk>0 and rsop.SelectYesNo(tp,{m,0}) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end